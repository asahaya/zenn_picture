import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'photo_list.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formGlobalKey = GlobalKey<FormState>();
  // メールアドレス用のTextEditingController
  final TextEditingController _emailController = TextEditingController();
  // パスワード用のTextEditingController
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        //keyの設定
        key: _formGlobalKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            // Columnを使い縦に並べる
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // タイトル
                Text(
                  'Photo App',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(height: 16),
                // 入力フォーム（メールアドレス）
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'メールアドレス'),
                  keyboardType: TextInputType.emailAddress,
                  //email_バリテーション
                  //isEmpty=空
                  validator: (String? value) {
                    if (value?.isEmpty == true) {
                      return 'eMailを入力しましょう';
                    }
                    //ＯＫな場合
                    return null;
                  },
                ),
                SizedBox(height: 8),
                // 入力フォーム（パスワード）
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'パスワード'),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  //ＰＡＳＳ_バリテーション
                  //isEmpty=空
                  validator: (String? value) {
                    if (value?.isEmpty == true) {
                      return 'ＰＡＳＳを入力しましょう';
                    }
                    //ＯＫな場合
                    return null;
                  },
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  // ボタン（ログイン）
                  child: ElevatedButton(
                    onPressed: () => {
                      _onSignIn(),
                    },
                    child: Text('ログイン'),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  // ボタン（新規登録）
                  child: ElevatedButton(
                    onPressed: () => {
                      _onSignUp(),
                    },
                    child: Text('新規登録'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 内部で非同期処理(Future)を扱っているのでasyncを付ける
  //   この関数自体も非同期処理となるので返り値もFutureとする
  Future<void> _onSignUp() async {
    try {
      if (_formGlobalKey.currentState?.validate() != true) {
        return;
      }

      // メールアドレス・パスワードで新規登録
      //   TextEditingControllerから入力内容を取得
      //   Authenticationを使った複雑な処理はライブラリがやってくれる
      final String email = _emailController.text;
      final String password = _passwordController.text;
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 画像一覧画面に切り替え
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PhotoListScreen(),
        ),
      );
    } catch (e) {
      // 失敗したらエラーメッセージを表示
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text("error--->${e.toString()}"),
          );
        },
      );
    }
  }

  Future<void> _onSignIn() async {
    try {
      if (_formGlobalKey.currentState?.validate() != true) {
        return;
      }
      // 新規登録と同じく入力された内容をもとにログイン処理を行う
      final String email = _emailController.text;
      final String password = _passwordController.text;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => PhotoListScreen()));
    } catch (eee) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('error!!!!!!!!'),
              content: Text(eee.toString()),
            );
          });
    }
    //currentState=現在の状態
    //validate=検証
  }
}
