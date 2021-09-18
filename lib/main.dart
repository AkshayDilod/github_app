import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'services/db_service.dart';
import 'services/firebase_auth.dart';
import 'ui/views/login_view.dart';
import 'ui/views/otp_view.dart';
import 'viewModel/main_view_model.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'services/biomertric_service.dart';
import 'ui/views/main_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainViewModel>(
            create: (context) => MainViewModel()),
        Provider<AuthWithBiometric>(
          create: (context) => AuthWithBiometric(),
        ),
        Provider<MobileAuth>(
          create: (context) => MobileAuth(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: primaryColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
          ),
          primarySwatch: Colors.blue,
        ),
        home: LoginView(),
      ),
    );
  }
}