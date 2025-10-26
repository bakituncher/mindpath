import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindpath/firebase_options.dart';
import 'package:mindpath/core/theme/app_theme.dart';
import 'package:mindpath/core/constants/app_strings.dart';
import 'package:mindpath/screens/onboarding/welcome_screen.dart';
import 'package:mindpath/screens/home/main_navigation.dart';
import 'package:mindpath/screens/courses/course_detail_screen.dart';
import 'package:mindpath/screens/courses/lesson_player_screen.dart';
import 'package:mindpath/screens/sleep/sleep_player_screen.dart';
import 'package:mindpath/models/course_model.dart';
import 'package:mindpath/models/sleep_story_model.dart';
import 'package:mindpath/services/auth_service.dart';
import 'package:mindpath/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );

  // Initialize Notifications
  await NotificationService().initialize();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MindPathApp());
}

class MindPathApp extends StatelessWidget {
  const MindPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const AuthWrapper(),
      onGenerateRoute: (settings) {
        // Course Detail Route
        if (settings.name == '/course-detail') {
          final course = settings.arguments as CourseModel;
          return MaterialPageRoute(
            builder: (context) => CourseDetailScreen(course: course),
          );
        }

        // Lesson Player Route
        if (settings.name == '/lesson-player') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => LessonPlayerScreen(
              lesson: args['lesson'] as LessonModel,
              courseId: args['courseId'] as String,
              color: args['color'] as Color,
            ),
          );
        }

        // Sleep Player Route
        if (settings.name == '/sleep-player') {
          final story = settings.arguments as SleepStoryModel;
          return MaterialPageRoute(
            builder: (context) => SleepPlayerScreen(story: story),
          );
        }

        return null;
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          return const MainNavigation();
        }

        return const WelcomeScreen();
      },
    );
  }
}

