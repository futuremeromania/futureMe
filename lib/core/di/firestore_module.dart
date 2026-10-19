import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futureme/core/constants/backend.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirestoreModule {
  @lazySingleton
  FirebaseFirestore get firestore => appFirestore;
}
