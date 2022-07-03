import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'photo_list.dart';
import 'sign_in_screen.dart';

void main() async {
  // Flutterの初期化処理を待つ
  WidgetsFlutterBinding.ensureInitialized();

  // アプリ起動前にFirebase初期化処理を入れる
  //   initializeApp()の返り値がFutureなので非同期処理
  //   非同期処理(Future)はawaitで処理が終わるのを待つことができる
  //   ただし、awaitを使うときは関数にasyncを付ける必要がある
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Photo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // アプリ起動時にログイン画面を表示
        home: FirebaseAuth.instance.currentUser == null
            ? SignInScreen()
            : PhotoListScreen());
  }
}
