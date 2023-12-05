import 'package:flutter/material.dart';
import 'package:orchestrator/data/data_repository.dart';
import 'package:orchestrator/screens/in_app/home_page.dart';
import 'package:orchestrator/screens/widgets/input_field_widget.dart';
import 'package:orchestrator/utils/dimensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController nameController = TextEditingController();
  bool isSaving = false;
  Future<void> saveUser(String userName) async {
    setState(() {
      isSaving = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = await DataRepository.saveUserRepository(userName);

    if (userData['success']) {
      int userId = userData['userId'];
      prefs.setString("userName", userName);
      prefs.setInt("userId", userId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration successful"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userName: userName,
              userId: userId,
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        setState(() {
          isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Try again later..."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(screenHeight(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: screenHeight(250),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight(20),
            ),
            Text(
              "Registration",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenHeight(22),
              ),
            ),
            SizedBox(
              height: screenHeight(20),
            ),
            InputFieldWidget(
              controller: nameController,
              inputHeading: "Username",
              hintText: "Enter your username",
              formHeight: screenHeight(50),
              maxLines: 1,
              centered: true,
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Enter username"),
                      duration: Duration(microseconds: 500),
                    ),
                  );
                } else {
                  saveUser(nameController.text);
                }
              },
              child: Container(
                width: double.infinity,
                height: screenHeight(50),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(screenHeight(10)),
                  ),
                ),
                child: Center(
                  child: isSaving
                      ? SizedBox(
                          height: screenHeight(30),
                          width: screenWidth(30),
                          child: const CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          "Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
