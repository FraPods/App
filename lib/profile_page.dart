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
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView(
          children: [Center(child: Column(
              children: <Widget>[
                Card(
                  elevation: 10,
                  //margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  color: Theme.of(context).colorScheme.surface,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    height: pageHeight /4,
                    child:Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Container(decoration: BoxDecoration(border: Border.all(color: Colors.pink, width: 2)),
                        height: pageHeight /8,width: pageHeight /8,),
                        SizedBox(width: 20,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 7,),
                            Container(
                              padding: EdgeInsets.only(right:5),
                              //width: MediaQuery.of(context).size.width  - 75,
                              child: Text('Username', 
                                style: TextStyle(fontSize: 24),
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,),
                            ),
                            SizedBox(height: 10,),
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
                             Text('Posts: 16', style: TextStyle(fontSize: 17),),
                          ],
                        )
                      ],),
                    ],)
                  )
                ),
              SizedBox(height: 20,),

              InkWell(
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width /2,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1,color: Colors.amber),
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(5),
                      left: Radius.circular(5)),
                    ),
                  child: Center(child: Text('My playlist')),
                ),
                onTap: (){},
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



