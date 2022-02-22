import 'package:flutter/material.dart';

class AddNewPodcast extends StatefulWidget {
  //const AddNewPodcast({ Key? key }) : super(key: key);
  final Function newPodcast;
  AddNewPodcast(this.newPodcast);


  @override
  _AddNewPodcastState createState() => _AddNewPodcastState();
}

class _AddNewPodcastState extends State<AddNewPodcast> {

  final titleController = TextEditingController();
  final artistController = TextEditingController();
  final descriptionController = TextEditingController();
  final urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical:10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'title'),
              controller: titleController
            ),
            TextField(
              decoration: InputDecoration(labelText: 'artist'),
              controller: artistController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'description'),
              controller: descriptionController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'url'),
              controller: urlController,
            ),


            OutlinedButton(child: Text('admit'), 
              onPressed: () => submitData(context),
            )
         ],
       ),
     )
    );  
  }
   void submitData (BuildContext ctx) {
    // final etitle = titleController.text;
    // final eartist = artistController.text;
    // final edescription = descriptionController.text;
    // final eurl = urlController.text;
      widget.newPodcast(
      titleController.text, 
      artistController.text,
      descriptionController.text,
      urlController.text
    );
    Navigator.of(context).pop();
  }
}