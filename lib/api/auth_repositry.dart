import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tottracker/NEW_SCREENS/features_overview_screen.dart';
import 'package:tottracker/NEW_SCREENS/first_screen.dart';
import 'package:tottracker/NEW_SCREENS/main_screen.dart';
import 'package:tottracker/NEW_SCREENS/monitoring_screen.dart';
import 'package:tottracker/models/signup_email_password_failure.dart';

// Removed unused BeginningScreen import

class AuthenticationRepositry extends GetxController {
  static AuthenticationRepositry get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
    super.onReady();
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const FirstScreen())
        : Get.offAll(() => const BeginningScreen());
  }

  dialog(String error) {
    Get.dialog(
      AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(error),
        actions: <Widget>[
          OutlinedButton(
            child: Text('Okay'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value == null
          ? Get.offAll(() => const MainScreen())
          : Get.offAll(() => const BeginningScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      dialog(ex.message);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      dialog(ex.message);
      throw ex;
    }
  }

  Future<void> createUserWithEmailAndPasswordandLinkAccount(
      String email, String password, String linkedAccount) async {
    try {
      // final currentUser = FirebaseAuth.instance.currentUser;
      // final otherUserCredential = EmailAuthProvider.credential(
      //   email: email,
      //   password: password,
      // );
      // List<UserInfo> providerData = currentUser!.providerData;
      // final isAlreadyLinked = providerData.any(
      //     (provider) => provider.providerId == otherUserCredential.providerId);

      // if (isAlreadyLinked) {
      //   // Provider is already linked to user's account, handle error accordingly.
      //   print('Error: Provider is already linked to user\'s account');
      // } else {
      //   // Provider is not linked to user's account, link the account.
      //   try {
      //     final authResult =
      //         await currentUser.linkWithCredential(otherUserCredential);
      //     print('Successfully linked account');
      //   } catch (e) {
      //     print('Error linking account: $e');
      //   }
      // }
      firebaseUser.value == null
          ? Get.offAll(() => const MainScreen())
          : Get.offAll(() => const FeaturesOverviewScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      dialog(ex.message);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      dialog(ex.message);
      throw ex;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        dialog('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        dialog('Wrong password provided for that user.');
      } else {
        dialog(e.code);
      }
    } catch (e) {
      dialog(e as String);
    }
  }

  Future<void> logOut() async => await _auth.signOut();
}
