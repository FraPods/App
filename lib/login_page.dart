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

  //   void dispose() {
  //   darkNotifier.dispose();
  //   super.dispose();
  // }

  bool isLogin = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration = Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double viewInset =
        MediaQuery.of(context).viewInsets.bottom; //keyboard check
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    containerSize = Tween<double>(
            begin: size.height * 0.1, end: defaultRegisterSize)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));

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
                height: size.height * 0.1,
                alignment: Alignment.bottomCenter,
                child: IconButton(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to',
                        style: loginTitleTextStyle(),
                      ),
                      SizedBox(height: 40),
                      Image.asset(
                        'assets/icon-round.png',
                        height: 250,
                        width: 250,
                      ),
                      SizedBox(height: 40),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: backgroundColor()),
                        child: TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.email, color: blueish()),
                              hintText: 'Username',
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
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
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  width: size.width,
                  height: defaultLoginSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign Up',
                        style: loginTitleTextStyle(),
                      ),
                      SizedBox(height: 40),
                      Image.asset(
                        'assets/icon-round.png',
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(height: 40),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: backgroundColor2()),
                        child: TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.person, color: blueish()),
                              hintText: 'First Name',
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: backgroundColor2()),
                        child: TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.person_add, color: blueish()),
                              hintText: 'Last Name',
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: backgroundColor2()),
                        child: TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.email, color: blueish()),
                              hintText: 'E-Mail',
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // temporary button for testing
      floatingActionButton: FloatingActionButton(
        child: Text('skip login'),
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

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100),
            topRight: Radius.circular(100),
          ),
          color: backgroundColor(),
        ),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            animationController.forward();
            setState(() {
              isLogin = !isLogin;
            });
          },
          child: isLogin
              ? Text(
                  "Don't have an account? Sign Up",
                  style: normalTextStyle(),
                )
              : null,
        ),
      ),
    );
  }
}
