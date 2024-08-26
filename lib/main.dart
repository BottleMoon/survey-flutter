import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:survey/locator.dart';
import 'package:survey/view/home_view.dart';
import 'package:survey/view/sign_in_view.dart';
import 'package:survey/viewModel/auth_view_model.dart';
import 'package:survey/viewModel/survey_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUp();
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => GetIt.instance<AuthViewModel>(),
      ),
      ChangeNotifierProvider(create: (_) => GetIt.instance<SurveyViewModel>())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Survey App',
        theme: ThemeData(
          // Set the overall background color of the app
          scaffoldBackgroundColor: Colors.grey[100],
          // Set the default color for Card widgets
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          // Customize other theme properties as needed
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        home: Provider.of<AuthViewModel>(context).isSignIn
            ? HomeView()
            : SignInView());
  }
}
