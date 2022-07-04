import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:frapods/backend_api.dart';
import 'package:frapods/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:frapods/podcast_info.dart';
import 'package:frapods/playlist_info.dart';

class AddNewPlaylist extends StatefulWidget {
  //AddNewPlaylist({Key? key}) : super(key: key);
  final Function newPlaylist;
  final int id;

  const AddNewPlaylist(this.newPlaylist, this.id);

  @override
  State<AddNewPlaylist> createState() {
    return _AddNewPlaylistState();
  }
}

class _AddNewPlaylistState extends State<AddNewPlaylist> {
  // declare variables here:
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  PlaylistData newPlaylist = PlaylistData('', [], "", "", 0);
  String image = "";
  File? imageTemporary;
  int thumbnailId = 0;

  @override
  Widget build(BuildContext context) {
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;
    final _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    bool _isThumbnailSelected = true;

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

    void _submitData(BuildContext ctx) {
      if (nameController.text.isEmpty) {
        showDialogMessage(
            'Name is empty', 'Please enter a name for your playlist!');
      } else {
        var qP = Uri.parse(image).queryParameters;
        String tempThumbId = "0${qP["file_id"]}";
        BackendApi().createPlaylist(nameController.text, descriptionController.text, true, int.parse(tempThumbId));
        Navigator.of(context).pop();
      }
    }

    return FractionallySizedBox(
        heightFactor: 0.6,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: ListView(children: [
            Column(
              children: [
                Center(
                  child: Text(
                    'New Playlist',
                    style: subtitleTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 170,
                      alignment: Alignment.topLeft,
                      child: TextField(
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          labelText: 'name of your playlist',
                        ),
                        controller: nameController,
                        maxLength: 50,
                      ),
                    ),
                    const SizedBox(width: 25,),
                    InkWell(
                      onTap: () => pickImage(ImageSource.gallery),
                      child: image != ""
                          ? Container(
                              margin: const EdgeInsets.all(2),
                              child: Image.network(
                                image,
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context).colorScheme.onBackground),
                                  borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(7),
                                      left: Radius.circular(7))),
                              height: 90,
                              width: 90,
                            )
                          : Container(
                              child: const Center(
                                  child: Text(
                                'Upload Thumbnail',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              )),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                                borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(7),
                                    left: Radius.circular(7)),
                              ),
                              height: 90,
                              width: 90,
                            ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Description', border: OutlineInputBorder()),
                  controller: descriptionController,
                  maxLines: 10,
                  minLines: 6,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      child: const Text(('Submit')),
                      onPressed: () => _submitData(context),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    OutlinedButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(
                    height: _keyboardVisible
                        ? MediaQuery.of(context).viewInsets.bottom
                        : 0)
              ],
            ),
          ]),
        ));
  }

  Widget selectedPodcasts(PodcastInfo pc) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          //onHover: ,
          child: Container(
            width: double.maxFinite,
            child: Card(
              elevation: 0,
              color: const Color(0x00000000),
              //Theme.of(context).colorScheme.primaryVariant,
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: pc.thumbnail.isEmpty
                        ? Image.asset('assets/test_podcast_thumbnail.jpg')
                        : Image.network(pc.thumbnail),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        width: MediaQuery.of(context).size.width - 140,
                        child: Text(
                          pc.title,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 8, 0, 5),
                        width: MediaQuery.of(context).size.width - 140,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            pc.artist,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          thickness: 1,
          color: Colors.grey,
        )
      ],
    );
  }
}
