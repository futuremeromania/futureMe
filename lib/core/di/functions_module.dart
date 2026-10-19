import 'package:cloud_functions/cloud_functions.dart';
import 'package:futureme/core/constants/backend.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FunctionsModule {
  @lazySingleton
  FirebaseFunctions get functions => appFunctions;
}
