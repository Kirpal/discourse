import 'package:discourse/models/app_state.dart';
import 'package:discourse/ui/enter_name_page.dart';
import 'package:discourse/ui/loading_page.dart';
import 'package:discourse/ui/pick_position_page.dart';
import 'package:discourse/ui/video_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey;

  MainApp() : _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(_navigatorKey.currentState),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        title: 'Discourse',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          scaffoldBackgroundColor: Color(0xffFDC52A),
          dialogTheme: DialogTheme(
            contentTextStyle: TextStyle(color: Colors.black),
          ),
        ),
        initialRoute: '/enter-name',
        routes: {
          '/enter-name': (context) => EnterNamePage(),
          '/pick-position': (context) => PickPositionPage(),
          '/video': (context) => VideoPage(),
          '/loading': (context) => LoadingPage(),
        },
      ),
    );
  }
}
