import 'dart:typed_data';
import 'dart:convert';
import 'dart:developer';
import 'package:frapods/playlist_info.dart';
import 'package:frapods/podcast_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

//const String apiDomain = "http://192.168.0.105/Backend/";
const String apiDomain = "https://podcast-api.kleysley.com/Backend/";

class BackendApi {

  final String currentTokenKey = "currenttoken";
  final String deviceTokenKey = "devicetoken";
  final String nextTokenKey = "nexttoken";
  final String usernameKey = "username";
  bool isLoggedIn = false;

  Future<String> createAccount(String username, String password,
      String firstname, String lastname, String email) async {
    log("RESPONSE IS STARTING ");

    var response = await http.get(Uri.parse(apiDomain +
        "createAccount.php?username=$username&pwd=$password&firstname=$firstname&lastname=$lastname&email=$email"));
    log("RESPONSE IS THE FOLLOWING " + response.body);

    switch(response.statusCode){
      case 200:
      case 201:
        return "200";
      case 422:
      case 400:
        log("ERROR!!! Backend code " + response.statusCode.toString() + " in createaccount");
        return "400";
      case 404:
      case 523:
        log("Servers are down!");
        return "523";
    }
    return "";

  }

  Future<String> _authenticate(String username, String deviceToken, String nextSessionToken) async {
    log("authenticate called");
    var response = await http.get(Uri.parse(apiDomain +
        "authenticate.php?username=$username&deviceToken=$deviceToken&sessionToken=$nextSessionToken"));
    switch(response.statusCode){
      case 200:
      case 201:
        if(nextSessionToken != "error" && utf8.decode(response.bodyBytes) != "error") {
          _saveString(currentTokenKey, nextSessionToken);
          _saveString(nextTokenKey, utf8.decode(response.bodyBytes));
          log(
              "SUCCESSFUL ACCOUNT CREATION AND LOGIN, saved following tokens: " +
                  await _getString(currentTokenKey) + ", " +
                  await _getString(nextTokenKey) + ", " +
                  await _getString(deviceTokenKey));
          log("login notifier value changed by backendapi");
          loginNotifier.value = true;
        } else {
          log(
              "auth failed, following tokens: " +
                  await _getString(currentTokenKey) + ", " +
                  await _getString(nextTokenKey) + ", " +
                  await _getString(deviceTokenKey));
        }
        return "200";
      case 400:
      case 422:
        log("ERROR!!! Backend code " + response.statusCode.toString() + " in authenticate");
        log(username + ", " + deviceToken + " " + nextSessionToken);
        return "400";
      case 404:
      case 523:
        log("Servers are down");
        return "523";
    }
    return "";

  }

  Future<String> autoLogIn() async {
    if(isLoggedIn){
      return "200";
    }
    log("autologin called");
    isLoggedIn = true;
    String username = await _getString(usernameKey);
    String deviceToken = await _getString(deviceTokenKey);
    String sessionToken = await _getString(nextTokenKey);
    log(username);
    log(deviceToken);
    log(sessionToken);
    var response = await _authenticate(username, deviceToken, sessionToken);
    log("response:autologin: " + response);
    if(await _getString(deviceTokenKey) != "error") {
      return response;
    } else {
      return "400";
    }
  }


  Future<String> logIn(String username, String password) async {
    var response = await http.post(
        Uri.parse(apiDomain + "registerDevice.php"),
        body: {
          'username' : username,
          'pwd' : password
        });

    switch(response.statusCode){
      case 200:
      case 201:
        log(response.body);
        String token = response.body;
        if(token != "error") {
          _saveString(usernameKey, username);
          _saveString(deviceTokenKey, token);
          _saveString(currentTokenKey, token);
          _saveString(nextTokenKey, token);
        }

        log(( await http.get(Uri.parse(apiDomain +
            "verifyDevice.php?deviceToken=$token&sessionToken=$token"))).statusCode.toString());
        return "200";
      case 422:
      case 400:
        log("ERROR!!! Backend code 422 or 400 in registerdevice");
        return "400";
      case 523:
        log("Servers are down");
        return "523";
    }
    return "";
  }


