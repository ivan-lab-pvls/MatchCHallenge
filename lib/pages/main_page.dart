import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:find_a_match/model/game_utils.dart';
import 'package:find_a_match/model/level_item.dart';
import 'package:find_a_match/model/user_item.dart';
import 'package:find_a_match/pages/mainx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EPageOnSelect { startPage, levelsPage, settingPage, levelPage }

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CarouselController carouselController = CarouselController();
  EPageOnSelect page = EPageOnSelect.startPage;
  List<String> images = [
    'assets/gameIcons/bomb.png',
    'assets/gameIcons/bomb2.png',
    'assets/gameIcons/brilliant.png',
    'assets/gameIcons/chest.png',
    'assets/gameIcons/crown.png',
    'assets/gameIcons/flag.png',
    'assets/gameIcons/hourglass.png',
    'assets/gameIcons/lightning.png',
    'assets/gameIcons/mail.png',
    'assets/gameIcons/open_mail.png',
    'assets/gameIcons/present.png',
    'assets/gameIcons/refresh.png',
    'assets/gameIcons/setting_ingame.png',
    'assets/gameIcons/watch.png',
  ];
  List<String> randomImages = [];
  List<String> doubledImages = [];
  UserItem user = UserItem(money: 0);
  List<bool> togllers = [false, false, false, false];
  LevelItem level1 = LevelItem(levelNumber: 1, isCompleted: false);
  LevelItem level2 = LevelItem(levelNumber: 2, isCompleted: false);
  LevelItem level3 = LevelItem(levelNumber: 3, isCompleted: false);
  LevelItem level4 = LevelItem(levelNumber: 4, isCompleted: false);
  int matchedCard = 0;
  Game game = Game();
  bool fromLevelPage = false;
  Timer? timer;
  LevelItem selectedLevel = LevelItem();

  @override
  void initState() {
    super.initState();
    getFromSharedP();
    timer = Timer.periodic(
      const Duration(minutes: 60),
      (timer) {
        /// callback will be executed every 1 second, increament a count value
        /// on each callback
        if (user.hp! < 5) {
          setState(() {
            user.hp = user.hp! + 1;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page == EPageOnSelect.settingPage ||
              page == EPageOnSelect.levelsPage ||
              page == EPageOnSelect.startPage
          ? Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover)),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 30, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (page == EPageOnSelect.startPage ||
                          page == EPageOnSelect.levelsPage)
                        InkWell(
                            onTap: () {
                              page = EPageOnSelect.settingPage;
                              setState(() {});
                            },
                            child: Image.asset('assets/settings.png')),
                      if (page == EPageOnSelect.settingPage)
                        InkWell(
                            onTap: () {
                              page = EPageOnSelect.startPage;
                              setState(() {});
                            },
                            child: Image.asset('assets/home.png')),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.centerLeft,
                              children: [
                                Image.asset('assets/hp_container.png'),
                                Positioned(
                                    right: 35,
                                    child: Image.asset('assets/hp.png')),
                                Positioned(
                                  right: 15,
                                  bottom: 8,
                                  child: Stack(
                                    children: <Widget>[
                                      Text(
                                        user.hp.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 17,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 6
                                            ..color = const Color(0Xff59173E),
                                        ),
                                      ),
                                      // Solid text as fill.
                                      Text(
                                        user.hp.toString(),
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.centerLeft,
                            children: [
                              Image.asset('assets/money_container.png'),
                              Positioned(
                                  right: 50,
                                  child: Image.asset('assets/money.png')),
                              Positioned(
                                right: 15,
                                bottom: 8,
                                child: Stack(
                                  children: <Widget>[
                                    Text(
                                      user.money.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 6
                                          ..color = const Color(0Xff59173E),
                                      ),
                                    ),
                                    // Solid text as fill.
                                    Text(
                                      user.money.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                if (page == EPageOnSelect.settingPage)
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      scale: 0.7,
                                      image: AssetImage(
                                          'assets/setting_table.png'))),
                            ),
                            Positioned(
                              top: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 35, top: 20),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  const Show(
                                                    url:
                                                        'https://docs.google.com/document/d/1BQJy0QNwOuky7U3EJQ9ZJBfbl0cIaohiKY4sBdlCpNk/edit?usp=sharing',
                                                  )),
                                        );
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          Text(
                                            'PRIVACY POLICY',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 6
                                                ..color =
                                                    const Color(0Xff59173E),
                                            ),
                                          ),
                                          // Solid text as fill.
                                          const Text(
                                            'PRIVACY POLICY',
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 35),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  const Show(
                                                    url:
                                                        'https://docs.google.com/document/d/1uu5OiKSWG_SXuGk7OqtI5CrYG5NLl5nVdY7FQezYHkc/edit?usp=sharing',
                                                  )),
                                        );
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          Text(
                                            'TERMS OF USE',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 6
                                                ..color =
                                                    const Color(0Xff59173E),
                                            ),
                                          ),
                                          // Solid text as fill.
                                          const Text(
                                            'TERMS OF USE',
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
                                  ),
                                  InkWell(
                                    onTap: () {
                                      InAppReview.instance.openStoreListing(
                                        appStoreId: '6474870923',
                                      );
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        Text(
                                          'RATE APP',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 6
                                              ..color = const Color(0Xff59173E),
                                          ),
                                        ),
                                        // Solid text as fill.
                                        const Text(
                                          'RATE APP',
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
                                ],
                              ),
                            )
                          ],
                        ),
                        Positioned(
                            top: -10,
                            child: Image.asset('assets/setting_label.png')),
                      ],
                    ),
                  ),
                if (page == EPageOnSelect.levelsPage)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80, left: 50),
                        child: Image.asset(
                          'assets/line.png',
                          scale: 1.1,
                        ),
                      ),
                      Positioned(
                          bottom: -55,
                          left: -15,
                          child: InkWell(
                              onTap: () {
                                if (!level1.isCompleted!) {
                                  game.currentLevel = level1.levelNumber;
                                  selectedLevel = level1;
                                  game.initCardsList();
                                  game.initGame();
                                  setState(() {});
                                }
                              },
                              child: level1.isCompleted != null &&
                                      level1.isCompleted!
                                  ? Image.asset('assets/completed_level.png')
                                  : Image.asset('assets/first_level.png'))),
                      Positioned(
                          bottom: 40,
                          left: 70,
                          child: InkWell(
                              onTap: () {
                                if (!level2.isCompleted!) {
                                  game.currentLevel = level2.levelNumber;
                                  selectedLevel = level2;
                                  game.initCardsList();
                                  game.initGame();
                                  setState(() {});
                                }
                              },
                              child: level2.isCompleted != null &&
                                      level2.isCompleted!
                                  ? Image.asset('assets/completed_level.png')
                                  : Image.asset('assets/level2.png'))),
                      Positioned(
                          bottom: -45,
                          left: 170,
                          child: InkWell(
                              onTap: () {
                                if (!level3.isCompleted!) {
                                  game.currentLevel = level3.levelNumber;
                                  selectedLevel = level3;
                                  game.initCardsList();
                                  game.initGame();
                                  setState(() {});
                                }
                              },
                              child: level3.isCompleted != null &&
                                      level3.isCompleted!
                                  ? Image.asset('assets/completed_level.png')
                                  : Image.asset('assets/level3.png'))),
                      Positioned(
                          bottom: 50,
                          left: 240,
                          child: InkWell(
                              onTap: () {
                                if (!level4.isCompleted!) {
                                  game.currentLevel = level4.levelNumber;
                                  selectedLevel = level4;
                                  game.initCardsList();
                                  game.initGame();
                                  setState(() {});
                                }
                              },
                              child: level4.isCompleted != null &&
                                      level4.isCompleted!
                                  ? Image.asset('assets/completed_level.png')
                                  : Image.asset('assets/level4.png'))),
                      Positioned(
                          bottom: -40,
                          right: 265,
                          child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text(
                                          'Not enough HP.',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 17,
                                          ),
                                        ),
                                        content: Text(
                                          'Please, wait an hour.',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 17,
                                          ),
                                        ),
                                        actions: [
                                          Card(
                                            color: Colors.transparent,
                                            elevation: 0.0,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  DefaultTextStyle(
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 17,
                                                    ),
                                                    child: const Text(
                                                      'Ok',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Image.asset('assets/level5.png'))),
                      Positioned(
                          bottom: 50,
                          right: 180,
                          child: Image.asset('assets/level6.png')),
                      Positioned(
                          bottom: -40,
                          right: 90,
                          child: Image.asset('assets/level7.png')),
                      Positioned(
                          bottom: 40,
                          right: 0,
                          child: Image.asset('assets/level8.png')),
                      Positioned(
                          bottom: -70,
                          right: -60,
                          child: Image.asset('assets/level9.png')),
                    ],
                  ),
                if (page == EPageOnSelect.startPage)
                  Expanded(
                    child: CarouselSlider(
                        carouselController: carouselController,
                        items: getLevelsDifficulty(),
                        options: CarouselOptions(
                          // /aspectRatio: 1,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          initialPage: 1,
                          enableInfiniteScroll: true,
                          reverse: false,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          scrollDirection: Axis.horizontal,
                        )),
                  ),
                Padding(
                  padding: page == EPageOnSelect.levelsPage
                      ? const EdgeInsets.only(bottom: 12, top: 40)
                      : const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (page == EPageOnSelect.startPage)
                        InkWell(
                            onTap: () {
                              carouselController.previousPage();
                            },
                            child: Image.asset('assets/past.png')),
                      const SizedBox(
                        width: 18,
                      ),
                      if (page == EPageOnSelect.levelsPage)
                        InkWell(
                          onTap: () {
                            if (user.hp != 0 &&
                                selectedLevel.levelNumber != null) {
                              page = EPageOnSelect.levelPage;
                              setState(() {});
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 200,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(bottom: 5),
                                height: 100,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        scale: 0.1,
                                        image: AssetImage(
                                            'assets/main_button.png'))),
                                child: Stack(
                                  children: <Widget>[
                                    Text(
                                      'START GAME',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20,
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
                              if (selectedLevel.levelNumber == null)
                                Container(
                                  height: 70,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                            ],
                          ),
                        ),
                      if (page == EPageOnSelect.startPage)
                        InkWell(
                          onTap: () {
                            page = EPageOnSelect.levelsPage;

                            setState(() {});
                          },
                          child: Container(
                            width: 200,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(bottom: 5),
                            height: 100,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    scale: 0.1,
                                    image:
                                        AssetImage('assets/main_button.png'))),
                            child: Stack(
                              children: <Widget>[
                                Text(
                                  'START GAME',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
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
                        ),
                      const SizedBox(
                        width: 18,
                      ),
                      if (page == EPageOnSelect.startPage)
                        InkWell(
                            onTap: () {
                              carouselController.nextPage();
                            },
                            child: Image.asset('assets/next.png'))
                    ],
                  ),
                )
              ]),
            )
          : matchedCard != game.gameImg!.length
              ? Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/background2.png'),
                          fit: BoxFit.cover)),
                  child: Column(children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 30, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    page = EPageOnSelect.settingPage;
                                    selectedLevel = LevelItem();
                                    setState(() {});
                                  },
                                  child: Image.asset(
                                    'assets/settings.png',
                                    scale: 0.85,
                                  )),
                              const SizedBox(
                                width: 13,
                              ),
                              InkWell(
                                  onTap: () {
                                    page = EPageOnSelect.startPage;
                                    selectedLevel = LevelItem();
                                    setState(() {});
                                  },
                                  child: Image.asset('assets/home.png')),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Image.asset('assets/hp_container.png'),
                                    Positioned(
                                        right: 35,
                                        child: Image.asset('assets/hp.png')),
                                    Positioned(
                                      right: 15,
                                      bottom: 8,
                                      child: Stack(
                                        children: <Widget>[
                                          Text(
                                            user.hp.toString(),
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 6
                                                ..color =
                                                    const Color(0Xff59173E),
                                            ),
                                          ),
                                          // Solid text as fill.
                                          Text(
                                            user.hp.toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.centerLeft,
                                children: [
                                  Image.asset('assets/money_container.png'),
                                  Positioned(
                                      right: 50,
                                      child: Image.asset('assets/money.png')),
                                  Positioned(
                                    right: 15,
                                    bottom: 8,
                                    child: Stack(
                                      children: <Widget>[
                                        Text(
                                          user.money.toString(),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 17,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 6
                                              ..color = const Color(0Xff59173E),
                                          ),
                                        ),
                                        // Solid text as fill.
                                        Text(
                                          user.money.toString(),
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 17,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    scale: 1.0,
                                    image:
                                        AssetImage('assets/level_table.png'))),
                          ),
                          Positioned(
                            top: -30,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/levelname.png',
                                  scale: 4.0,
                                ),
                                Positioned(
                                  top: 15,
                                  child: Stack(
                                    children: <Widget>[
                                      Text(
                                        'LEVEL  ${game.currentLevel}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 6
                                            ..color = const Color(0Xff59173E),
                                        ),
                                      ),
                                      // Solid text as fill.
                                      Text(
                                        'LEVEL  ${game.currentLevel}',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top:
                                game.currentLevel == 3 || game.currentLevel == 4
                                    ? 27
                                    : game.currentLevel == 1
                                        ? 60
                                        : game.currentLevel == 2
                                            ? 70
                                            : 0,
                            child: SizedBox(
                                height: game.currentLevel == 3 ||
                                        game.currentLevel == 4
                                    ? 350
                                    : game.currentLevel == 1
                                        ? 200
                                        : 250,
                                width: game.currentLevel == 3 ||
                                        game.currentLevel == 4
                                    ? 350
                                    : game.currentLevel == 1
                                        ? 200
                                        : 250,
                                child: GridView.builder(
                                    itemCount: game.gameImg!.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: game.currentLevel == 3 ||
                                              game.currentLevel == 4
                                          ? 4
                                          : game.currentLevel == 1
                                              ? 2
                                              : 3,
                                      crossAxisSpacing: 16.0,
                                      mainAxisSpacing: 16.0,
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            //incrementing the clicks

                                            game.gameImg![index] =
                                                game.cards_list[index];
                                            game.matchCheck.add({
                                              index: game.cards_list[index]
                                            });
                                          });
                                          if (game.matchCheck.length == 2) {
                                            if (game.matchCheck[0].values
                                                    .first ==
                                                game.matchCheck[1].values
                                                    .first) {
                                              game.matchCheck.clear();
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1000), () {
                                                matchedCard = matchedCard + 2;
                                                if (matchedCard ==
                                                    game.gameImg!.length) {
                                                  if (game.currentLevel ==
                                                      level1.levelNumber) {
                                                    level1.isCompleted = true;
                                                    user.money =
                                                        user.money! + 100;

                                                    user.hp = user.hp! - 1;
                                                  } else if (game
                                                          .currentLevel ==
                                                      level2.levelNumber) {
                                                    level2.isCompleted = true;
                                                    user.money =
                                                        user.money! + 100;
                                                    user.hp = user.hp! - 1;
                                                  } else if (game
                                                          .currentLevel ==
                                                      level3.levelNumber) {
                                                    level3.isCompleted = true;
                                                    user.money =
                                                        user.money! + 100;
                                                    user.hp = user.hp! - 1;
                                                  } else if (game
                                                          .currentLevel ==
                                                      level4.levelNumber) {
                                                    level4.isCompleted = true;
                                                    user.money =
                                                        user.money! + 100;
                                                    user.hp = user.hp! - 1;
                                                  }
                                                }
                                                setState(() {});
                                              });
                                            } else {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                setState(() {
                                                  game.gameImg![game
                                                          .matchCheck[0]
                                                          .keys
                                                          .first] =
                                                      game.hiddenCardpath;
                                                  game.gameImg![game
                                                          .matchCheck[1]
                                                          .keys
                                                          .first] =
                                                      game.hiddenCardpath;
                                                  game.matchCheck.clear();
                                                });
                                              });
                                            }
                                          }
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/gameIcons/icon_container.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            game.gameImg![index] !=
                                                    "assets/gameIcons/icon_container.png"
                                                ? Positioned(
                                                    bottom: 20,
                                                    child: Image.asset(
                                                      game.gameImg![index],
                                                      scale: 1.5,
                                                    ),
                                                  )
                                                : const SizedBox()
                                          ],
                                        ),
                                      );
                                    })),
                          )
                        ],
                      ),
                    ),
                  ]),
                )
              : Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/background2.png'),
                          fit: BoxFit.cover)),
                  child: Column(children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 30, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    page = EPageOnSelect.settingPage;
                                    setState(() {});
                                  },
                                  child: Image.asset(
                                    'assets/settings.png',
                                    scale: 0.85,
                                  )),
                              const SizedBox(
                                width: 13,
                              ),
                              InkWell(
                                  onTap: () {
                                    page = EPageOnSelect.startPage;
                                    setState(() {});
                                  },
                                  child: Image.asset('assets/home.png')),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Image.asset('assets/hp_container.png'),
                                    Positioned(
                                        right: 35,
                                        child: Image.asset('assets/hp.png')),
                                    Positioned(
                                      right: 15,
                                      bottom: 8,
                                      child: Stack(
                                        children: <Widget>[
                                          Text(
                                            user.hp.toString(),
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 6
                                                ..color =
                                                    const Color(0Xff59173E),
                                            ),
                                          ),
                                          // Solid text as fill.
                                          Text(
                                            user.hp.toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.centerLeft,
                                children: [
                                  Image.asset('assets/money_container.png'),
                                  Positioned(
                                      right: 50,
                                      child: Image.asset('assets/money.png')),
                                  Positioned(
                                    right: 15,
                                    bottom: 8,
                                    child: Stack(
                                      children: <Widget>[
                                        Text(
                                          user.money.toString(),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 17,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 6
                                              ..color = const Color(0Xff59173E),
                                          ),
                                        ),
                                        // Solid text as fill.
                                        Text(
                                          user.money.toString(),
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 17,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: -30,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/levelname.png',
                                scale: 4.0,
                              ),
                              Positioned(
                                top: 15,
                                child: Stack(
                                  children: <Widget>[
                                    Text(
                                      'LEVEL ${game.currentLevel} IS OVER!',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 6
                                          ..color = const Color(0Xff59173E),
                                      ),
                                    ),
                                    // Solid text as fill.
                                    Text(
                                      'LEVEL ${game.currentLevel} IS OVER!',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset('assets/catgameover.png'),
                        Positioned(
                          bottom: 10,
                          child: InkWell(
                            onTap: () {
                              page = EPageOnSelect.levelsPage;
                              matchedCard = 0;
                              selectedLevel = LevelItem();
                              addToSharedP(
                                  level1, level2, level3, level4, user);
                              setState(() {});
                            },
                            child: Container(
                              width: 200,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(bottom: 5),
                              height: 100,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      scale: 0.1,
                                      image: AssetImage(
                                          'assets/main_button.png'))),
                              child: Stack(
                                children: <Widget>[
                                  Text(
                                    'OK',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 6
                                        ..color = const Color(0Xff59173E),
                                    ),
                                  ),
                                  // Solid text as fill.
                                  const Text(
                                    'OK',
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
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          right: -30,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.centerLeft,
                            children: [
                              Image.asset(
                                'assets/big_money_table.png',
                              ),
                              Positioned(
                                  right: 100,
                                  child: Image.asset('assets/big_money.png')),
                              Positioned(
                                right: 30,
                                bottom: 20,
                                child: Stack(
                                  children: <Widget>[
                                    Text(
                                      '+100',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 25,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 6
                                          ..color = const Color(0Xff59173E),
                                      ),
                                    ),
                                    // Solid text as fill.
                                    const Text(
                                      '+100',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ]),
                ),
    );
  }

  Future<void> addToSharedP(LevelItem? level1, LevelItem? level2,
      LevelItem? level3, LevelItem? level4, UserItem? user) async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    String rawJson1 = jsonEncode(level1!.toJson());
    prefs.setString('level1', rawJson1);

    String rawJson2 = jsonEncode(level2!.toJson());
    prefs.setString('level2', rawJson2);

    String rawJson3 = jsonEncode(level3!.toJson());
    prefs.setString('level3', rawJson3);

    String rawJson4 = jsonEncode(level4!.toJson());
    prefs.setString('level4', rawJson4);
    String rawJson5 = jsonEncode(user!.toJson());
    prefs.setString('user', rawJson5);
  }

  void getFromSharedP() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson1 = prefs.getString('level1') ?? '';
    final rawJson2 = prefs.getString('level2') ?? '';
    final rawJson3 = prefs.getString('level3') ?? '';
    final rawJson4 = prefs.getString('level4') ?? '';
    final rawJson5 = prefs.getString('user') ?? '';
    Map<String, dynamic> map1 = {};
    Map<String, dynamic> map2 = {};
    Map<String, dynamic> map3 = {};
    Map<String, dynamic> map4 = {};
    Map<String, dynamic> map5 = {};
    if (rawJson1.isNotEmpty) {
      map1 = jsonDecode(rawJson1);
    }
    if (rawJson2.isNotEmpty) {
      map2 = jsonDecode(rawJson2);
    }
    if (rawJson3.isNotEmpty) {
      map3 = jsonDecode(rawJson3);
    }
    if (rawJson4.isNotEmpty) {
      map4 = jsonDecode(rawJson4);
    }
    if (rawJson5.isNotEmpty) {
      map5 = jsonDecode(rawJson5);
    }
    if (map1.isNotEmpty) {
      level1 = LevelItem.fromJson(map1);
    }
    if (map2.isNotEmpty) {
      level2 = LevelItem.fromJson(map2);
    }
    if (map3.isNotEmpty) {
      level3 = LevelItem.fromJson(map3);
    }
    if (map4.isNotEmpty) {
      level4 = LevelItem.fromJson(map4);
    }
    if (map5.isNotEmpty) {
      user = UserItem.fromJson(map5);
    }
    setState(() {});
  }

  List<Widget> getLevelsDifficulty() {
    List<Widget> list = [];
    list.add(Image.asset('assets/simple_level.png'));
    list.add(Image.asset('assets/middle_level.png'));
    list.add(Image.asset('assets/advanced_level.png'));
    return list;
  }
}
