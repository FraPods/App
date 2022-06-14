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
    /*PlaylistData('pl1', [PodcastInfo('p1','xxxx','art','url','', 1)]),
    PlaylistData('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhpl2', [PodcastInfo('p1','xxxx','art','url','', 2)]),
    PlaylistData('pl3', [PodcastInfo('p1','xxxx','art','url','', 3)]),
    PlaylistData('pl3', [PodcastInfo('p1','xxxx','art','url','', 4)]),
    PlaylistData('pl3', [PodcastInfo('p1','xxxx','art','url','', 5)]),*/
  ];
  bool _allPlaylists = false;

  String username = "";
  bool firstLoad = true;
  String noPodcasts = "0";

  @override
  Widget build(BuildContext context) {
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;
    if(firstLoad) {
      firstLoad = false;
      BackendApi().getOwnPlaylists().then((value) => {
        setState(() => playlists = value)
      });
      BackendApi().getAccountData("", true).then((value) => {
        noPodcasts = value["noPodcasts"].toString(),
        setState(() => username = (value["username"] == null) ? "unknown" : value["username"])
      });
    }

    return Scaffold(
      appBar: AppBar(
           title: const Icon(Icons.account_circle),
           actions: [
           IconButton(icon: const Icon(Icons.settings),
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
                            const SizedBox(height:15),
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
                            Text('My posts: ' + noPodcasts, style: const TextStyle(fontSize: 18),),
                            const SizedBox(height: 15,)
                          ],
                        )
                      ],),
                    Container(
                      alignment:Alignment.bottomRight,
                      child:InkWell(
                        onTap:(){
                          widget.setPage(4);
                        },
                       child:const Text('Edit account >>', style: TextStyle(fontSize: 16),)
                     )
                    ),
                    //SizedBox(height:1)
                    ],)
                  )
                ),
                const SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Container(
                      decoration:(BoxDecoration(
                        //border: Border.all(width:1),
                        borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(7),
                        left: Radius.circular(7)),
                        color: Theme.of(context).colorScheme.secondaryContainer)),
                      height: 70,
                      width: (MediaQuery.of(context).size.width - 30)/2 - 10,
                      child: const Center(child: Text('Post New',  style:TextStyle(fontSize: 18))),
                    ),
                    onTap:(){
                      widget.setPage(3);
                    }
                  ),
                  InkWell(
                    child: Container(
                      decoration:(BoxDecoration(
                        //border: Border.all(width:1),
                        borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(7),
                        left: Radius.circular(7)),
                        color: Theme.of(context).colorScheme.secondaryContainer)),
                      height: 70,
                      width: (MediaQuery.of(context).size.width - 30)/2 - 10,
                      child: const Center(child: Text('My Podcasts',  style:TextStyle(fontSize: 18))),
                    ),
                    onTap:(){}
                  ),
                  
                ],),
                const SizedBox(height: 25,),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Container(
                      decoration:(BoxDecoration(
                        //border: Border.all(width:1),
                        borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(7),
                        left: Radius.circular(7)),
                        color: Theme.of(context).colorScheme.secondaryContainer)),
                      height: 70,
                      width: (MediaQuery.of(context).size.width - 30)/2 - 10,
                      child: const Center(child: Text('History',  style:TextStyle(fontSize: 18))),
                    ),
                    onTap:(){}
                  ),
                  InkWell(
                    child: Container(
                      decoration:(BoxDecoration(
                        //border: Border.all(width:1),
                        borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(7),
                        left: Radius.circular(7)),
                        color: Theme.of(context).colorScheme.secondaryContainer)),
                      height: 70,
                      width: (MediaQuery.of(context).size.width - 30)/2 - 10,
                      child: const Center(child: Text('??????',  style:TextStyle(fontSize: 18))),
                    ),
                    onTap:(){}
                  ),
                  
                ],),
                const SizedBox(height: 25,),

              Container(
                //height: 170,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  //border:Border.all(width:1),
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(5),
                    left: Radius.circular(5)),
                  ),
                child: Padding(
                  padding: playlists.isEmpty? const EdgeInsets.fromLTRB(15, 15, 15, 10):EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('My Playlists:', style: TextStyle(fontSize: 20, decoration: TextDecoration.underline)),
                      const SizedBox(height:20),
                      Container(
                        //height: playlists.isEmpty? 90 : double.infinity,
                        child: playlists.isEmpty?
                        const Center(
                          child: Text('No playlists yet...',
                          style:TextStyle(fontSize: 18),
                            ))
                        :
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: _allPlaylists? playlists.length : 3,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 20,
                          ),
                          itemBuilder: (context, index) {
                            return myPlaylists(PlaylistData(playlists[index].name, playlists[index].podcasts));
                          }

                          )
                      ),
                      const SizedBox(height:2),
                        Visibility(
                          visible: !_allPlaylists && playlists.isNotEmpty,
                          child: Center(
                            child: InkWell(
                              child: const Icon(Icons.arrow_drop_down,size:40),
                              onTap: (){
                                setState((){ _allPlaylists=true;});
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _allPlaylists && playlists.isNotEmpty,
                          child: Center(
                            child: InkWell(
                              child: const Icon(Icons.arrow_drop_up,size:40),
                              onTap: (){
                                setState((){ _allPlaylists=false;});
                              },
                            ),
                          ),
                        ),
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
    return //Row (
      //children: [
        //SizedBox(width: 0,),
        InkWell(
          onTap: (){},
          child:
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.amber)),
              child:Center(
                child: Container(
                  width: 75,
                  child: Text(
                    playlistData.name,
                    style: const TextStyle(fontSize: 16,),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    ),
                )
              ),
            ),
          );
    // ]);
  }
}



