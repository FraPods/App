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
        child: ListView(
          children: [Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Column(
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
                      child: Center(child: Text('????',  style:TextStyle(fontSize: 18))),
                    ),
                    onTap:(){}
                  ),
                ],),
              SizedBox(height: 25,),

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
                      Text('My Playlists:', style: TextStyle(fontSize: 19, decoration: TextDecoration.underline)),
                      SizedBox(height:20),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 90, width: 90, decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.amber)),
                          ),
                          SizedBox(width: 7,),
                          Container(
                            height: 90, width: 90, decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.amber)),
                          ),
                          SizedBox(width: 7,),
                          Container(
                            height: 90, width: 90, decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.amber)),
                          ),
                          SizedBox(width: 7,),
                          Container(
                            //decoration: BoxDecoration(border: Border.all(width: 1)),
                            child: InkWell(
                              child: Icon(Icons.keyboard_double_arrow_right_sharp, size:40),
                              onTap: (){},),
                          )
                        ],),
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

              SizedBox(height: 25,),


              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}



