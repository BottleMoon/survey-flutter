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
        home: Provider.of<AuthViewModel>(context).isSignIn
            ? HomeView()
            : SignInView());
  }
}
