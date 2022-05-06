import 'package:cupertino_chat_app/screens/login/user_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Status { Waiting, Error }

class VerifyNumber extends StatefulWidget {
  const VerifyNumber({Key? key, this.number}) : super(key: key);
  final number;
  @override
  _VerifyNumberState createState() => _VerifyNumberState(number);
}

class _VerifyNumberState extends State<VerifyNumber> {
  final phoneNumber;
  var _status = Status.Waiting;
  var _verificationId;
  var _textEditingController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  _VerifyNumberState(this.phoneNumber);

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  Future _verifyPhoneNumber() async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phonesAuthCredentials) async {},
        verificationFailed: (verificationFailed) async {},
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            this._verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  Future _sendCodeToFirebase({String? code}) async {
    if (this._verificationId != null) {
      var credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code!);

      await _auth
          .signInWithCredential(credential)
          .then((value) {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => UserName()));
          })
          .whenComplete(() {})
          .onError((error, stackTrace) {
            setState(() {
              _textEditingController.text = "";
              this._status = Status.Error;
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Verify Number"),
        previousPageTitle: "Edit Number",
      ),
      child: _status != Status.Error
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text("OTP Verification",
                      style: TextStyle(
                          color: Color(0xFF08C187).withOpacity(0.7),
                          fontSize: 30)),
                ),
                Text("Enter OTP sent to",
                    style: TextStyle(
                        color: CupertinoColors.secondaryLabel, fontSize: 20)),
                Text(phoneNumber == null ? "" : phoneNumber),
                CupertinoTextField(
                    onChanged: (value) async {
                      print(value);
                      if (value.length == 6) {
                        //perform the auth verification
                        _sendCodeToFirebase(code: value);
                      }
                    },
                    textAlign: TextAlign.center,
                    style: TextStyle(letterSpacing: 30, fontSize: 30),
                    maxLength: 6,
                    controller: _textEditingController,
                    keyboardType: TextInputType.number),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Didn't receive the OTP?"),
                    CupertinoButton(
                        child: Text("RESEND OTP"),
                        onPressed: () async {
                          setState(() {
                            this._status = Status.Waiting;
                          });
                          _verifyPhoneNumber();
                        })
                  ],
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text("OTP Verification",
                      style: TextStyle(
                          color: Color(0xFF08C187).withOpacity(0.7),
                          fontSize: 30)),
                ),
                Text("The code used is invalid!"),
                CupertinoButton(
                    child: Text("Edit Number"),
                    onPressed: () => Navigator.pop(context)),
                CupertinoButton(
                    child: Text("Resend Code"),
                    onPressed: () async {
                      setState(() {
                        this._status = Status.Waiting;
                      });

                      _verifyPhoneNumber();
                    }),
              ],
            ),
    );
  }
}
