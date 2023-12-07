import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/common/helpers/db_helper.dart';
import 'package:todo_app/common/routes/routes.dart';
import 'package:todo_app/common/widgets/showDialog.dart';
import 'package:todo_app/features/auth/pages/otp_page.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(auth: FirebaseAuth.instance);
});

//Here we made it accessible to the outside world :p
class AuthRepository {
  AuthRepository({required this.auth});
  final FirebaseAuth auth;

  void verifyOtp({
    required BuildContext context,
    required String smsCodeId,
    required String smsCode,
    required bool mounted,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: smsCodeId, smsCode: smsCode);

      await auth.signInWithCredential(credential);
      if (!mounted) {
        return;
      }
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    } on FirebaseAuth catch (e) {
      showAlertDialog(context: context, message: e.toString());
    }
  }

  void sendOtp({
    required BuildContext context,
    required String phone,
  }) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            showAlertDialog(context: context, message: e.toString());
          },
          codeSent: (smsCodeId, resendCodeId) {
            DbHelper.createUser(
                1); //if the user is successfully verified, we set the isVerified from 0 to 1 | This is sending a verification to the DB, that this user has been verified
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => OtpPage(
                  phone: phone,
                  smsCodeId: smsCodeId,
                ),
                settings: RouteSettings(
                    arguments: {'phone': phone, 'smsCodeId': smsCodeId}),
              ),
              (route) => false,
            );
          },
          codeAutoRetrievalTimeout: (String smsCodeId) {});
    } on FirebaseAuth catch (e) {
      showAlertDialog(context: context, message: e.toString());
    }
  }
}
