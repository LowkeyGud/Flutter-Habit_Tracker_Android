import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habittracker/src/features/core/screens/app_entry_point.dart';
import 'package:habittracker/src/features/authentication/models/user_model.dart';
import 'package:habittracker/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:habittracker/src/features/authentication/screens/otp/otp_screen.dart';
import 'package:habittracker/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:habittracker/src/repository/error_handlers/default_password_reset_failure.dart';
import 'package:habittracker/src/repository/error_handlers/default_signup_failure.dart';
import 'package:habittracker/src/repository/user_repo/user_repo.dart';

import '../../features/authentication/controllers/on_boarding_controller.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final OnBoardingController _onboardingController =
      Get.put(OnBoardingController());

  final userRepoController = Get.put(UserRepo());

  //Variables
  final auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  /// Will be load when app launches this func will be called and set the firebaseUser state
  @override
  void onReady() {
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  /// Setting Intital Screen from here
  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(
            () => _onboardingController.shouldShowOnboarding
                ? const OnBoardingScreen()
                : const Welcome(),
          )
        : Get.offAll(() => const AppEntryPoint());
  }

  //FUNC
  Future<Void?> createUserWithEmailAndPassword(UserModel user) async {
    try {
      await userRepoController.createUser(user, auth);
      await sendEmailVerification();
      // firebaseUser.value != null
      //     ? Get.offAll(() => const Dashboard())
      //     : Get.to(() => const Welcome());
    } on FirebaseAuthException catch (e) {
      final ex = DefaultSignUpFailure.code(e.code);
      Get.showSnackbar(GetSnackBar(
        message: ex.message,
        duration: const Duration(seconds: 3),
      ));
    }
    return null;
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw 'Google Sign In was canceled.';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw 'An error occurred while signing in with Google.';
      }
      userRepoController.dbUpdate(user);
      // Handle successful sign-in here, e.g., store user data in GetX or navigate to another page.
    } catch (e) {
      // Handle the error here, e.g., show an error message using Get.snackbar()
      Get.snackbar('Error', e.toString());
    }
  }

  Future<Void?> loginWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = DefaultSignUpFailure.code(e.code);
      throw ex;
    } catch (_) {
      const ex = DefaultSignUpFailure();
      throw ex;
    }
    return null;
  }

  Future<void> sendEmailVerification() async {
    try {
      User? user = auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (error) {
      // Error occurred while sending the email verification code
    }
  }

  Future<void> sendPasswordResetOTP(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      // OTP verification code sent successfully
      Get.to(() => OTPScreen(
            email: email,
          ));
    } on FirebaseAuthException catch (e) {
      final ex = DefaultPasswordResetFailure.code(e.code);
      Get.showSnackbar(GetSnackBar(
        message: ex.message,
        duration: const Duration(seconds: 3),
      ));
    }
  }

  Future<void> logout() async => await auth.signOut();
}
