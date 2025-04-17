import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'inicio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inicio.dart';
import 'main.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCbULcWOICbBq2CdOzLGjRiGYamCtGokuU",
        authDomain: "camino-57345.firebaseapp.com",
        projectId: "camino-57345",
        storageBucket: "camino-57345.firebasestorage.app",
        messagingSenderId: "879057736072",
        appId: "1:879057736072:web:89bb90afa1312ae1e66a3d",
        measurementId: "G-CWC4XW9793",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Cargar la preferencia del tema
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('theme') ?? 'light';

  if (savedTheme == 'dark') {
    themeNotifier.value = ThemeMode.light;
  } else {
    themeNotifier.value = ThemeMode.light;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Login Demo',
        theme: ThemeData(
          primaryColor: const Color(0xFF4D94E1),
        ),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        home: const AuthWrapper(),
      ),
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

  // Duration get loginTime => const Duration(milliseconds: 2250);
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
      if (kIsWeb) {

        // 🌐 FLUTTER WEB: usa Firebase para hacer login con popup directamente
        final googleProvider = GoogleAuthProvider();

        // Opcional: scopes
        googleProvider
          ..addScope('email')
          ..setCustomParameters({'prompt': 'select_account'});

        await _auth.signInWithPopup(googleProvider);
        return null; // éxito
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return 'Inicio de sesión cancelado';

        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
        return null; // éxito
      }
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
      title: 'Pilgrim\'s App',
      logo: const AssetImage('images/logo.png'),
      theme: LoginTheme(
          primaryColor: const Color(0xFF4D94E1), // Fondo principal azul
          titleStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
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
