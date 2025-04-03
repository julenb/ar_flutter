import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const users = {
  'julen@gmail.es': '12345',
  'alex@gmail.es': '12345',
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return 'Password sent to your email';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'EL-CAMINO',
      logo: const AssetImage('assets/logo.png'),
      theme: LoginTheme(
        primaryColor: Colors.green[800]!,
        accentColor: const Color.fromARGB(255, 255, 255, 255)!,
        buttonTheme: const LoginButtonTheme(
          backgroundColor: Color(0xFF2E7D32), // Darker green
          highlightColor: Color(0xFF388E3C), // Slightly lighter dark green
        ),
        
      
      ),
      onLogin: _authUser,
      onSignup: _signupUser,
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            debugPrint('start google sign in');
            await Future.delayed(loginTime);
            debugPrint('stop google sign in');
            return null;
          },
        ),
        //apple
        LoginProvider(
          icon: FontAwesomeIcons.apple,
          label: 'Apple',
          callback: () async {
            debugPrint('start apple sign in');
            await Future.delayed(loginTime);
            debugPrint('stop apple sign in');
            return null;
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Map(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
