// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:cloud_functions/cloud_functions.dart' as _i809;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../age/age_range_signal_service.dart' as _i980;
import '../audio/tts_service.dart' as _i384;
import '../auth/auth_service.dart' as _i88;
import '../chat/chat_api_service.dart' as _i961;
import '../chat/chat_session_result_builder.dart' as _i110;
import '../data/ai_content_repository.dart' as _i380;
import '../data/chat_repository.dart' as _i534;
import '../data/consent_repository.dart' as _i1057;
import '../data/module_progress_repository.dart' as _i8;
import '../data/user_repository.dart' as _i925;
import '../subscription/subscription_service.dart' as _i725;
import 'firebase_module.dart' as _i616;
import 'firestore_module.dart' as _i431;
import 'functions_module.dart' as _i637;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final firebaseModule = _$FirebaseModule();
  final firestoreModule = _$FirestoreModule();
  final functionsModule = _$FunctionsModule();
  gh.lazySingleton<_i980.AgeRangeSignalService>(
    () => _i980.AgeRangeSignalService(),
  );
  gh.lazySingleton<_i384.TtsService>(() => _i384.TtsService());
  gh.lazySingleton<_i961.ChatApiService>(() => _i961.ChatApiService());
  gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
  gh.lazySingleton<_i974.FirebaseFirestore>(() => firestoreModule.firestore);
  gh.lazySingleton<_i809.FirebaseFunctions>(() => functionsModule.functions);
  gh.lazySingleton<_i725.SubscriptionService>(
    () => _i725.SubscriptionService(),
  );
  gh.lazySingleton<_i88.AuthService>(
    () => _i88.AuthService(
      gh<_i59.FirebaseAuth>(),
      gh<_i725.SubscriptionService>(),
    ),
  );
  gh.lazySingleton<_i380.AiContentRepository>(
    () => _i380.AiContentRepository(gh<_i809.FirebaseFunctions>()),
  );
  gh.lazySingleton<_i1057.ConsentRepository>(
    () => _i1057.ConsentRepository(gh<_i809.FirebaseFunctions>()),
  );
  gh.lazySingleton<_i534.ChatRepository>(
    () => _i534.ChatRepository(gh<_i974.FirebaseFirestore>()),
  );
  gh.lazySingleton<_i8.ModuleProgressRepository>(
    () => _i8.ModuleProgressRepository(
      gh<_i974.FirebaseFirestore>(),
      gh<_i809.FirebaseFunctions>(),
    ),
  );
  gh.lazySingleton<_i925.UserRepository>(
    () => _i925.UserRepository(
      gh<_i974.FirebaseFirestore>(),
      gh<_i809.FirebaseFunctions>(),
    ),
  );
  gh.lazySingleton<_i110.ChatSessionResultBuilder>(
    () => _i110.ChatSessionResultBuilder(
      gh<_i8.ModuleProgressRepository>(),
      gh<_i925.UserRepository>(),
    ),
  );
  return getIt;
}

class _$FirebaseModule extends _i616.FirebaseModule {}

class _$FirestoreModule extends _i431.FirestoreModule {}

class _$FunctionsModule extends _i637.FunctionsModule {}
