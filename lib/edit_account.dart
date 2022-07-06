import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'package:frapods/backend_api.dart';
import 'package:frapods/main.dart';
import 'package:image_picker/image_picker.dart';

class EditAccount extends StatefulWidget {

  const EditAccount({Key? key, required this.currentUsername, required this.currentEmail, required this.currentProfilePicture, required this.successCallback}): super(key: key);

  //following parameters MUST be passed:
  final String currentUsername;
  final String currentEmail;
  final String currentProfilePicture;
  final Function successCallback;

  @override
  State<EditAccount> createState() {
    return _EditAccountState();
  }
}


class _EditAccountState extends State<EditAccount> {
  // declare variables here:
  final userNameController = TextEditingController();
  final emailController = TextEditingController();

  int thumbnailId = 0;
  String image = "";
  File? imageTemporary;

  @override
  Widget build(BuildContext context) {
    //variables:

    image = widget.currentProfilePicture;

    Future pickImage(ImageSource source) async {
      try {
        final image = await ImagePicker().pickImage(source: source);
        if (image == null) return;
        setState(() => imageTemporary = File(image.path));
        thumbnailId = await BackendApi().uploadThumbnail(image.readAsBytes());
        setState(() => this.image = apiDomain + "getImage.php?size=512&bw=0&circle=0&file_id=" + thumbnailId.toString());
      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
      }
    }

    void submitData() async {
      String _username = userNameController.text;
      String _email = emailController.text;
      BackendApi().editAccountData(_username, _email, thumbnailId).then((value) => widget.successCallback(value));
    }

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
          actions:[ IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                submitData();
                Navigator.pop(context);
              }),]
        //title: const Text('Edit account')
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 10),
                  child: Text("Edit account",
                    style: subtitleTextStyle(),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: Text("Change username:", 
                    style: normalTextStyle2(),
                    textAlign: TextAlign.left,
                  )
                ),
                Container(
                      width: double.maxFinite,
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                      child: TextField(
                        //style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          hintText: widget.currentUsername, filled: true,
                        ),
                        controller: userNameController,
                      ),
                    ),

                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: Text("Change email address:", 
                    style: normalTextStyle2(),
                    textAlign: TextAlign.left,
                  )
                ),
                Container(
                      width: double.maxFinite,
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                      child: TextField(
                        //style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          hintText:widget.currentEmail, filled: true,
                        ),
                        controller: emailController,
                      ),
                    ),

                InkWell(
                  onTap: () => pickImage(ImageSource.gallery),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.fromLTRB(15, 5, 20, 15),
                          child: Text("Upload new icon:",
                            style: normalTextStyle2(),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(right: 10,top:10),
                          child: Image.network(
                            image,
                            height: 90,
                            width: 90,
                              fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Theme.of(context).colorScheme.onBackground),
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(7), left: Radius.circular(7))
                          ),
                          height: 90,
                          width: 90,
                        ),
                        Container(margin: const EdgeInsets.only(top:10), child: const Icon(Icons.arrow_forward_ios_rounded, size: 20,)),
                        const SizedBox(width:10)
                      ]
                  ),
                ),
              ],
            ),
          ),
        ),
      
    );
  }
}


