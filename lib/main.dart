import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/common/models/user_model.dart';
import 'package:todo_app/common/routes/routes.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/features/auth/controllers/user_provider.dart';
import 'package:todo_app/features/onboarding/pages/onboarding.dart';
import 'package:todo_app/features/todo/pages/homepage.dart';
import 'package:todo_app/firebase_options.dart';

//com.googleusercontent.apps.268559559034-3rstd5g492h7c1c51i36fi2hb6akss75
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  static final defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);
  static final defaultDarkColorScheme = ColorScheme.fromSwatch(
      brightness: Brightness.dark, primarySwatch: Colors.blue);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userProvider.notifier).refresh();
    List<UserModel> users = ref.watch(userProvider);
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 825),
        minTextAdapt: true,
        builder: (context, child) {
          return DynamicColorBuilder(
              builder: (lightColorScheme, darkColorScheme) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Todo App',
              theme: ThemeData(
                scaffoldBackgroundColor: const Color.fromARGB(255, 46, 42, 46),
                colorScheme: lightColorScheme ?? defaultDarkColorScheme,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                  colorScheme: darkColorScheme ?? defaultDarkColorScheme,
                  scaffoldBackgroundColor: AppConst.kBkDark,
                  useMaterial3: true),
              themeMode: ThemeMode.dark,
              home: const HomePage(),
              onGenerateRoute: Routes.onGenerateRoute,
            );
          });
        });
  }
}
