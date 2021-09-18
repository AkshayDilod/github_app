import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants.dart';
import '../../services/biomertric_service.dart';
import '../../services/firebase_auth.dart';
import 'main_view.dart';
import 'package:provider/src/provider.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final _fKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    var sizedBox = const SizedBox(
      height: 15,
    );
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        width: double.infinity,
        child: Form(
          key: _fKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(
                Icons.phone,
                size: 80,
                color: Colors.white,
              ),
              sizedBox,
              Text(
                'Login With Mobile No',
                style: theme.textTheme.headline6?.copyWith(color: Colors.white),
              ),
              sizedBox,
              Container(
                width: size.width * .8,
                child: TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Mobile number is required.';
                    } else if (val.length < 10) {
                      return 'Please enter 10 digits mobile number.';
                    } else {
                      mobileNo = '+91' + val;
                    }
                  },
                  maxLength: 10,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  style: theme.textTheme.subtitle1,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefix: const Text('+91  '),
                      hintText: 'Enter 10 digit mobile number',
                      errorStyle: theme.textTheme.subtitle1?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                ),
              ),
              sizedBox,
              ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    'Continue With Mobile',
                    style: theme.textTheme.headline6
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if (_fKey.currentState!.validate()) {
                    context
                        .read<MobileAuth>()
                        .authenticateUser(context, mobileNo: mobileNo!);
                  }
                },
              ),
              sizedBox,
              Text(
                'OR',
                style: theme.textTheme.headline6?.copyWith(color: Colors.white),
              ),
              sizedBox,
              TextButton.icon(
                icon: const Icon(
                  Icons.fingerprint,
                  size: 70,
                ),
                label: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    'Login With BioMetric',
                    style: theme.textTheme.headline6
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  bool res = await context
                      .read<AuthWithBiometric>()
                      .authenticationUserWithBiometric();
                  if (res) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MainView()),
                        (route) => false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
