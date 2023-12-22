import 'package:find_a_match/pages/main_page.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.cover)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Image.asset('assets/tiger.png'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/dialog.png'),
                            fit: BoxFit.fill)),
                    child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tiger',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Welcome to Match challenge: Jungle way! Start your journey and play games!',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          )
                        ]),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const MainPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 200,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 5),
                      height: 100,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              scale: 0.1,
                              image: AssetImage('assets/main_button.png'))),
                      child: Stack(
                        children: <Widget>[
                          Text(
                            'START GAME',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = const Color(0Xff59173E),
                            ),
                          ),
                          // Solid text as fill.
                          const Text(
                            'START GAME',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