  Future<List<PodcastInfo>> searchOnYoutube(String query, {int maxNum=10}) async{
    if(maxNum > 10){ maxNum = 10; }
    List<PodcastInfo> listOfAllSearchResults = [];

    // Gets the first 10 search results from youtube
    var response = await http.get(Uri.parse(apiDomain +
        "extractYoutubeResults.php?search=$query"));
    String results = response.body;
    int statusCode = response.statusCode;
    if(statusCode == 200){

      final videos = jsonDecode(results);

      for(int i = 0; i < videos.length; i++) {
        listOfAllSearchResults.add(PodcastInfo.create(videos[i]["title"], "", videos[i]["channel"] + " (YouTube)", "GETURL: " + videos[i]["id"], apiDomain + "getJpegFile.php?file=" + videos[i]["thumb"], 0, videos[i]["id"]));
      }

    }

    return listOfAllSearchResults;

  }

  Future<List<PodcastInfo>> searchOnFrapods(String query, {int maxNum=10}) async {
    List<PodcastInfo> listOfResults = [];

    var response = await http.get(Uri.parse(apiDomain + "search.php?s=" + query + "&username=" + await _getString(usernameKey) + "&deviceToken=" + await _getString(deviceTokenKey) + "&sessionToken=" + await _getString(currentTokenKey)));
    String results = response.body;

    if(results != "") {

      final podcasts = json.decode(results);

      podcasts.forEach((podcast) => {
        listOfResults.add(PodcastInfo.create(podcast["title"], "", podcast["creator_name"] + " (Frapods)", apiDomain + "MP3Stream.php?file_id=" + podcast["id"].toString(), apiDomain + "getImage.php?size=512&bw=0&circle=0&file_id=" + podcast["thumbnail"].toString(), podcast["id"], ""))
      });

    }

    return listOfResults;
  }

  Future<List<PodcastInfo>> getPodcastsFrom(String username, bool self, bool sleep, {int maxNum=10}) async {
    if(sleep) await Future.delayed(const Duration(milliseconds: 100));
    List<PodcastInfo> listOfResults = [];

    if(self) username = await _getString(usernameKey);

    var response = await http.get(Uri.parse(apiDomain + "getFromUser.php?susername=" + username + "&username=" + await _getString(usernameKey) + "&deviceToken=" + await _getString(deviceTokenKey) + "&sessionToken=" + await _getString(currentTokenKey)));
    String results = response.body;

    if(results != "") {
      final podcasts = json.decode(results);
      podcasts.forEach((podcast) => {
        listOfResults.add(PodcastInfo.create(podcast["title"], "", podcast["creator_name"], "", apiDomain + "getImage.php?size=512&bw=0&circle=0&file_id=" + podcast["thumbnail"].toString(), podcast["id"], ""))
      });
    }

    return listOfResults;
  }


  Future<PodcastInfo> getPodcastData(int id, {int maxNum=10}) async {
    PodcastInfo result = PodcastInfo();

    var response = await http.get(Uri.parse(apiDomain + "getPodcastDetails.php?id=" + id.toString() + "&username=" + await _getString(usernameKey) + "&deviceToken=" + await _getString(deviceTokenKey) + "&sessionToken=" + await _getString(currentTokenKey)));
    String results = response.body;

    if(results != "") {

      final podcast = json.decode(results);
      result = PodcastInfo.create(podcast["title"], podcast["description"], podcast["creator_name"], "url", apiDomain + "getImage.php?size=512&bw=0&circle=0&file_id=" + podcast["thumbnail"].toString(), podcast[id], "");
    }

    return result;
  }

  Future<void> editPodcastData(PodcastInfo newData) async {
    var thumbnail = newData.thumbnail;
    if(int.tryParse(thumbnail) == null) {
      thumbnail = Uri.parse(thumbnail).queryParameters['file_id'] ?? "4";
    }
    http.get(Uri.parse(apiDomain + "editPodcastDetails.php?id=" + newData.id.toString() + "&title=" + newData.title + "&description=" + newData.description + "&creator=" + newData.artist + "&lyrics=abc&year=2022&thumbnail_id=" + thumbnail));
    return;
  }

