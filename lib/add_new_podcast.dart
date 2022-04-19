import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frapods/main.dart';
import 'package:open_file/open_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import 'main.dart';

class AddNewPodcast extends StatefulWidget {
  //const AddNewPodcast({ Key? key }) : super(key: key);
  final Function newPodcast;
  AddNewPodcast(this.newPodcast);


  @override
  _AddNewPodcastState createState() => _AddNewPodcastState();
}

class _AddNewPodcastState extends State<AddNewPodcast> {

  final titleController = TextEditingController();
  final artistController = TextEditingController();
  final descriptionController = TextEditingController();
  final urlController = TextEditingController();

  File? file;
  File? image;

  @override
  Widget build(BuildContext context) {

    //Variables and methodes, since with the package path.dart, "Buildcontext context" only 
    //works inside "Widget build" and not in "state"

    final String fileName = file != null ? basename (file!.path) : 'no file';

    Future pickImage (ImageSource source) async {
    try{
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    final imageTemporary = File(image.path);
    //final imagePermanent = await saveImagePermanently(image.path);
    setState (() => this.image =  imageTemporary );
    //openFile(image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    }

    void showDialogMessage(String title, String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void submitData (BuildContext ctx) {
      if (titleController.text.isEmpty){
        showDialogMessage ('Title is empty', 'Please enter a title for your podcast!');
      }

      else if (artistController.text.isEmpty){
        showDialogMessage ('Title is empty', 'Please enter an artist for your podcast!');
      }

      else {widget.newPodcast(
      titleController.text, 
      artistController.text,
      descriptionController.text,
      urlController.text
    );
    Navigator.of(context).pop();
    }}

    


    //End of variables and methodes

    return ListView(
      children: [
        Card(
          elevation: 0,
          child: Container(
            margin: EdgeInsets.symmetric(vertical:10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.maxFinite,
                  child: Text('New Podcast', textAlign: TextAlign.center,style:subtitleTextStyle())
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width /2.3,
                          child: TextField(
                            decoration: InputDecoration(labelText: 'Title'),
                            controller: titleController,
                            maxLength: 50,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width /2.3,
                          child: TextField(
                            decoration: InputDecoration(labelText: 'Artist'),
                            controller: artistController,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left:30),
                      child: InkWell(
                        onTap: () => pickImage(ImageSource.gallery),
                        child: image != null ? ClipOval(
                          child: Image.file(image!, height: 100, width: 100,),)
                          :Container(
                            child: Text('upload photo'),
                            height: 100, width:100, decoration: BoxDecoration(border: Border.all(color: blueish(), width: 1)),
                          ),
                      ),
                    )
                ],),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  controller: descriptionController,
                  maxLines:10,
                  minLines: 6,
                ),
                // TextField(
                //   decoration: InputDecoration(labelText: 'URL'),
                //   controller: urlController,
                // ),

                Container(margin: EdgeInsets.symmetric(vertical: 20),child: Text('upload your first episode!')),

                InkWell(
                  onTap:() async {
                    final result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.audio);
                    if (result == null) return;
                    final path = result.files.single.path!;
                    setState(() => file = File(path));
                  },

                  child:Container(
                    width: double.maxFinite,
                    height:130,
                    decoration: BoxDecoration(border: Border.all(color: Colors.pink, width: 1)),
                    child: file != null ?  Text('$fileName') : Text('pick a file')
                  )
                ),

                SizedBox(height:20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(child: Text('Upload'),
                      onPressed: () => submitData(context),),
                      SizedBox(width: 15,),
                    OutlinedButton(child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),),
                  ],
                )
             ],
           ),
         )
        ),
      ],
    );  
  }
  
}