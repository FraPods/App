import 'package:flutter/material.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title, required this.username})
      : super(key: key);

  //following parameters MUST be passed:
  final String title;
  final String username;

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // declare variables here:
  Icon searchBarIcon = Icon(Icons.search);
  Widget searchBar = const Icon(
    Icons.audiotrack,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: searchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (searchBarIcon.icon == Icons.search) {
                  searchBarIcon = const Icon(Icons.cancel);
                  searchBar = ListTile(
                    leading: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextField(
                      onSubmitted: (String text) {
                        sendSearchRequest(text);
                      },
                      textInputAction: TextInputAction.search,

                      decoration: const InputDecoration(
                        hintText: 'Search for Podcasts',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  searchBarIcon = const Icon(Icons.search);
                  searchBar = const Icon(Icons.audiotrack);
                }
              });
            },
            icon: searchBarIcon,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'This is the home page of the app. ',
            ),
          ],
        ),
      ),
    );
  }

  void sendSearchRequest(String text){
    showDialogMessage("You entered a search", text);
    // TODO: Write search request to server function
  }


  void showDialogMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
