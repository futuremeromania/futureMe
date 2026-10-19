/**
 * FutureMe — ElevenLabs text-to-speech with Storage caching.
 *
 * Takes the text the app would have spoken on-device and returns a URL to an
 * MP3 in the user's own voice clone. Audio is cached by SHA-256 of the text,
 * so repeated or shared copy is synthesized (and paid for) exactly once.
 *
 * Set both secrets once before deploying:
 *   firebase functions:secrets:set ELEVENLABS_API_KEY
 *   firebase functions:secrets:set ELEVENLABS_VOICE_ID
 */

const functions = require("firebase-functions/v1");
const crypto = require("crypto");

const { region, audioBucket } = require("./platform");
const { recordAiUsage, uidOf } = require("./usage");

const MODEL_ID = "eleven_multilingual_v2";
const RUNTIME = {
  secrets: ["ELEVENLABS_API_KEY", "ELEVENLABS_VOICE_ID"],
  timeoutSeconds: 120,
  memory: "512MB",
};

exports.synthesizeSpeech = region.runWith(RUNTIME).https.onCall(async (data, context) => {
  const text = data && typeof data.text === "string" ? data.text.trim() : "";
  if (!text) {
    throw new functions.https.HttpsError("invalid-argument", "text is required.");
  }
  if (text.length > 10000) {
    throw new functions.https.HttpsError("invalid-argument", "text exceeds 10000 characters.");
  }

  const voiceId = process.env.ELEVENLABS_VOICE_ID;
  const hash = crypto.createHash("sha256").update(`${voiceId}:${MODEL_ID}:${text}`).digest("hex");
  const path = `tts/${hash}.mp3`;

  const bucket = audioBucket();
  const file = bucket.file(path);

  const [exists] = await file.exists();
  if (exists) {
    const [meta] = await file.getMetadata();
    return { url: downloadUrl(bucket.name, path, meta.metadata.firebaseStorageDownloadTokens) };
  }

  // Long texts are spoken in pieces of a few sentences each: in one long
  // request the voice model can stop before the end, sometimes in the middle
  // of a word. Each piece gets its neighbours as context so the intonation
  // still runs on, and the MP3 pieces are joined back into one file.
  const chunks = splitForSpeech(text);
  const parts = [];
  for (let i = 0; i < chunks.length; i++) {
    parts.push(
      await synthesizeChunk(voiceId, {
        text: chunks[i],
        model_id: MODEL_ID,
        ...(i > 0 ? { previous_text: chunks[i - 1] } : {}),
        ...(i < chunks.length - 1 ? { next_text: chunks[i + 1] } : {}),
      })
    );
  }

  // ElevenLabs bills by characters: the text actually spoken is recorded.
  await recordAiUsage(uidOf(context), { provider: "elevenlabs", fn: "synthesizeSpeech", model: MODEL_ID, characters: text.length });

  const token = crypto.randomUUID();
  await file.save(Buffer.concat(parts), {
    contentType: "audio/mpeg",
    metadata: { metadata: { firebaseStorageDownloadTokens: token } },
  });

  return { url: downloadUrl(bucket.name, path, token) };
});

const MAX_CHUNK_CHARS = 900;

/** Splits [text] at sentence ends into pieces of at most MAX_CHUNK_CHARS (a longer single sentence stays whole). */
function splitForSpeech(text) {
  if (text.length <= MAX_CHUNK_CHARS) return [text];
  const sentences = text.match(/[^.!?…]+[.!?…]+["”»]*\s*|[^.!?…]+$/g) || [text];
  const chunks = [];
  let current = "";
  for (const sentence of sentences) {
    if (current && current.length + sentence.length > MAX_CHUNK_CHARS) {
      chunks.push(current.trim());
      current = "";
    }
    current += sentence;
  }
  if (current.trim()) chunks.push(current.trim());
  return chunks;
}

async function synthesizeChunk(voiceId, body) {
  let response;
  try {
    response = await fetch(`https://api.elevenlabs.io/v1/text-to-speech/${voiceId}`, {
      method: "POST",
      headers: {
        "xi-api-key": process.env.ELEVENLABS_API_KEY,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    });
  } catch (err) {
    throw new functions.https.HttpsError("internal", `ElevenLabs call failed: ${err.message}`);
  }
  if (!response.ok) {
    const detail = await response.text();
    throw new functions.https.HttpsError("internal", `ElevenLabs returned ${response.status}: ${detail}`);
  }
  return Buffer.from(await response.arrayBuffer());
}

function downloadUrl(bucketName, path, token) {
  return `https://firebasestorage.googleapis.com/v0/b/${bucketName}/o/${encodeURIComponent(path)}?alt=media&token=${token}`;
}