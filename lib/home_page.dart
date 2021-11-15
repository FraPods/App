import 'package:flutter/material.dart';
import 'package:frapods/profile_page.dart';
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

  bool _isSearchBarOpened = false;
  List<String> listOfAllSearchResults = [];
  Icon searchBarIcon = Icon(Icons.search);
  Widget searchBar = Image.asset(
    'assets/icon-round.png',
    fit: BoxFit.fitHeight,
    height: 40,
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
                    _isSearchBarOpened = true;
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
                    _isSearchBarOpened = false;
                    searchBarIcon = const Icon(Icons.search);
                    searchBar = Image.asset(
                      'assets/icon-round.png',
                      fit: BoxFit.fitHeight,
                      height: 40,
                    );
                  }
                });
              },
              icon: searchBarIcon),
          Visibility(
            visible: !_isSearchBarOpened,
            child: IconButton(

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {ProfilePage(title: "FraPods", username: "username"); return ProfilePage(title: "FraPods", username: "username");}
                ),
                );
              },
              icon: Icon(Icons.account_circle),
          ),
          ),
        ],
      ),

      //End of Title Bar Layout ^^

      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: listOfAllSearchResults.length,
                itemBuilder: (BuildContext ctxt, int index) =>
                    podcastItem(ctxt, index, listOfAllSearchResults),
              ),
            ),
            

            
          ],
        ),
      ),
    );
  }

  void sendSearchRequest(String text) {
    showDialogMessage("You entered a search", text);
    // TODO: Write search request to server function


    setState(() {
      listOfAllSearchResults = [];
      listOfAllSearchResults.add("RESULTS OF SEARCH \"" + text + "\" HERE....");
    });
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

  // This is the widget of one search result entry.
  Widget podcastItem(BuildContext ctxt, int index, List listofresults) {
    return new Text(listofresults[index]);
  }
}
