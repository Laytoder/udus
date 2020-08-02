import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/namePage.dart';
import 'package:introduction_screen/introduction_screen.dart';

class GettingStarted extends StatelessWidget {
  AppState appState;
  GettingStarted({
    this.appState,
  });

  List<PageViewModel> getPages() {
    return [
      new PageViewModel(
        image: Center(
          child: Image.asset('assets/slide1.png'),
        ),
        title: "Call Vendor to your Doorstep",
        body: "",
        decoration: PageDecoration(
          contentPadding: EdgeInsets.only(top: 80),
        ),
      ),
      new PageViewModel(
        image: Center(
          child: Image.asset('assets/slide2.png'),
        ),
        title: "30 mins guaranteed arrival",
        body: "",
        decoration: PageDecoration(
          contentPadding: EdgeInsets.only(top: 80),
        ),
      ),
      new PageViewModel(
        image: Center(
          child: Image.asset('assets/slide3.png'),
        ),
        title: "Track your Vendor live",
        body: "",
        decoration: PageDecoration(
          contentPadding: EdgeInsets.only(top: 80),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE0E5EC),
      body: IntroductionScreen(
        next: Icon(Icons.arrow_forward_ios),
        showSkipButton: true,
        skip: Text(
          "SKIP",
          style: TextStyle(
            color: Color.fromRGBO(35, 205, 99, 1.0),
          ),
        ),
        onSkip: () {},
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Color.fromRGBO(35, 205, 99, 1.0),
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
        pages: getPages(),
        onDone: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NamePage(appState),
            ),
          );
        },
        globalBackgroundColor: Color(0xffE0E5EC),
        done: Text(
          "CONTINUE",
          style: TextStyle(
            color: Color.fromRGBO(35, 205, 99, 1.0),
          ),
        ),
      ),
    );
  }
}
