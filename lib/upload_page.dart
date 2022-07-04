import 'package:flutter/material.dart';
import 'package:frapods/backend_api.dart';

import 'package:frapods/podcast_info.dart';
import 'add_new_podcast.dart';

double? popupHeight = 0.25;
bool firstLoaded = true;

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key, required this.setPage}) : super(key: key);

  final Function(int index) setPage;

  @override
  State<UploadPage> createState() {
    return _UploadPageState();
  }
}

List<PodcastInfo> podcasts = [];

int myPosts = podcasts.length;

class _UploadPageState extends State<UploadPage> {
  // declare variables here:

  void _addNewPodcast(String xtitle, String xartist, String xdescription, String xurl){
    BackendApi().getPodcastsFrom("", true, true).then((value) {
      if (value != []) {
        setState(() => podcasts = value);
      }
    });
  }
  
  void _newPodcast (BuildContext ctx, {int id = 0}) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      context: ctx,
      builder: (_){
        return AddNewPodcast(_addNewPodcast, id);
      },
      isScrollControlled: true
      );
  }

  @override
  Widget build(BuildContext context) {
    if(firstLoaded) {
      firstLoaded = false;
      BackendApi().getPodcastsFrom("", true, false).then((value) {
      if(value != []) {
        setState(() => podcasts = value);
      }
    });
    }
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;

    return Scaffold(
      appBar: AppBar(
        // key:appbarKey,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              widget.setPage(-1);
            }),
        // actions: [
        //   IconButton(icon: const Icon(Icons.settings),
        //     onPressed: () {
        //       widget.setPage(4);
        //     },)
        //  ],
      ),

      body: Container(
        height: pageHeight,
        // decoration: BoxDecoration(border:Border.all(width:2, color:Colors.pink.shade200)),
        child: ListView(
          children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: 
              Column(
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    height: 70,
                    child: TextButton(
                      onPressed: () => _newPodcast(context),
                      child: const Text('+ New Podcast'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                        foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.onPrimary),
                        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 23, letterSpacing: 0.7))
                      )
                    ),
                  ),
        
                  // End of first Button
        
                  Container(
                    width: double.maxFinite,
                    child: Card(elevation: 15, 
                      shadowColor: Colors.black,
                      color: Theme.of(context).colorScheme.surface,
                      margin: const EdgeInsets.only(top: 30),
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: const Center(
                              child: Text(
                                'Existing Podcasts',
                                style: TextStyle(
                                  fontSize: 21,
                                  letterSpacing: 0.5
                                ),
                              )
                            ),
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: //MediaQuery.of(context).size.height > 350 ? pageHeight * 0.5102814 : 200,
                          370,
                          child: podcasts.isEmpty?
                          const Center(
                            child: (Text('Empty List.....', style: TextStyle(fontSize:18)))
                          )
                          : ListView.builder(
                            itemCount: podcasts.length,
                            itemBuilder: (ctx, index) => myPodcast(PodcastInfo.create(podcasts[index].title, podcasts[index].description, podcasts[index].artist, podcasts[index].url, podcasts[index].thumbnail, podcasts[index].id, ""))),
                        )
                      ]),
                    ),
                  ),
              ],
            )),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed:()=> setState(() {darkNotifier.value = !darkNotifier.value;})),
    );
  }

  Widget myPodcast (PodcastInfo podcastInfo){
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Text(
                podcastInfo.title,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 20),
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    //width: MediaQuery.of(context).size.width /2,

                    padding: const EdgeInsets.only(right:5),

                    child: Text(
                      podcastInfo.description.isEmpty?  'Description: no description available' : 'Description: ' + podcastInfo.description,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap:() {
                  _newPodcast(context, id: podcastInfo.id);
                  // MaterialPageRoute(builder: (context) {
                  //   PodcastDetailsPage(podcastInfo: podcastInfo);
                  //   return PodcastDetailsPage(podcastInfo: podcastInfo);
                  // });
                },
              child: const Icon(Icons.edit_rounded)),
              SizedBox(width:5),
              InkWell(
              onTap:(){},
              child: const Icon(Icons.delete_outline_rounded)),
            ],
          )
        ],),
    ),
    );
  }
}