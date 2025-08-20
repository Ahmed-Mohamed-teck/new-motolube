import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferencesWithCache appPrefsWithCache;

Future<void> initializeSharedPreferences() async {
  appPrefsWithCache = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
}



// Firebase instances
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final firebaseStorageProvider = Provider((ref) => FirebaseStorage.instance);