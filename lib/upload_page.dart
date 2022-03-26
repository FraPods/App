import 'package:flutter/material.dart';
import 'package:frapods/main_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/podcast_player.dart';
import 'add_new_podcast.dart';
import 'setting_page.dart';
import 'main.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key, required this.setPage}) : super(key: key);

  final Function(int index) setPage;

  @override
  State<UploadPage> createState() {
    return _UploadPageState();
  }
}

class _UploadPageState extends State<UploadPage> {
  // declare variables here:
  List<PodcastInfo> podcasts = [
    // PodcastInfo.only(title: 'podcast1', description: 'xxxxxxxxxxxxxxxx', artist: 'aaa bbbb', url: 'www.test.com'),
    // PodcastInfo('podcast2','xxxxxxxxxxxxxxxxx','ccc dddd','www.test2.com'),
  ];


  void _addNewPodcast(String xtitle, String xartist, String xdescription, String xurl){
    // final newpod = PodcastInfo.only(
    //   title: xtitle, description: xdescription, artist: xartist, url: xurl
    // );
    setState(() {
      podcasts.add(PodcastInfo(xtitle, xdescription, xartist, xurl));
    });
  }
  
    void _newPodcast (BuildContext ctx) {
    showModalBottomSheet(
      context: ctx, 
      builder: (_){
        return FractionallySizedBox(
          //behavior: HitTestBehavior.opaque,
          heightFactor: 0.75,
          child: AddNewPodcast(_addNewPodcast)
        );
      },
      isScrollControlled: true
      );
  }

  @override
  Widget build(BuildContext context) {
    //define variables here
    bool isDark = darkNotifier.value;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/icon-round.png',
          fit: BoxFit.fitHeight,
          height: 40,
        ),
        actions: [
          IconButton(icon: Icon(Icons.settings),
            onPressed: () {
              widget.setPage(4);
            },)
         ],
      ),

      body: ListView(
        children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: 
            Container(
              //height: double.maxFinite,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: double.maxFinite,
                      height: 70,
                      child: TextButton(
                        onPressed: () => _newPodcast(context),
                        child: Text('+ New Podcast'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                          foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.onPrimary),
                          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 23, letterSpacing: 0.7))
                        )
                      ),
                    ),
                  ),
      
                  // End of first Button
      
                  Center(
                    child: Container(
                      width: double.maxFinite,
                      
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(15), right: Radius.circular(15)),
                        // boxShadow: [BoxShadow(
                        //   color: Colors.black.withOpacity(0.3),
                        //   spreadRadius: 3,
                        //   blurRadius: 3,
                        // )]
                      ),
                      child: Card(elevation: 15, 
                        shadowColor: Colors.black,
                        color: Theme.of(context).colorScheme.surface,
                        margin: EdgeInsets.only(top: 30),
                        child: Column(children: [
                          Container(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                              child: Center(
                                child: Text(
                                  'Existing Podcasts',
                                  style: TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 0.5
                                  ),
                                )
                              ),
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            height: 370,
                            child: podcasts.isEmpty?
                            Center(
                              child: (Text('Empty List.....', style: TextStyle(fontSize:18)))
                            )
                            : ListView.builder(
                              itemCount: podcasts.length,
                              itemBuilder: (ctx, index) => myPodcast(PodcastInfo(podcasts[index].title, podcasts[index].description, podcasts[index].artist, podcasts[index].url,))),
                          )
                        ]),
                      ),
                    ),
                  ),
              ],
          ),
        )),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed:()=> setState(() {isDark = !isDark; darkNotifier.value = isDark;})
      // ),
    );
  }

  Widget myPodcast (PodcastInfo podcastInfo){
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      color: Theme.of(context).colorScheme.primaryVariant,
      child: Row(
        mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                margin: EdgeInsets.fromLTRB(10, 13, 0, 5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    podcastInfo.title + '  by ' + podcastInfo.artist,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18),
                    // overflow: TextOverflow.fade,
                    // softWrap: false,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 0, 10),
                child: Text(
                  'Description :  ' + podcastInfo.description,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.add_box_rounded, size: 30), 
            alignment: Alignment.centerLeft,)
          ],
        ),
      );
  }
}