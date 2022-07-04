import 'package:flutter/material.dart';
import 'package:frapods/add_new_playlist.dart';
import 'package:frapods/add_new_podcast.dart';
import 'package:frapods/backend_api.dart';
import 'package:frapods/playlist_info.dart';
import 'package:frapods/playlists_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/upload_page.dart';
import 'edit_account.dart';

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

List<PlaylistData> playlists = [];

class _ProfilePageState extends State<ProfilePage> {
  // declare variables here:
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  
  bool _allPlaylists = false;

  String username = "";
  bool firstLoad = true;
  String noPodcasts = "0";
  String profilePicture = "";

  void _playlistInfo (BuildContext ctx,  PlaylistData pld, {int id = 0}) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      context: ctx,
      builder: (_){
        return PlaylistsPage(pld,);
      },
      isScrollControlled: true
      );
  }

  void _newPlaylist (BuildContext ctx, {int id = 0}) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      context: ctx,
      builder: (_){
        return AddNewPlaylist(_addNewPlaylist,id);
      },
      isScrollControlled: true
      );
  }

  void _addNewPlaylist(String xname, List<PodcastInfo> xpodcast, String xdescription, String xthumbnail, int xid){
     final newplay = PlaylistData(xname, xpodcast, xdescription, xthumbnail, xid);
    setState(() {
      playlists.add(PlaylistData(xname, xpodcast, xdescription, xthumbnail, xid));
    });
  }

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
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;
    if(firstLoad) {
      firstLoad = false;
      BackendApi().getOwnPlaylists().then((value) => {
        setState(() => playlists = value)
      });
      BackendApi().getAccountData("", true).then((value) => {
        noPodcasts = value["noPodcasts"].toString(),
        profilePicture = (value["picture"] == "0") ? "" : (api_domain + "getImage.php?bw=0&circle=0&size=90&file_id=" + value["picture"]),
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
                  color: Theme.of(context).colorScheme.primaryContainer,
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: (profilePicture == "") ? Image.asset('assets/test_profile_pic.jpg', height:90, width: 90) : Image.network(profilePicture, height: 90, width: 90),
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
                            Text('My posts: ' + /*myPosts.toString()*/noPodcasts, style: const TextStyle(fontSize: 18),),
                            const SizedBox(height: 15,)
                          ],
                        )
                      ],),
                    Container(
                      alignment:Alignment.bottomRight,
                      child:InkWell(
                        onTap:(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAccount(
                                currentUsername: username,
                                currentEmail:'current email',
                                currentProfilePicture: profilePicture,
                              )
                            ),
                          );
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
                    onTap: () {
                      _newPodcast(context);
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
                    onTap:(){
                      widget.setPage(3);
                    }
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
                      child: const Center(child: Text('Inbox',  style:TextStyle(fontSize: 18))),
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
                  padding: playlists.isEmpty? const EdgeInsets.fromLTRB(15, 15, 15, 10) : const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        const Text('My Playlists:', style: TextStyle(fontSize: 20, decoration: TextDecoration.underline)),
                        Container(
                          margin: const EdgeInsets.only(right:5),
                          child: InkWell(
                            onTap:()=> _newPlaylist(context),
                            child: const Icon(Icons.add)
                          ),
                        ),
                        ],
                      ),
                      const SizedBox(height:20),
                      Container(
                        //height: playlists.isEmpty? 90 : double.infinity,
                        child: playlists.isEmpty?
                        Container(
                          height: 120,
                          child: const Center(
                            child: Text('No playlists yet...',
                            style: TextStyle(fontSize: 18),
                              )),
                        )
                        :
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: _allPlaylists? playlists.length: playlists.length <3? playlists.length: 3,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 20,
                          ),
                          itemBuilder: (context, index) {
                            return myPlaylists(PlaylistData(playlists[index].name, playlists[index].podcasts, playlists[index].description, playlists[index].thumbnail, playlists[index].id));
                          }

                          )
                      ),
                      const SizedBox(height:2),
                        Visibility(
                          visible: !_allPlaylists && playlists.isNotEmpty,
                          child: playlists.length > 3 ? Center(
                            child: InkWell(
                              child: const Icon(Icons.arrow_drop_down,size:40),
                              onTap: (){
                                setState((){ _allPlaylists=true;});
                              },
                            ),
                          ) : const SizedBox(),
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
                    )
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
          onTap: () => _playlistInfo(context, playlistData),
          child:
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                image: playlistData.thumbnail == "0" ? null : DecorationImage(
                  image: NetworkImage(playlistData.thumbnail),
                ),
              ),
              child:Center(
                child: Text(
                  playlistData.name,
                  style: const TextStyle(fontSize: 16,),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  softWrap: false,
                ),
              ),
            ),
          );
    // ]);
  }
}



