import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'inicio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: const AuthWrapper(),
    );
  }
}


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return Inicio(); // Si el usuario está autenticado, va directo al mapa
        }
        return LoginScreen();
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔑 Autenticación con Firebase (Email/Contraseña)
  Future<String?> _authUser(LoginData data) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      return null; // Éxito
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );
      return null; // Registro exitoso
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> _recoverPassword(String name) async {
    try {
      await _auth.sendPasswordResetEmail(email: name);
      //return 'Se ha enviado un enlace de recuperación a tu correo';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null) return 'Error en la autenticación de Google';

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return null; // Éxito
    } catch (e) {
      return 'Error con Google: ${e.toString()}';
    }
  }

Future<String?> _signInWithApple() async {
  try {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'tu.client.id',  // Reemplaza con tu Client ID ------>crear cuenta apple desarrollador
        redirectUri: Uri.parse('https://camino-57345.firebaseapp.com/__/auth/handler'),
      ),
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    return null; // Éxito
  } catch (e) {
    print('Error con Apple: ${e.toString()}');
    return 'Error con Apple: ${e.toString()}';
  }
}

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'EL-CAMINO',
      logo: const AssetImage('assets/logo.png'),
      theme: LoginTheme(
        // primaryColor: Colors.green[800]!,
        // accentColor: const Color.fromARGB(255, 255, 255, 255),
        // buttonTheme: const LoginButtonTheme(
        //   backgroundColor: Color(0xFF2E7D32), // Verde oscuro
        //   highlightColor: Color(0xFF388E3C), // Verde más claro
        // ),
        logoWidth: 0.75
      ),
      onLogin: _authUser,
      onSignup: _signupUser,
      onRecoverPassword: _recoverPassword,
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: _signInWithGoogle,
        ),
        LoginProvider(
          icon: FontAwesomeIcons.apple,
          label: 'Apple',
          callback: _signInWithApple,
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Inicio(),
        ));
      },
    );
  }
}
