import 'dart:convert';
import 'dart:io';
//import 'dart:html';
import 'dart:typed_data';
import 'package:frapods/backend_api.dart';
import 'package:frapods/podcast_info.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frapods/main.dart';
import 'package:open_file/open_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class AddNewPodcast extends StatefulWidget {
  //const AddNewPodcast({ Key? key }) : super(key: key);
  final Function newPodcast;
  final int id;

  AddNewPodcast(this.newPodcast, this.id);

  @override
  _AddNewPodcastState createState() => _AddNewPodcastState();
}

class _AddNewPodcastState extends State<AddNewPodcast> {

  final titleController = TextEditingController();
  final artistController = TextEditingController();
  final descriptionController = TextEditingController();
  final urlController = TextEditingController();

  Uint8List? file;
  String fileName = 'no file';
  File? audioFile;
  String image = api_domain + "getImage.php?file_id=0&bw=0&circle=0&size=512";
  bool step1 = true;
  bool getWidgetData = true;
  bool edit = false;
  double? popupHeight = 0.25;
  PodcastInfo newPodcast = PodcastInfo("", "", "", "", "", 0);
  int newPodcastId = 0;
  int thumbnailId = 0;

  @override
  Widget build(BuildContext context) {

    //Variables and methods, since with the package path.dart, "BuildContext context" only
    //works inside "Widget build" and not in "state"

    //final String fileName = file != null ? basename (file!.path) : 'no file';

    if(widget.id != 0 && getWidgetData) {
      getWidgetData = false;
      step1 = false;
      edit = true;
      popupHeight = 0.5;
      BackendApi().getPodcastData(widget.id).then((value) {
        setState(() { this.image = value.thumbnail; newPodcast = value; });
      });
    }

    Future pickImage (ImageSource source) async {
      try{
        final image = await ImagePicker().pickImage(source: source);
        if (image == null) return;
        thumbnailId = await BackendApi().uploadThumbnail(image.readAsBytes());
        setState (() => this.image =  api_domain + "getImage.php?size=512&bw=0&circle=0&file_id=" + thumbnailId.toString() );
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

    void submitAudio(BuildContext ctx) async {
      if(file != null) {
        newPodcastId = await BackendApi().uploadPodcast(file);
        newPodcast = await BackendApi().getPodcastData(newPodcastId);
        setState(() => { step1 = false, popupHeight = 0.5 });
      }
    }

    void submitData (BuildContext ctx) {
      if (titleController.text.isEmpty){
        showDialogMessage ('Title is empty', 'Please enter a title for your podcast!');
      } else if (artistController.text.isEmpty){
        showDialogMessage ('Artist name is empty', 'Please enter an artist for your podcast!');
      } else {
        var submitId = edit ? widget.id : newPodcastId;
        print(submitId);
        PodcastInfo newData = PodcastInfo(titleController.text, descriptionController.text, artistController.text, urlController.text, thumbnailId.toString(), submitId);
        BackendApi().editPodcastData(newData);
        widget.newPodcast(
          titleController.text,
          artistController.text,
          descriptionController.text,
          urlController.text
        );
        Navigator.of(context).pop();
      }
    }

    //End of variables and methods

    if(step1) {
      return FractionallySizedBox(
        //behavior: HitTestBehavior.opaque,
          heightFactor: popupHeight,
          child: ListView(
            children: [
              Card(
                  elevation: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.all(10),
                            width: double.maxFinite,
                            child: Text('New Podcast', textAlign: TextAlign.center,
                                style: subtitleTextStyle())
                        ),

                        Container(margin: const EdgeInsets.symmetric(vertical: 20),
                            child: const Text('Upload your podcast!',
                              style: TextStyle(fontSize: 18),)),

                        InkWell(
                            onTap: () async {
                              final result = await FilePicker.platform.pickFiles(
                                  allowMultiple: false, type: FileType.audio);
                              if (result == null) return;
                              fileName = basename(result.files.single.name);
                              setState(() => file = result.files.single.bytes!);
                            },

                            child: Container(
                                width: double.maxFinite,
                                height: 40,
                                decoration: BoxDecoration(border: Border.all(
                                    color: Colors.pink, width: 1)),
                                child: file != null ? Text(fileName) : const Text(
                                    'pick a file')
                            )
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(child: Text('Upload'),
                              onPressed: () => submitAudio(context),),
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
          )
      );
    } else {
      return FractionallySizedBox(
        //behavior: HitTestBehavior.opaque,
          heightFactor: popupHeight,
          child: ListView(
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
                      child: Text('Podcast Details', textAlign: TextAlign.center,style:subtitleTextStyle())
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                //margin: EdgeInsets.fromLTRB(left, top, right, bottom),
                                width: MediaQuery.of(context).size.width /2.3,
                                child: TextField(
                                  decoration: const InputDecoration(labelText: 'Title', ),
                                  controller: titleController..text = newPodcast.title,
                                  maxLength: 50,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width /2.3,
                                child: TextField(
                                  decoration: const InputDecoration(labelText: 'Artist',),
                                  controller: artistController..text = newPodcast.artist,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left:30),
                            child: InkWell(
                              onTap: () => pickImage(ImageSource.gallery),
                              child: image != null ? Container(
                                child: Image.network(image, height: 100, width: 100))
                                :Container(
                                  child: const Text('upload thumbnail'),
                                  height: 100, width:100, decoration: BoxDecoration(border: Border.all(color: blueish(), width: 1)),
                                ),
                            ),
                          )
                      ],),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                      controller: descriptionController..text = newPodcast.description,
                      maxLines:10,
                      minLines: 6,
                    ),
                    // TextField(
                    //   decoration: InputDecoration(labelText: 'URL'),
                    //   controller: urlController,
                    // ),

                    const SizedBox(height:20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(child: Text((edit ? 'Update' : 'Publish')),
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
        )
      );
    }
  }
  
}