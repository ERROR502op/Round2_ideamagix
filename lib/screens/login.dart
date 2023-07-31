
import 'package:ecommerce/model/privacy.dart';
import 'package:ecommerce/screens/homescreen.dart';
import 'package:ecommerce/theme/color_theme.dart';
import 'package:ecommerce/theme/textstyle.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../popup_menu/failedalert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool checkboxValue = false;
  bool checkboxError = false;
  Map<String, dynamic>? staffData;
  int? empID;
  String? empName;
  String? mobile;
  String? email;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final url = Uri.parse('https://fakestoreapi.com/auth/login');
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
      },
    );

    if (mounted) {
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);
        await prefs.setString('login', "login");
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
                (route) => false,
          );
        }
      } else {
        // Handle the error case
        showErrorDialog('Error', 'Invalid Username Or Password');
      }
    } else {
      // Handle the error case
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const FailedAlertDialog();
        },
      );
    }
  }

  // Method to show error dialog
  Future<void> showErrorDialog(String title, String content) {
    return showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  // Check internet connection
  Future<bool> _checkInternetConnection() async {
    final isConnected = await InternetConnectionChecker().hasConnection;
    return isConnected;
  }

  @override
  Widget build(BuildContext context) {
    const commonPadding = EdgeInsets.all(10);

    return Scaffold(
      backgroundColor: MyColorTheme.background,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          // Use the DecorationImage to set the background image
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_image.png"), // Replace with your image file path
              fit: BoxFit.cover,
            ),
            color: Color.fromRGBO(255, 255, 255, 0.8), // Set the alpha value (0.8 = 80% opacity)
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Lottie.asset(
                        "assets/lottie/authentication.json",
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        "assets/images/ideamagix-logo-g.png",
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text("Enter Your Credential and get login "),

                    Padding(
                      padding: commonPadding,
                      child: TextFormField(
                        controller: usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Username';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_add_alt,
                            color: MyColorTheme.darkcolor,
                          ),

                          labelStyle: editTextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: MyColorTheme.darkcolor),
                          hintText: "Enter Username",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: MyColorTheme
                                  .darkcolor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: MyColorTheme
                                  .darkcolor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: commonPadding,
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscureText,
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.password_sharp,
                            color: MyColorTheme.darkcolor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: MyColorTheme.darkcolor,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),

                          labelStyle: editTextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: MyColorTheme.darkcolor),
                          hintText: "Enter password",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: MyColorTheme
                                  .darkcolor, // Set the enabled border color here
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: MyColorTheme
                                  .darkcolor, // Set the focused border color here
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: checkboxValue,
                          onChanged: (value) {
                            setState(() {
                              checkboxValue = value ?? false;
                              checkboxError =
                              false; // Reset the checkbox error status
                            });
                          },
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: const Text('Privacy Policy'),
                                      content: SingleChildScrollView(
                                        child: Text(privacyPolicyText),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            child: const Text(
                              'I have read and agree to the privacy policy, terms of service, and community guidelines.',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (checkboxError)
                      Text(
                        'Please agree to the Privacy policy',
                        style: TextStyle(
                          color: MyColorTheme.darkcolor,
                          fontSize: 12,
                        ),
                      ),

                    Container(
                      height: 70,
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColorTheme.darkcolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final isConnected = await _checkInternetConnection();
                            if (isConnected) {
                              if (checkboxValue) {
                                _login();
                              } else {
                                setState(() {
                                  checkboxError =
                                  true;
                                });
                              }
                            } else {
                              // No internet connection, show an error message
                              showErrorDialog('Error', 'No internet connection.');
                            }
                          }
                        },
                        child: const Text(
                          "Get Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextButton(onPressed:(){}, child: Text("Forgot Password !"))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
