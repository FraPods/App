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
  final tagController = TextEditingController();

  List <String> tags = [];

  Uint8List? file;
  String fileName = 'no file';
  File? audioFile;
  String image = "";
  bool step1 = false;
  bool getWidgetData = true;
  bool edit = false;
  double? popupHeight = 0.6;
  PodcastInfo newPodcast = PodcastInfo();
  int newPodcastId = 0;
  int thumbnailId = 0;
  File? imageTemporary;

  @override
  Widget build(BuildContext context) {
    //Variables and methods, since with the package path.dart, "BuildContext context" only
    //works inside "Widget build" and not in "state"

    //final String fileName = file != null ? basename (file!.path) : 'no file';

    final _keyboardVisible = MediaQuery.of(context).viewInsets.bottom !=0;

    if (widget.id != 0 && getWidgetData) {
      getWidgetData = false;
      step1 = false;
      edit = true;
      BackendApi().getPodcastData(widget.id).then((value) {
        setState(() {
          if(value.thumbnail != (api_domain + "getImage.php?size=512&bw=0&circle=0&file_id=0")) { image = value.thumbnail; }
          newPodcast = value;
        });
      });
    }

    if(step1==true){
      setState(() {
        popupHeight=0.6;
      });
    } else {setState(() {
      popupHeight=0.65;
    });}

    Future pickImage(ImageSource source) async {
      try {
        final image = await ImagePicker().pickImage(source: source);
        if (image == null) return;
        setState(() => imageTemporary = File(image.path));
        thumbnailId = await BackendApi().uploadThumbnail(image.readAsBytes());
        setState(() => this.image = api_domain + "getImage.php?size=512&bw=0&circle=0&file_id=" + thumbnailId.toString());
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
                child: const Text("Close"),
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
      if (file != null) {
        newPodcastId = await BackendApi().uploadPodcast(file);
        newPodcast = await BackendApi().getPodcastData(newPodcastId);
        setState(() => { step1 = false});
      }
    }

    void submitData(BuildContext ctx) async {
      if (titleController.text.isEmpty) {
        showDialogMessage(
            'Title is empty', 'Please enter a title for your podcast!');
      } else if (artistController.text.isEmpty) {
        showDialogMessage(
            'Artist name is empty', 'Please enter an artist for your podcast!');
      } else {
        var submitId = edit ? widget.id : newPodcastId;
        if(thumbnailId == 0 && edit) {
          var qP = Uri.parse(image).queryParameters;
          String tempThumbId = "0${qP["file_id"]}";
          try {
            thumbnailId = int.parse(tempThumbId);
          } on Exception catch(_) {
            thumbnailId = 0;
          }
        }
        PodcastInfo newData = PodcastInfo.create(
            titleController.text, descriptionController.text,
            artistController.text, urlController.text, thumbnailId.toString(),
            submitId, "");
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

    if (step1) {
      return FractionallySizedBox(
        //behavior: HitTestBehavior.opaque,
          heightFactor: popupHeight,
          child: ListView(
            children: [
              Card(
                  elevation: 0,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .background,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.all(10),
                            width: double.maxFinite,
                            child: Text(
                                'New Podcast', textAlign: TextAlign.center,
                                style: subtitleTextStyle())
                        ),

                        Container(
                            margin: const EdgeInsets.only(bottom: 20, top: 10),
                            child: const Text('Upload your podcast!',
                              style: TextStyle(fontSize: 20),)),

                        InkWell(
                            onTap: () async {
                              final result = await FilePicker.platform
                                  .pickFiles(
                                  allowMultiple: false, type: FileType.audio);
                              if (result == null) return;
                              fileName = basename(result.files.single.name);
                              setState(() => file = result.files.single.bytes!);
                            },

                            child: Container(
                                width: double.maxFinite,
                                height: 120,
                                child: Card(
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .secondary,
                                  child: file != null ? Text(
                                    fileName,
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                      : const Center(
                                    child: Text(
                                      'pick a file',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 19),
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,),
                                  ),
                                )
                            )
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(child: const Text('Upload'),
                              onPressed: () => submitAudio(context),),
                            const SizedBox(width: 15,),
                            OutlinedButton(child: const Text('Cancel'),
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
          heightFactor: _keyboardVisible? 0.7 : popupHeight,
          child: ListView(
            children: [
              Card(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .background,
                  elevation: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(15, 15, 10, 0),
                            width: double.maxFinite,
                            child: Text(
                                'Podcast Details', textAlign: TextAlign.center,
                                style: subtitleTextStyle())
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20.0, left: 0, top: 0),
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width - 180,
                                    //height: 80,
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        labelText: 'Title',),
                                      controller: titleController
                                        ..text = newPodcast.title,
                                      maxLength: 64,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 180,
                                    //height: 60,
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        labelText: 'Artist',),
                                      controller: artistController
                                        ..text = newPodcast.artist,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer (),
                            Column(
                              children: [
                                const SizedBox(height:5),
                                InkWell(
                                  onTap: () => pickImage(ImageSource.gallery),
                                  child: image != "" ? Container(
                                      margin: const EdgeInsets.all(2),
                                      child: Image.network(
                                          image,
                                          height: 110,
                                          width: 110,
                                          fit: BoxFit.cover,
                                        ),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: Theme.of(context).colorScheme.onBackground),
                                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(7), left: Radius.circular(7))
                                      ),
                                      height: 110,
                                      width: 110,
                                    ) : Container(
                                    child: const Center(
                                        child: Text('Upload Thumbnail',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 15),)
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Theme
                                          .of(context)
                                          .colorScheme
                                          .onBackground),
                                      borderRadius: const BorderRadius.horizontal(
                                          right: Radius.circular(7),
                                          left: Radius.circular(7)
                                      ),
                                    ),
                                    height: 110, width: 110,
                                  ),
                                ),
                              ],)
                          ],),
                          Container(
                            width: double.maxFinite,
                            //height:70,
                            child: TextField(
                              controller: tagController,
                              decoration: const InputDecoration(hintText: 'Add tags for your podcast', ),
                              maxLines: 1,
                              onSubmitted: (String x)
                              {setState(() {
                                // FocusScopeNode currentFocus = FocusScope.of(context);
                                //   if (!currentFocus.hasPrimaryFocus) {
                                //     currentFocus.unfocus();
                                //   }
                                tags.add(tagController.value.text);
                                tagController.clear();
                              });}
                            ),
                          ),
                          tags.isEmpty? const SizedBox()
                          :Column(
                            children: [
                              const SizedBox(height: 10,),
                              Container(
                                height: 35,
                                width: double.maxFinite,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tags.length,
                                  itemBuilder: (ctx, index) => tagWidget(tags[index], index,context)),
                              ),
                            ],
                          ),

                          const SizedBox(height:20),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Description',
                              border: OutlineInputBorder()),
                          controller: descriptionController
                            ..text = newPodcast.description,
                          maxLines: 10,
                          minLines: 6,
                        ),
                        // TextField(
                        //   decoration: InputDecoration(labelText: 'URL'),
                        //   controller: urlController,
                        // ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              child: Text((edit ? 'Update' : 'Publish')),
                              onPressed: () => submitData(context),),
                            const SizedBox(width: 15,),
                            OutlinedButton(child: const Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop()),
                          ],
                        ),
                        SizedBox(height:_keyboardVisible? MediaQuery.of(context).viewInsets.bottom : 0)
                      ],
                    ),
                  )
              ),
            ],
          )
      );
    }
  }

  Widget tagWidget (String tag, int index, BuildContext context){
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(5),
                left: Radius.circular(5)
              ),
              color: Theme.of(context).colorScheme.primaryContainer
            ),
            child: Row(
              children: [
                Center(child: Text(tag, style: const TextStyle(fontSize:16,))),
                const SizedBox(width: 13,),
                InkWell(
                  onTap: (){
                    setState(() {
                      tags.removeAt(index);
                    });
                  },
                  child:const Icon(Icons.cancel_rounded)
                )
              ],
            ),
          ),
          const SizedBox(width: 7,)
        ],
      );
    }
  }