  Future<int> uploadPodcast(Uint8List? file) async {
    var map = <String, dynamic>{};
    map['data'] = file.toString();
    map['username'] = await _getString(usernameKey);
    map['sessionToken'] = await _getString(currentTokenKey);
    map['deviceToken'] = await _getString(deviceTokenKey);
    var response = await http.post(
      Uri.parse(apiDomain + 'upload.php?mp3=mp3'),
      body: map,
    );
    return int.parse(response.body);
  }

  Future<int> uploadThumbnail(Future<Uint8List> file) async {
    var map = <String, dynamic>{};
    map['data'] = (await file).toString();
    map['username'] = await _getString(usernameKey);
    map['sessionToken'] = await _getString(currentTokenKey);
    map['deviceToken'] = await _getString(deviceTokenKey);
    var response = await http.post(
      Uri.parse(apiDomain + 'upload.php?thumbnail=thumbnail'),
      body: map,
    );
    return int.parse(response.body);
  }

  /*Future<int> uploadThumbnail(File file) async {
    log("Uploading Thumbnail...");

    var request = http.MultipartRequest('POST', Uri.parse(api_domain + "upload.php?thumbnail=thumbnail"));
    request.fields['username'] = await _getString(USERNAME_KEY);
    request.fields['sessionToken'] = await _getString(CURRENT_TOKEN_KEY);
    request.fields['deviceToken'] = await _getString(DEVICE_TOKEN_KEY);
    request.files.add(
      http.MultipartFile(
        'picture',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: "uploadThumbnail.png"
      )
    );
    /*var res = await request.send();
    var responseId = int.parse(await res.stream.bytesToString());
    log(responseId.toString());
    return responseId;*/
    return 0;
  }*/

  Future<String> getUrlFromYtID(String id) async {
    String url = (await http.get(Uri.parse(apiDomain + "getVideoURL.php?id=$id"))).body;
    return url;
  }

  Future<dynamic> getAccountData(String username, bool self) async {
    if(self) username = await _getString(usernameKey);
    String result = (await http.get(Uri.parse(apiDomain + "getAccountData.php?username=$username"))).body;
    final jsonData = json.decode(result);
    return jsonData;
  }

  Future<List<PlaylistData>> getOwnPlaylists() async {
    List<PlaylistData> playlists = [];
    String textualResult = (await http.get(Uri.parse(apiDomain + "getUserPlaylists.php?username=" + (await _getString(usernameKey))))).body;
    final jsonData = json.decode(textualResult);
    jsonData.forEach((jsonPlaylist) => {
      playlists.add(PlaylistData(jsonPlaylist["title"], [], jsonPlaylist["description"], jsonPlaylist["thumbnail"] == "0" ? "0" : (apiDomain + "getImage.php?bw=0&circle=0&size=512&file_id=" + jsonPlaylist["thumbnail"]), int.parse(jsonPlaylist["id"])))
    });
    return playlists;
  }

  Future<List<PodcastInfo>> getNewestUploads() async {
    List<PodcastInfo> podcasts = [];
    String textualResult = (await http.get(Uri.parse(apiDomain + "getNewest.php?username=" + (await _getString(usernameKey)) + "&deviceToken=" + (await _getString(deviceTokenKey)) + "&sessionToken=" + (await _getString(currentTokenKey))))).body;
    final jsonData = json.decode(textualResult);
    jsonData.forEach((jsonPodcast) => {
      podcasts.add(PodcastInfo.create(jsonPodcast["title"], jsonPodcast["description"], jsonPodcast["creator_name"], apiDomain + "MP3Stream.php?file_id=" + jsonPodcast["id"], apiDomain + "getImage.php?bw=0&circle=0&size=512&file_id=" + jsonPodcast["thumbnail"], int.parse(jsonPodcast["id"]), ""))
    });
    return podcasts;
  }

  Future<List<PodcastInfo>> newUploadsFromFavorites() async {
    List<PodcastInfo> podcasts = [];
    String textualResult = (await http.get(Uri.parse(apiDomain + "getNewestFromFavs.php?username=" + (await _getString(usernameKey)) + "&deviceToken=" + (await _getString(deviceTokenKey)) + "&sessionToken=" + (await _getString(currentTokenKey))))).body;
    final jsonData = json.decode(textualResult);
    jsonData.forEach((jsonPodcast) => {
      podcasts.add(PodcastInfo.create(jsonPodcast["title"], jsonPodcast["description"], jsonPodcast["creator_name"], apiDomain + "MP3Stream.php?file_id=" + jsonPodcast["id"], apiDomain + "getImage.php?bw=0&circle=0&size=512&file_id=" + jsonPodcast["thumbnail"], int.parse(jsonPodcast["id"]), ""))
    });
    return podcasts;
  }

  Future<List<PodcastInfo>> getRandomPodcasts() async {
    List<PodcastInfo> podcasts = [];
    String textualResult = (await http.get(Uri.parse(apiDomain + "getRandomPodcasts.php?username=" + (await _getString(usernameKey)) + "&deviceToken=" + (await _getString(deviceTokenKey)) + "&sessionToken=" + (await _getString(currentTokenKey))))).body;
    final jsonData = json.decode(textualResult);
    jsonData.forEach((jsonPodcast) => {
      podcasts.add(PodcastInfo.create(jsonPodcast["title"], jsonPodcast["description"], jsonPodcast["creator_name"], apiDomain + "MP3Stream.php?file_id=" + jsonPodcast["id"], apiDomain + "getImage.php?bw=0&circle=0&size=512&file_id=" + jsonPodcast["thumbnail"], int.parse(jsonPodcast["id"]), ""))
    });
    return podcasts;
  }

  Future<List<PodcastInfo>> getRecommendedPodcasts() async {
    List<PodcastInfo> podcasts = [];
    String textualResult = (await http.get(Uri.parse(apiDomain + "getRecommended.php?username=" + (await _getString(usernameKey)) + "&deviceToken=" + (await _getString(deviceTokenKey)) + "&sessionToken=" + (await _getString(currentTokenKey))))).body;
    final jsonData = json.decode(textualResult);
    jsonData.forEach((jsonPodcast) => {
      podcasts.add(PodcastInfo.create(jsonPodcast["title"], jsonPodcast["description"], jsonPodcast["creator_name"], apiDomain + "MP3Stream.php?file_id=" + jsonPodcast["id"], apiDomain + "getImage.php?bw=0&circle=0&size=512&file_id=" + jsonPodcast["thumbnail"], int.parse(jsonPodcast["id"]), ""))
    });
    return podcasts;
  }

  void submitRating(int podcastId, double rating) async {
    await http.get(Uri.parse(apiDomain + "addRating.php?id=" + podcastId.toString() + "&rating=" + rating.toStringAsFixed(3) + "&username=" + (await _getString(usernameKey)) + "&deviceToken=" + (await _getString(deviceTokenKey)) + "&sessionToken=" + (await _getString(currentTokenKey))));
    log("SUBMIT RATING");
    return;
  }

  Future<PlaylistData> getPlaylistData(String pid) async {
    PlaylistData playlistData = PlaylistData("", [], "", "", 0);
    String textualResult = (await http.get(Uri.parse(apiDomain + "getPlaylistData.php?username=" + (await _getString(usernameKey) + "&pid=" + pid)))).body;
    final jsonData = json.decode(textualResult);
    playlistData.name = jsonData["title"];
    playlistData.description = jsonData["description"];
    playlistData.thumbnail = apiDomain + "getImage.php?bw=0&circle=0&size=512&file_id=" + jsonData["thumbnail"];
    playlistData.id = int.parse(jsonData["id"]);

    List<PodcastInfo> podcasts = [];
    jsonData["podcasts"].forEach((jsonPodcast) => {
      podcasts.add(PodcastInfo.create(jsonPodcast["title"], jsonPodcast["description"], jsonPodcast["creator_name"], int.tryParse(jsonPodcast["id"]) != null? apiDomain + "MP3Stream.php?file_id=" + jsonPodcast["id"] : "GETURL: " + jsonPodcast["id"], int.tryParse(jsonPodcast["thumbnail"]) != null ? apiDomain + "getImage.php?bw=0&circle=0&size=512&file_id=" + jsonPodcast["thumbnail"] : apiDomain + "getJpegFile.php?file=" + jsonPodcast["thumbnail"], int.tryParse(jsonPodcast["id"]) != null ? int.parse(jsonPodcast["id"]) : 0, int.tryParse(jsonPodcast["id"]) == null ? jsonPodcast["id"] : ""))
    });
    playlistData.podcasts = podcasts;
    return playlistData;
  }

  Future<List<dynamic>> getPlaylistDataWithThumbId(String pid) async {
    PlaylistData playlistData = PlaylistData("", [], "", "", 0);
    int thumbId = 0;
    String textualResult = (await http.get(Uri.parse(apiDomain + "getPlaylistData.php?username=" + (await _getString(usernameKey) + "&pid=" + pid)))).body;
    final jsonData = json.decode(textualResult);
    playlistData.name = jsonData["title"];
    playlistData.description = jsonData["description"];
    playlistData.thumbnail = apiDomain + "getImage.php?bw=0&circle=0&size=512&file_id=" + jsonData["thumbnail"];
    playlistData.id = int.parse(jsonData["id"]);
    thumbId = int.parse(jsonData["thumbnail"]);

    List<PodcastInfo> podcasts = [];
    jsonData["podcasts"].forEach((jsonPodcast) => {
      podcasts.add(PodcastInfo.create(jsonPodcast["title"], jsonPodcast["description"], jsonPodcast["creator_name"], int.tryParse(jsonPodcast["id"]) != null? apiDomain + "MP3Stream.php?file_id=" + jsonPodcast["id"] : "GETURL: " + jsonPodcast["id"], int.tryParse(jsonPodcast["thumbnail"]) != null ? apiDomain + "getImage.php?bw=0&circle=0&size=512&file_id=" + jsonPodcast["thumbnail"] : apiDomain + "getJpegFile.php?file=" + jsonPodcast["thumbnail"], int.tryParse(jsonPodcast["id"]) != null ? int.parse(jsonPodcast["id"]) : 0, int.tryParse(jsonPodcast["id"]) == null ? jsonPodcast["id"] : ""))
    });
    playlistData.podcasts = podcasts;
    return [playlistData, thumbId];
  }

  Future<bool> editPlaylistData(int pid, String title, String description, int thumbnailId) async {
    http.get(Uri.parse(apiDomain + "editPlaylistDetails.php?id=" + pid.toString() + "&title=" + title + "&description=" + description + "&thumbnail_id=" + thumbnailId.toString()));
    return true;
  }

  void addToPlaylist(String pid, String sid) async {
    http.get(Uri.parse(apiDomain + "addToPlaylist.php?username=" + (await _getString(usernameKey)) + "&pid=" + pid + "&sid=" + sid));
  }

  void removeFromPlaylist(String pid, String sid) async {
    http.get(Uri.parse(apiDomain + "removeFromPlaylist.php?username=" + (await _getString(usernameKey)) + "&pid=" + pid + "&sid=" + sid));
  }

  Future<bool> createPlaylist(String title, String description, bool status, int thumbId) async {
    http.get(Uri.parse(apiDomain + "createPlaylist.php?username=" + (await _getString(usernameKey)) + "&title=" + title + "&desc=" + description + "&status=" + (status ? "1" : "0") + "&thumbId=" + thumbId.toString()));
    return true;
  }

  Future<String> editAccountData(String nUsername, String email, int thumbnail) async {
    var response = await http.get(Uri.parse(apiDomain + "editAccountDetails.php?olduname=" + (await _getString(usernameKey)) + "&username=" + nUsername + "&email=" + email + "&picture=" + thumbnail.toString()));
    if(response.statusCode == 201) {
      _saveString(usernameKey, nUsername);
      return nUsername;
    } else {
      return "";
    }
  }

  void _saveString(String key, String value) async {
    log("saving string " + value);
    (await SharedPreferences.getInstance()).setString(key, value);
  }

  _getString(String key) async {
    return (await SharedPreferences.getInstance()).getString(key);
  }

}
