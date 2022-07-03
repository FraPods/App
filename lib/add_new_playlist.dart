import 'package:flutter/material.dart';

import 'package:frapods/backend_api.dart';
import 'package:frapods/main.dart';

import 'package:frapods/podcast_info.dart';
import 'package:frapods/playlist_info.dart';

class AddNewPlaylist extends StatefulWidget {
  //AddNewPlaylist({Key? key}) : super(key: key);
  final Function newPlaylist;
  final int id;

  AddNewPlaylist(this.newPlaylist, this.id);

  @override
  State<AddNewPlaylist> createState() {
    return _AddNewPlaylistState();
  }
}

class _AddNewPlaylistState extends State<AddNewPlaylist> {
  // declare variables here:
  final nameController = TextEditingController();

  PlaylistData newPlaylist = PlaylistData('', []);

  @override
  Widget build(BuildContext context) {
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;
    final _keyboardVisible = MediaQuery.of(context).viewInsets.bottom !=0;
    bool _isPodcastsSelected = true;

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
        widget.newPlaylist(
            nameController.text,
            [PodcastInfo('title', 'description','artist', '', '', 1)]
            //TODO: submit selected podcasts
        );
        Navigator.of(context).pop();
      }
    }

    return FractionallySizedBox(
        heightFactor: 0.6,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: ListView(
            children: [Column(
              children: [
                Center(
                  child: Text('New Playlist', style: subtitleTextStyle(), textAlign: TextAlign.center,),
                ),
                const SizedBox(height: 10),
                Container(
                  width:double.maxFinite,
                  child: TextField(
                    style: const TextStyle(fontSize:18),
                    decoration: const InputDecoration(labelText: 'name of your playlist', ),
                    controller: nameController,
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                  width: double.maxFinite,
                  height:70,
                  child: TextButton(
                    onPressed: (){},
                    child: const Text('Select podcasts'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
                      foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.onPrimary),
                      textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 18))
                    )
                  ),
                ),
                const SizedBox(height:15),
                Visibility(
                  visible: _isPodcastsSelected==true,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        height:200, width: double.maxFinite,
                        // child: ListView.builder(),
                        //TODO: build selectedPodcasts here
                      ),
                      const SizedBox(height:15),
                    ],
                  ),
                ),
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
            const Center(child: Text(
              'data',
              style: const TextStyle(fontSize: 22)),),
            const SizedBox(height:5),
            Container(
              height:pageHeight*0.57,
              child: const Text('dad')
              // widget.playlistData.podcasts.isEmpty? 
              // Text('No podcasts in this playlist yet......'):
              // ListView.builder(
              //   itemCount: widget.playlistData.podcasts.length,
              //   itemBuilder: (ctx, index) => playlistPodcast(widget.playlistData.podcasts[index]),
              // )
            )
          ],
        ),
      )
    );
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
