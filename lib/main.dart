import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapfeature_project/Test/firstscreen.dart';
import 'package:mapfeature_project/models/music.dart';
import 'package:mapfeature_project/screens/OTP_Screen.dart';
import 'package:mapfeature_project/screens/QuotesCategoryScreen.dart';
import 'package:mapfeature_project/screens/activities.dart';
import 'package:mapfeature_project/screens/moviesscreen.dart';
import 'package:mapfeature_project/screens/musicScreen.dart';
import 'package:mapfeature_project/screens/soothe_screen.dart';
import 'package:mapfeature_project/NavigationBar.dart';
import 'package:mapfeature_project/moodTracer/sentiment.dart';
import 'package:mapfeature_project/screens/ChatScreen.dart';
import 'package:mapfeature_project/screens/LogInScreen.dart';
import 'package:mapfeature_project/screens/SignUpScreen.dart';
import 'package:mapfeature_project/Todo/todo.dart';
import 'package:mapfeature_project/views/music_list.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

int userScore = 0;
int cognitiveScore = 0;
int somaticScore = 0;
late Box<Map<String, dynamic>> _messagesBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final String? token;
  final String? email;
  final String? userId;
  final String? userName;

  const MyApp({Key? key, this.token, this.userId, this.userName, this.email}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<SentimentRecording> moodRecordings = [];
  late List<Music> playlist;

  @override
  void initState() {
    playlist = [
      Music(trackId: '7MXVkk9YMctZqd1Srtv4MB'), // Add more songs here
      Music(trackId: '3WOiSsqfXPZAtGTr2PFj6S'),
      Music(trackId: '11dFghVXANMlKmJXsNCbNl'),
      Music(trackId: '2vknxlulbj1JApedTlmrZv'),
      Music(trackId: '6GkrhEQYOpCurp8gJWz91H'),
      Music(trackId: '4HXRJ3Bz49FEDeEOfdtUJO'),
      Music(trackId: '5LtHZB7vU02HtNoOzNcVhc'),
      Music(trackId: '5rCq30EbJ3DfZPKybGZj8F'),
      Music(trackId: '7qLXBcYW78is9LygQBziAU'),
      Music(trackId: '0ECT1q8mtxBE7cCRIeCXO2'),
      Music(trackId: '1ZuHXbFUhAb3SHOn4TzQbW'),
      Music(trackId: '00TO3hVgOAgfKrRjrKEZxx'),
    ];

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(playlist: playlist),
      routes: {
        'login': (context) => const LogInScreen(),
        'signup': (context) => const SignUpScreen(),
        'otp_screen': (context) {
          final userId = ModalRoute.of(context)!.settings.arguments as String?;
          return OtpScreen(userId: userId);
        },
        'chat': (context) => ChatBot(
          userId: widget.userId ?? "",
          userName: widget.userName ?? "",
        ),
        'test': (context) => const testScreen(),
        'QCategory': (context) => QuotesCategoryScreen(),
        'sothee': (context) => const sotheeScreen(),
        'movies': (context) => MoviesScreen(),
        'music': (context) =>  const musicScreen(),
        'recommendation': (context) => RecommendationsScreen(playlist: playlist),
        'Todo': (context) => HomePage(),
        'navigator': (context) => NavigationTabs(
          userId: widget.userId,
          moodRecordings: moodRecordings,
          onMoodSelected: (moodRecording) {
            setState(() {
              moodRecordings.add(moodRecording);
            });
          },
          selectedMoodPercentage: 0.0,
          token: widget.token ?? '',
          email: widget.email ?? "",
          name: widget.userName ?? "",
            ),
      },
      initialRoute: 'sothee',
    );
  }
}