import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_course/state/auth/provider/auth_state_provider.dart';
import 'package:instagram_clone_course/state/auth/provider/is_logged_in_provider.dart';
import 'package:instagram_clone_course/views/components/loading/loading_screen.dart';
import 'firebase_options.dart';

import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          indicatorColor: Colors.blueGrey),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Consumer(builder: (context, ref, _) {
        final isLoggedIn = ref.watch(isLoggedInProvider);
        if (isLoggedIn) {
          return const HomePage();
        } else {
          return const LoginView();
        }
      }),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomePage'),
        ),
        body: Consumer(builder: (_, ref, child) {
          return TextButton(
              onPressed: () async {
                // await ref.read(authStateProvider.notifier).logOut();
                LoadingScreen.instance()
                    .show(context: context, text: 'Loading');
              },
              child: const Text('lOGOUT'));
        }));
  }
}

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('LoginView'),
        ),
        body: Column(
          children: [
            TextButton(
                onPressed: () =>
                    ref.read(authStateProvider.notifier).loginWithGoogle(),
                child: const Text('Sign In with Google')),
            TextButton(
                onPressed: () =>
                    ref.read(authStateProvider.notifier).loginWithFacebook(),
                child: const Text('Sign In with Facebook')),
          ],
        ),
      );
    });
  }
}

extension Log on Object {
  void log() => devtools.log(toString());
}
