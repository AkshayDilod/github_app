import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../ui/views/main_view.dart';
import '../ui/views/otp_view.dart';
import '../ui/widgets/progress_dialog.dart';

String? currentUserUid;
String? mobileNo;
class MobileAuth{
  final auth = FirebaseAuth.instance;
  String? verificationId;
  int? forceResendToken;

  bool isUserLoggedIn() {
    var user = auth.currentUser;
    return user != null;
  }

  Future<void> signOut() async {
    await auth.signOut().then((_) {
      currentUserUid = null;
    });
  }

  Future<void> authenticateUser(BuildContext context,
      {required String mobileNo}) async {
    print('User Authentication start with this mobile number $mobileNo');
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const ProgressDialog(
            message: 'Authenticating...',
          );
        });

    await auth.verifyPhoneNumber(
      phoneNumber: mobileNo,
      timeout: Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('I am trying to login automatically...');
        auth.signInWithCredential(credential).then((result) {
          if (result.user != null) {
            currentUserUid = result.user!.uid;
            authenticationSuccess(context);
          } else {
            Fluttertoast.showToast(
              msg: 'Authentication Failed!',
              backgroundColor: Colors.red,
            );
          }
        }).catchError((err) {
          print(err);
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed');
        if (e.message!.contains('not authorized')) {
          Navigator.pop(context);
        } else if (e.message!.contains('Network')) {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: 'Network Error',
            backgroundColor: Colors.red,
          );
        } else {
          Navigator.pop(context);
        }
      },
      codeSent: (vid, resendToken) {
        Fluttertoast.showToast(
          msg: 'OTP Sent',
          backgroundColor: Colors.green,
        );
        verificationId = vid;
        forceResendToken = resendToken;
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context)=>const OtpView()), (route) => false);
      },
      codeAutoRetrievalTimeout: (verificationId) {
      },
    );
  }

  Future<bool> signInWithOtp(context, {required String smsCode}) async {
    bool res = false;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: smsCode);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const ProgressDialog(
            message: 'Verifying...',
          );
        });

    try {
      UserCredential result = await auth.signInWithCredential(credential);
      if (result.user != null) {
        currentUserUid = result.user!.uid;
        Navigator.pop(context);
        authenticationSuccess(context);
        res = true;
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: 'Wrong OTP',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print(e);
    }

    return res;
  }

  void resendOtp(context, {required String phoneNumber}) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('I am trying to login automatically...');

        try {
          UserCredential result = await auth.signInWithCredential(credential);
          if (result.user != null) {
            currentUserUid = result.user!.uid;
            authenticationSuccess(context);
          } else {}
        } catch (e) {
          print(e);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed');
        if (e.message!.contains('not authorized')) {
          Navigator.pop(context);
        } else if (e.message!.contains('Network')) {
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      },
      codeSent: (vid, resendToken) {
        verificationId = vid;
        forceResendToken = resendToken;
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context)=>const OtpView()), (route) => false);
        print('otp send to user device successfully');
      },
      codeAutoRetrievalTimeout: (verificationId) {
        print('code auto retrieval time out');
      },
    );
  }

  Future<void> authenticationSuccess(context) async {
    Fluttertoast.showToast(
      msg: 'Logged in Successfully',
      backgroundColor: Colors.green,
    );
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainView()), (route) => false);
  }
}