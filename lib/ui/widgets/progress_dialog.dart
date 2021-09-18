import 'package:flutter/material.dart';
import '../../constants.dart';

class ProgressDialog extends StatelessWidget {
  final String? message;

  const ProgressDialog({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: primaryColor,
      child: Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
             const SizedBox(
                width: 6,
              ),
             const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    primaryColor),
              ),
             const SizedBox(
                width: 26,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}