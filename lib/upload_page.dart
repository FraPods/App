import 'package:flutter/material.dart';
import 'package:frapods/main_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/podcast_player.dart';
import 'add_new_podcast.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() {
    return _UploadPageState();
  }
}

class _UploadPageState extends State<UploadPage> {
  // declare variables here:
  final List<PodcastInfo> podcasts = [
    PodcastInfo.only(title: 'podcast1', description: 'xxxxxxxxxxxxxxxx', artist: 'aaa bbbb', url: 'www.test.com'),
    PodcastInfo('podcast2','xxxxxxxxxxxxxxxxx','ccc dddd','www.test2.com'),
  ];


  void _addNewPodcast(String xtitle, String xartist, String xdescription, String xurl){
    final newpod = PodcastInfo.only(
      title: xtitle, description: xdescription, artist: xartist, url: xurl
    );
    setState(() {
      podcasts.add(newpod);
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

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/icon-round.png',
          fit: BoxFit.fitHeight,
          height: 40,
        ),
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
                        child: Text('new podcast'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0263E3)),
                          foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 23))
                        )
                      ),
                    ),
                  ),
      
                  // End of first Button
      
                  Center(
                    child: Container(
                      width: double.maxFinite,
                      child: Card(elevation: 5, //color: Color(0xFFF3F3F3),
                        margin: EdgeInsets.only(top: 30),
                        child: Column(children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 10),
                              child: Center(
                                child: Text(
                                  'Add new Episode to existing podcast',
                                  style: TextStyle(fontSize: 18),
                                )
                              ),
                          ),
      
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            height: 370,
                            child: ListView.builder(itemBuilder: (ctx, index){
                              return Card(
                                margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                                color: Color(0xFF0084DA),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              podcasts[index].title + '  by ' + podcasts[index].artist,
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
                                            'Description :  ' + podcasts[index].description,
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
                            },itemCount: podcasts.length),
                          )
                        ]),
                      ),
                    ),
                  ),
              ],
          ),
        )),
        ],
      )
    );
  }
}