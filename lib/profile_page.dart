import 'package:flutter/material.dart';
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
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;

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
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: ListView(
          children: [Center(child: Column(
              children: <Widget>[
                Card(
                  elevation: 5,
                  color: Theme.of(context).colorScheme.surface,
                  margin: EdgeInsets.only(right: 0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
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
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(10),
                              left: Radius.circular(10),
                          )
                          ),
                          height: 90, width: 90,
                          ),
                        SizedBox(width: 20,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Container(
                              padding: EdgeInsets.only(right:5),
                              width: MediaQuery.of(context).size.width - 175,
                              //height: ,
                              child: Text('Use fgme', 
                                style: TextStyle(fontSize: 23),
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
                            Text('My posts: 16', style: TextStyle(fontSize: 18),),
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
              SizedBox(height: 25,),

              Container(
                height: 160,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  border:Border.all(width:1),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(5),
                    left: Radius.circular(5)),
                  ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('My Playlists', style: TextStyle(fontSize: 18)),
                      SizedBox(height:17),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 80, width: 80, decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.amber)),
                          ),
                          Container(
                            height: 80, width: 80, decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.amber)),
                          ),
                          Container(
                            height: 80, width: 80, decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.amber)),
                          ),
                        ],
                      )
                  ],)
                  
                  ),
              )
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}



