import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hr_app/models/routine_provider.dart';
import 'package:hr_app/scenes/home_page.dart';
import 'package:hr_app/scenes/mypage.dart';
import 'package:hr_app/scenes/routine_create_page.dart';
import 'package:hr_app/scenes/workout_list_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hr_app/scenes/routine_start_page.dart';
import 'package:hr_app/scenes/routine_setting_page.dart';
import 'package:provider/provider.dart';

import 'models/routine_model.dart';
import 'scenes/routine_list_page.dart';
import 'scenes/workout_create_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RoutineModelAdapter());
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: 'Routine_page',
//       routes: {
//         'Routine_page': (context) => RoutinePage(),
//         'Routine_create_page': (context) => RoutineCreatePage(),
//         'Workout_page': (context) => WorkoutPage(),
//         'Workout_create_page': (context) => WorkoutCreatePage(),
//         'MyPage': (context) => MyPage(),
//       },
//       theme: ThemeData(fontFamily: 'NotoSans'),
//     );
//   }
// }
//
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RoutineProvider(),
      child: MaterialApp(
        routes: {
          'Home_page': (context) => HomePage(),
          'Routine_page': (context) => RoutineListPage(),
          'Routine_create_page': (context) => RoutineCreatePage(),
          'Routine_start_page': (context) => RoutineStartPage(),
          'Routine_setting_page': (context) => RoutineSettingPage(),
          'Workout_page': (context) => WorkoutListPage(),
          'Workout_create_page': (context) => WorkoutCreatePage(),
          'MyPage': (context) => MyPage(),
        },
        theme: ThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSans'),
          ),
        ),
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            body: SafeArea(
              child: TabBarView(
                children: [
                  HomePage(),
                  RoutineListPage(),
                  WorkoutListPage(),
                  MyPage(),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.transparent,
                tabs: [
                  Tab(
                    icon: FaIcon(FontAwesomeIcons.home),
                    text: 'Home',
                  ),
                  Tab(
                    icon: FaIcon(FontAwesomeIcons.clipboardList),
                    text: 'Routine',
                  ),
                  Tab(
                    icon: FaIcon(FontAwesomeIcons.dumbbell),
                    text: 'Work Out',
                  ),
                  Tab(
                    icon: FaIcon(FontAwesomeIcons.userAlt),
                    text: 'My Page',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
