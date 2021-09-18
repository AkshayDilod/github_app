import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants.dart';
import '../../services/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpView extends StatefulWidget {
  const OtpView({Key? key}) : super(key: key);

  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final otpController = TextEditingController();
  int interval = 60;
  bool otpTimeOut = false;

  Timer? timer;

  void otpTimer() {
    Timer.periodic(const Duration(seconds: 1), (_timer) {
      timer = _timer;
      if (interval == 0) {
        setState(() {
          otpTimeOut = true;
          _timer.cancel();
        });
      } else {
        setState(() {
          interval--;
        });
      }
    });
  }

  @override
  void initState() {
    otpTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  final _fkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = context.read<MobileAuth>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
          child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Form(
          key: _fkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Enter Received OTP $mobileNo',
                style: theme.textTheme.headline6?.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PinCodeTextField(
                  autovalidateMode: AutovalidateMode.disabled,
                  appContext: context,
                  length: 6,
                  blinkWhenObscuring: false,
                  cursorColor: Colors.blue,
                  controller: otpController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      Fluttertoast.showToast(msg: 'OTP is required!');
                      return "OTP is required!";
                    } else if (value.length < 6) {
                      Fluttertoast.showToast(msg: 'OTP must be have 6 digits');
                      return "OTP must be have 6 digits";
                    }
                  },
                  onChanged: (value) {},
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.apply(color: Colors.black),
                  pinTheme: PinTheme(
                    // activeColor: Colors.red,
                    inactiveFillColor: Colors.white,
                    activeFillColor: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                    borderWidth: 1.5,
                    inactiveColor: Colors.white,
                    shape: PinCodeFieldShape.box,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (otpTimeOut == false)
                Text(
                  'Resend OTP after $interval\'s',
                  style:
                      theme.textTheme.subtitle1?.copyWith(color: Colors.white),
                ),
              if (otpTimeOut == true)
                GestureDetector(
                    onTap: () {
                      authService.resendOtp(context, phoneNumber: mobileNo!);
                    },
                    child: Text(
                      'Resend OTP',
                      style: theme.textTheme.subtitle1
                          ?.copyWith(color: Colors.blue),
                    )),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    'Verify OTP',
                    style: theme.textTheme.headline6
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if (_fkey.currentState!.validate()) {
                    authService.signInWithOtp(context,
                        smsCode: otpController.text.trim());
                  }
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
