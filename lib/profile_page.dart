import 'package:flutter/material.dart';
import 'package:frapods/backend_api.dart';
import 'package:frapods/playlist_info.dart';
import 'package:frapods/podcast_info.dart';
import 'setting_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.setPage})
      : super(key: key);

  //following parameters MUST be passed:
  final Function(int index) setPage;

  @override
  State<ProfilePage> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  // declare variables here:
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  List<PlaylistData> playlists = [
    PlaylistData('pl1', [PodcastInfo('p1','xxxx','art','url','', 0)]),
    PlaylistData('pl2', [PodcastInfo('p1','xxxx','art','url','', 0)]),
    PlaylistData('pl3', [PodcastInfo('p1','xxxx','art','url','', 0)]),
    PlaylistData('pl3', [PodcastInfo('p1','xxxx','art','url','', 0)]),
    PlaylistData('pl3', [PodcastInfo('p1','xxxx','art','url','', 0)]),
  ];

  String username = "";
  bool firstLoad = true;
  String noPodcasts = "0";

  @override
  Widget build(BuildContext context) {
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;
    if(firstLoad) {
      firstLoad = false;
      BackendApi().getAccountData("", true).then((value) => {
        noPodcasts = value["noPodcasts"].toString(),
        setState(() => username = (value["username"] == null) ? "unknown" : value["username"])
      });
    }

    return Scaffold(
      appBar: AppBar(
           title: Icon(Icons.account_circle),
           actions: [
           IconButton(icon: Icon(Icons.settings),
            onPressed: () {
              widget.setPage(4);
            },)
         ],
      ),
      body: Container(
        height: pageHeight,
        child: ListView(
          children: [Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 5,
                  color: Theme.of(context).colorScheme.surface,
                  margin: const EdgeInsets.only(right: 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                    height:150,
                    child:Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.pink, width: 2),
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(10),
                              left: Radius.circular(10),
                          )
                          ),
                          height: 90, width: 90,
                          ),
                        const SizedBox(width: 20,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Container(
                              padding: const EdgeInsets.only(right:5),
                              width: MediaQuery.of(context).size.width - 175,
                              //height: ,
                              child: Text(username,
                                style: const TextStyle(fontSize: 23),
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,),
                            ),
                            SizedBox(height:15),
                            // Container(
                            //   padding:EdgeInsets.only(right:5),
                            //   width: MediaQuery.of(context).size.width -pageHeight/4,
                            //   child: Text('About me: ' + 'xxxxxxxx ', 
                            //   style: TextStyle(fontSize: 17),
                            //   maxLines: 2,
                            //   textAlign: TextAlign.left,
                            //   overflow: TextOverflow.ellipsis,
                            //   softWrap: false,),
                            // ),
                            Text('My posts: ' + noPodcasts, style: TextStyle(fontSize: 18),),
                            SizedBox(height: 15,)
                          ],
                        )
                      ],),
                    Container(
                      alignment:Alignment.bottomRight,
                      child:InkWell(
                        onTap:(){
                          widget.setPage(4);
                        },
                       child:Text('Edit account >>', style: TextStyle(fontSize: 16),)
                     )
                    ),
                    //SizedBox(height:1)
                    ],)
                  )
                ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Container(
                      decoration:(BoxDecoration(
                        //border: Border.all(width:1),
                        borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(7),
                        left: Radius.circular(7)),
                        color: Theme.of(context).colorScheme.secondaryContainer)),
                      height: 70,
                      width: (MediaQuery.of(context).size.width - 30)/2 - 10,
                      child: Center(child: Text('Post New',  style:TextStyle(fontSize: 18))),
                    ),
                    onTap:(){
                      widget.setPage(3);
                    }
                  ),
                  InkWell(
                    child: Container(
                      decoration:(BoxDecoration(
                        //border: Border.all(width:1),
                        borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(7),
                        left: Radius.circular(7)),
                        color: Theme.of(context).colorScheme.secondaryContainer)),
                      height: 70,
                      width: (MediaQuery.of(context).size.width - 30)/2 - 10,
                      child: Center(child: Text('My Podcasts',  style:TextStyle(fontSize: 18))),
                    ),
                    onTap:(){}
                  ),
                  
                ],),
                SizedBox(height: 30,),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Container(
                      decoration:(BoxDecoration(
                        //border: Border.all(width:1),
                        borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(7),
                        left: Radius.circular(7)),
                        color: Theme.of(context).colorScheme.secondaryContainer)),
                      height: 70,
                      width: (MediaQuery.of(context).size.width - 30)/2 - 10,
                      child: Center(child: Text('History',  style:TextStyle(fontSize: 18))),
                    ),
                    onTap:(){}
                  ),
                  InkWell(
                    child: Container(
                      decoration:(BoxDecoration(
                        //border: Border.all(width:1),
                        borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(7),
                        left: Radius.circular(7)),
                        color: Theme.of(context).colorScheme.secondaryContainer)),
                      height: 70,
                      width: (MediaQuery.of(context).size.width - 30)/2 - 10,
                      child: Center(child: Text('??????',  style:TextStyle(fontSize: 18))),
                    ),
                    onTap:(){}
                  ),
                  
                ],),
              SizedBox(height: 30,),

              Container(
                height: 170,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  //border:Border.all(width:1),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(5),
                    left: Radius.circular(5)),
                  ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 5, 10, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Playlists:', style: TextStyle(fontSize: 20, decoration: TextDecoration.underline)),
                      SizedBox(height:20),
                      Container(
                        height: 90,
                        child: playlists.isEmpty?
                        Center(
                          child: Text('No playlists yet...',
                          style:TextStyle(fontSize: 18),
                            ))
                        :
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: playlists.length,
                          itemBuilder: (ctx, index) => myPlaylists(PlaylistData(playlists[index].name, playlists[index].podcasts)),
                          ),
                      ),
                        // SizedBox(height:10),
                        // Center(
                        //   //decoration: BoxDecoration(border: Border.all(width: 1)),
                        //   child: InkWell(
                        //     child: Icon(Icons.arrow_drop_down,size:40),
                        //     onTap: (){},
                        //   ),
                        // )
                  ],)
                  
                  ),
              ),
              ],),
          ),
          ],
        ),
      ),
    );
  }
  Widget myPlaylists (PlaylistData playlistData){
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
          Container(
            height: 90, 
            width: 90, 
            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.amber)),
            child:Center(child: Text(playlistData.name, style: TextStyle(fontSize: 16,),)),
          ),
          SizedBox(width: 7,),
        ],
      ),
      
    );
  }
}



