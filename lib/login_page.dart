import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frapods/main_page.dart';
import 'main.dart';
import 'backend_api.dart';

// This is only for setup and final (non-changable) variable definition
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

// Here is the layout and the action triggers
class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // declare variables here:
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _firstnameTextController = TextEditingController();
  TextEditingController _lastnameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  bool _showSignUp = false; //show either login screen or signup screen

  @override dispose() {
     _usernameTextController.dispose();
     _passwordTextController.dispose();
     _firstnameTextController.dispose();
     _lastnameTextController.dispose();
     _emailTextController.dispose();

     animationController.dispose();
     super.dispose();
  }

  bool isLogin = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _keyboardVisible = MediaQuery.of(context).viewInsets.bottom !=0;
    double defaultLoginSize = size.height - (size.height * 0.15);
    double defaultRegisterSize = size.height - (size.height * 0.15);

    containerSize = Tween<double>(begin: size.height * 0.15, end: defaultRegisterSize).animate(CurvedAnimation(parent: animationController, curve: Curves.linear));

    return Scaffold(
      body: Stack(
        children: [
          //animation cancel
          Visibility(
            visible: !isLogin,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: size.width,
                height: size.height * 0.15,
                alignment: Alignment.bottomCenter,
                child: _keyboardVisible? const SizedBox()
                :IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      animationController.reverse();
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    color: Colors.white),
              ),
            ),
          ),

          Visibility(
            visible: isLogin,
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  width: size.width,
                  height: defaultLoginSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height:30),
                      Text(
                        'Welcome to',
                        style: loginTitleTextStyle(),
                      ),
                      const SizedBox(height: 40),
                      Image.asset(
                        'assets/icon-round.png',
                        height: 250,
                        width: 250,
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: backgroundColor()),
                        child: TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.email, color: blueish()),
                              hintText: 'Username',
                              border: InputBorder.none),
                          controller: _usernameTextController,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: backgroundColor()),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              icon: Icon(Icons.lock, color: blueish()),
                              hintText: 'Password',
                              border: InputBorder.none),
                          controller: _passwordTextController,
                        ),
                      ),
                      InkWell(
                        onTap: () => login(_usernameTextController.text, _passwordTextController.text),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: blueish(),
                          ),
                          child: Text(
                            'Login',
                            style: loginTextStyle(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return buildRegisterContainer();
            },
          ),
          Visibility(
            visible: !isLogin,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size.width,
                height: defaultLoginSize,
                child: ListView(
                  children: [Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //SizedBox(height:10),
                      Text(
                        'Sign Up',
                        style: loginTitleTextStyle(),
                      ),
                      const SizedBox(height: 40),
                      Image.asset(
                        'assets/icon-round.png',
                        height: 250,
                        width: 250,
                      ),
                      const SizedBox(height: 25),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: backgroundColor2()),
                        child: TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.person, color: blueish()),
                              hintText: 'First Name',
                              border: InputBorder.none),
                          controller: _firstnameTextController,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: backgroundColor2()),
                        child: TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.person_add, color: blueish()),
                              hintText: 'Last Name',
                              border: InputBorder.none),
                          controller: _lastnameTextController,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: backgroundColor2()),
                        child: TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.email, color: blueish()),
                              hintText: 'E-Mail',
                              border: InputBorder.none),
                          controller: _emailTextController,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: backgroundColor2()),
                        child: TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.person, color: blueish()),
                              hintText: 'Username',
                              border: InputBorder.none),
                          controller: _usernameTextController,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: backgroundColor2()),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              icon: Icon(Icons.lock, color: blueish()),
                              hintText: 'Password',
                              border: InputBorder.none),
                          controller: _passwordTextController,
                        ),
                      ),
                      InkWell(
                        onTap: () => signUp(_usernameTextController.text, _passwordTextController.text, _firstnameTextController.text, _lastnameTextController.text, _emailTextController.text),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: blueish(),
                          ),
                          child: Text(
                            'Sign Up',
                            style: loginTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(height:40)
                    ],
                  ),]
                ),
              ),
            ),
          ),
        ],
      ),

      // temporary button for testing
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        //child: const Text('skip login'),
        onPressed: () {
          setState(
            () {
              loginNotifier.value = true;
            },
          );
        },
      ),
    );
  }

  // Write class-internal methods here

  Future<void> signUp(String username, String password, String firstname,
      String lastname, String email) async {
    if (username.isEmpty) {
      //Navigator.of(context).restorablePush((context, arguments) => _dialogBuilder(context, DialogArguments("Sign Up failed", "Please provide a username!")));
      return;
    } else if (password.isEmpty) {
      //Navigator.of(context).restorablePush((context, arguments) => _dialogBuilder(context, DialogArguments("Sign Up failed", "Please provide a password!")));
      return;
    } else if (firstname.isEmpty) {
        //Navigator.of(context).restorablePush((context, arguments) => _dialogBuilder(context, DialogArguments("Sign Up failed", "Please provide your Firstname!")));
      return;
    } else if (lastname.isEmpty) {
        //Navigator.of(context).restorablePush((context, arguments) => _dialogBuilder(context, DialogArguments("Sign Up failed", "Please provide your Lastname!")));
      return;
    } else if (email.isEmpty) {
          //Navigator.of(context).restorablePush((context, arguments) => _dialogBuilder(context, DialogArguments("Sign Up failed", "Please provide your E-Mail address")));
    } else {

      String result = await BackendApi().createAccount(username, password, firstname, lastname, email);
      switch (result) {
        case "200":
          //Navigator.of(context).restorablePush((context, arguments) => _dialogBuilder(context, DialogArguments("Registration was successful!", "You will now be logged in!")));
          var response = BackendApi().logIn(username, password);
          if(response == "200") {
            setState(() {
              loginNotifier.value = true;
            });
          }
          break;
      }
    }
  }

  Future<void> login(String username, String password) async {
    if(username.isEmpty && password.isEmpty) {
      Navigator.of(context).restorablePush((context, arguments) => _dialogBuilder(context, DialogArguments("Login failed", "Please provide a username and password!")));
      return;
    }
    if (username.isEmpty) {
      Navigator.of(context).restorablePush((context, arguments) => _dialogBuilder(context, DialogArguments("Login failed", "Please provide a username!")));
      return;
    }
    if (password.isEmpty) {
      Navigator.of(context).restorablePush((context, arguments) => _dialogBuilder(context, DialogArguments("Login failed", "Please provide a password!")));
      return;
    } else {
      String result = await BackendApi().logIn(username, password);
      switch (result) {
        case "200":
          Navigator.of(context).restorablePush((context, arguments) => _dialogBuilder(context, DialogArguments("Login: Authentication", "FraPods uses 2 factor authentication. You will receive an E-Mail asking you to verify this device. Click the link and then restart this app to log in!")));
          break;
        default:
          Navigator.of(context).restorablePush((context, arguments) => _dialogBuilder(context, DialogArguments("Login failed", "Wrong username or password!")));
          break;
      }
    }
  }

  Widget buildRegisterContainer() {
    return MediaQuery.of(context).viewInsets.bottom ==0? Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(70),
            topRight: Radius.circular(70),
          ),
          color: backgroundColor(),
        ),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
            animationController.forward();
            setState(() {
              isLogin = !isLogin;
            });
          },
          child: isLogin
              ? Container(
                margin: const EdgeInsets.only(top: 30),
                child: Text(
                    "Don't have an account? Sign Up",
                    style: normalTextStyle(),
                  ),
              )
              : null,
        ),
      ),
    )
    : const SizedBox();
  }

  static Route<Object?> _dialogBuilder(
      BuildContext context, DialogArguments arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: Text(arguments.title), content: Text(arguments.message)),
    );
  }

// All class-internal methods should go above this line
}

class DialogArguments {
  final String title;
  final String message;

  DialogArguments(this.title, this.message);
}