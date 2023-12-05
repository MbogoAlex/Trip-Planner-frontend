import 'package:flutter/material.dart';
import 'package:orchestrator/screens/in_app/home_page.dart';
import 'package:orchestrator/screens/registration/registration_page.dart';
import 'package:orchestrator/utils/dimensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String? userName;
  int? userId;
  late AnimationController controller;
  late Animation<double> animation;

  Future<void> navigate() async {
    bool exists = await userExists();
    Widget destination = exists
        ? HomePage(userName: userName!, userId: userId!)
        : const RegistrationPage();

    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    }
  }

  Future<bool> userExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? theUserName = prefs.getString("userName");
    int? theUserId = prefs.getInt("userId");

    if (theUserName != null && theUserId != null) {
      userName = theUserName;
      userId = theUserId;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: animation,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: screenHeight(150),
                      width: screenWidth(150),
                    ),
                    SizedBox(
                      height: screenHeight(20),
                    ),
                    Text(
                      "Orchestrator",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight(18),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    navigate();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 500),
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    controller.forward();
  }
}
