import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../screens/login_signup/model/user_model.dart';

class AuthDB {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credentials = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return await getUserById(credentials.user!.uid);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserModel> getUserById(String userId) async {
    try {
      final snapshot = await _firestore.collection("users").doc(userId).get();
      if (snapshot.exists) {
        final data = snapshot.data();

        return UserModel.fromJson(data!);
      } else {
        throw "No User found";
      }
    } on FirebaseException {
      rethrow;
    }
  }

  Future<User> signUpWithEmailAndPassword(
      {required UserModel user, required String password}) async {
    try {
      final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.email, password: password);

      user.uid = credentials.user!.uid;
      await _firestore
          .collection("users")
          .doc(credentials.user!.uid)
          .set(user.toJson());

      return credentials.user!;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> updateUser({required UserModel user}) async {
    try {
      await _firestore.collection("users").doc(user.uid).update(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  User? isCurrentUser() {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser;
    }
    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> removeMachinery({required String machineId}) async {
    await _firestore.collection("machineries").doc(machineId).delete();
  }

 
  // Future<void> deleteImage(String imageUrl) async {
  //   // Convert the URL into a Reference
  //   Reference ref = storage.refFromURL(imageUrl);

  //   try {
  //     await ref.delete();
  //     print('Image deleted successfully');
  //   } catch (e) {
  //     print('Failed to delete image: $e');
  //   }
  // }

  Future<void> deleteImage({required String url}) async {
    try {
      final storage = FirebaseStorage.instance;
      final ref;
      if (url.startsWith('gs://') || url.startsWith('https')) {
        ref = storage.refFromURL(url);
        await storage.ref(ref.fullPath).delete();
      }
    } catch (e) {
      rethrow;
    }
  }


}
