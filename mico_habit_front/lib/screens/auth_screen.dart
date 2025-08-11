import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;
import 'package:flutter_keychain/flutter_keychain.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  Future<void> _loginWithGoogle(BuildContext context) async {
    if (!context.mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('ログインがキャンセルされました')),
        );
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('認証情報が取得できませんでした')),
        );
        return;
      }

      final clientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];

      if (clientId == null) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('環境変数にクライアントIDが設定されていません')),
        );
        return;
      }

      final apiUrl = '${dotenv.env['API_URL']}';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'providerName': 'google',
          'token': idToken,
          'clientId': clientId,
        }),
      );

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        // レスポンスボディをJSONとして解析
        final responseBody = jsonDecode(response.body);
        final jwtToken = responseBody['token']; // 'token' フィールドからJWTを取得

        if (jwtToken != null) {
          // JWTをキーチェーンに安全に保存
          await FlutterKeychain.put(key: "jwt", value: jwtToken);
          developer.log('JWTをキーチェーンに保存しました');

          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('ログインに成功しました')),
          );
          // TODO: ここでナビゲーションや認証状態の更新を行う
        } else {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('サーバーからのトークンが取得できませんでした')),
          );
        }
      } else {
        developer.log('ログイン失敗！ステータスコード: ${response.statusCode}');
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['error'] ?? '不明なエラー';
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('ログイン失敗: $errorMessage')),
        );
      }
    } catch (e) {
      developer.log('エラーが発生しました: $e');
      if (!context.mounted) return;
      scaffoldMessenger.showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _loginWithGoogle(context),
          icon: const Icon(Icons.login),
          label: const Text('Googleでログイン'),
        ),
      ),
    );
  }
}
