import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:ecommerce/screens/homescreen.dart';
import 'package:ecommerce/theme/color_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final int _numPages = 4; // Number of onboarding pages
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    checkIfFirstTime(); // Call the function to check if it's the first time the app is opened
  }
  void _setOnboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboardingCompleted', true);
  }

  // Function to check if it's the first time the app is opened
  void checkIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    if (onboardingCompleted) {
      // If onboarding is completed, navigate to the homepage directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              // Your onboarding pages go here
              buildOnboardingPage(
                "Welcome Screen",
                "This is the first screen users see when they open the app for the first time. It aims to welcome users and give a brief introduction to the app's main features.",
                MyColorTheme.whiteColor,
                "assets/onbordingscreen/welcome_screen.png",
              ),
              buildOnboardingPage(
                "Product Quality",
                "This screen emphasizes the e-commerce app's commitment to offering high-quality products to users.",
                MyColorTheme.whiteColor,
                "assets/onbordingscreen/product_quality.png",
              ),
              buildOnboardingPage(
                "Fast Delivery",
                "This screen highlights the app's focus on providing fast and reliable delivery services to users.",
                MyColorTheme.whiteColor,
                "assets/onbordingscreen/fast_delivery.png",
              ),
              buildOnboardingPage(
                "How it Works",
                "This screen provides a quick guide on how to use the app and what users can expect.",
                MyColorTheme.whiteColor,
                "assets/onbordingscreen/how_its_work.png",
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage != _numPages - 1)
                    MaterialButton(
                      onPressed: () {
                        _pageController.animateToPage(
                          _numPages - 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  DotsIndicator(
                    dotsCount: _numPages,
                    position: _currentPage,
                    decorator: DotsDecorator(
                      color: Colors.grey, // Inactive dot color
                      activeColor: Colors.blue, // Active dot color
                    ),
                  ),
                  MaterialButton(
                    color: MyColorTheme.darkcolor,
                    onPressed: () {
                      _setOnboardingCompleted();
                      if (_currentPage == _numPages - 1) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Homepage()),
                              (route) => false,
                        );
                      } else {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Text(
                      _currentPage == _numPages - 1 ? "Get Started" : "Next",
                      style: TextStyle(color: MyColorTheme.whiteColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOnboardingPage(
      String title,
      String description,
      Color color,
      String imagePath,
      ) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 200),
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(fontSize: 24, color: MyColorTheme.darkcolor),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
