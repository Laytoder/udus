import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/namePage.dart';
import 'package:introduction_screen/introduction_screen.dart';

class GettingStarted extends StatelessWidget {
  AppState appState;

  GettingStarted({
    @required this.appState,
  });

  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NamePage(appState),
      ),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.png', width: 300.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 15.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 18.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "udus AI",
          body: "Finds you the cheapest seller combo!",
          image: _buildImage('slide1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Always on time",
          image: _buildImage('slide2'),
          body: "30 mins guaranteed arrival",
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Live Tracking",
          body: "Get to know when your vendor is arriving",
          image: _buildImage('slide3'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.keyboard_arrow_right),
      done: const Text(
        'Get started',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(35, 205, 99, 1.0),
        ),
      ),
      dotsDecorator: const DotsDecorator(
        spacing: EdgeInsets.symmetric(horizontal: 4),
        size: Size(7.0, 7.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(16.0, 7.0),
        activeColor: Color.fromRGBO(35, 205, 99, 1.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
