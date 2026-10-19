/**
 * FutureMe — what each AI call cost, per user.
 *
 * Every generation that reaches Anthropic (or ElevenLabs) adds one document
 * to `users/{uid}/aiUsage`: which function, which screen, the model and the
 * tokens (or characters) billed. Summed per user, that is the cost of one
 * person's journey. Answers served from a cache cost nothing and add
 * nothing. Calls made without a signed-in user go to `aiUsageAnonymous`.
 *
 * Stored under the user so that deleting the account (account.js) removes
 * it along with everything else. Recording never fails the request it
 * describes.
 */
const { db, FieldValue } = require("./platform");

async function recordAiUsage(uid, entry) {
  try {
    const collection = uid ? db.collection("users").doc(uid).collection("aiUsage") : db.collection("aiUsageAnonymous");
    await collection.add({ ...entry, createdAt: FieldValue.serverTimestamp() });
  } catch (err) {
    console.error("Could not record AI usage", err);
  }
}

/** The billed tokens of an Anthropic response. Output tokens include any thinking. */
function anthropicUsage(fn, scope, message) {
  const usage = (message && message.usage) || {};
  return {
    provider: "anthropic",
    fn,
    scope: scope || null,
    model: (message && message.model) || null,
    inputTokens: usage.input_tokens || 0,
    outputTokens: usage.output_tokens || 0,
    cacheCreationTokens: usage.cache_creation_input_tokens || 0,
    cacheReadTokens: usage.cache_read_input_tokens || 0,
  };
}

const uidOf = (context) => (context && context.auth ? context.auth.uid : null);

module.exports = { recordAiUsage, anthropicUsage, uidOf };
