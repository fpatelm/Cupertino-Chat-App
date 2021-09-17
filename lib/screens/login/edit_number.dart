import 'package:cupertino_chat_app/components/logo.dart';
import 'package:cupertino_chat_app/screens/login/select_country.dart';
import 'package:cupertino_chat_app/screens/login/verify_number.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditNumber extends StatefulWidget {
  const EditNumber({Key? key}) : super(key: key);

  @override
  _EditNumberState createState() => _EditNumberState();
}

class _EditNumberState extends State<EditNumber> {
  var _enterPhoneNumber = TextEditingController();
  Map<String, dynamic> data = {"name": "Portugal", "code": "+351"};
  Map<String, dynamic>? dataResult;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Edit Number"),
        previousPageTitle: "Back",
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Logo(width: 80.0, height: 80.0, radius: 30.0),
              Text("Verification • one step",
                  style: TextStyle(
                      color: Color(0xFF08C187).withOpacity(0.7), fontSize: 30))
            ],
          ),
          Text("Enter your phone number",
              style: TextStyle(
                  color: CupertinoColors.systemGrey.withOpacity(0.7),
                  fontSize: 30)),
          CupertinoListTile(
            onTap: () async {
              dataResult = await Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SelectCountry()));
              setState(() {
                if (dataResult != null) data = dataResult!;
              });
            },
            title:
                Text(data['name'], style: TextStyle(color: Color(0xFF08C187))),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(data['code'],
                    style: TextStyle(
                        fontSize: 25, color: CupertinoColors.secondaryLabel)),
                Expanded(
                  child: CupertinoTextField(
                    placeholder: "Enter your phone number",
                    controller: _enterPhoneNumber,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontSize: 25, color: CupertinoColors.secondaryLabel),
                  ),
                )
              ],
            ),
          ),
          Text("You will receive an activation code in short time",
              style:
                  TextStyle(color: CupertinoColors.systemGrey, fontSize: 15)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: CupertinoButton.filled(
                child: Text("Request code"),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => VerifyNumber(
                                number: data['code']! + _enterPhoneNumber.text,
                              )));
                }),
          )
        ],
      ),
    );
  }
}
