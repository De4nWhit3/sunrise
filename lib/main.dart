import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunrise/services/ThemeService.dart';
import 'package:sunrise/widgets/moon.dart';
import 'package:sunrise/widgets/star.dart';
import 'package:sunrise/widgets/sun.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeService(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          themeMode:
              themeService.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class AppTheme {
  AppTheme._();

  static const _darkColor = Colors.blue;
  static const _lightColor = Colors.pink;

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _lightColor,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _darkColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello world'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeService>(context, listen: false)
                  .toggleDarkMode();
            },
            icon: const Icon(Icons.star),
          ),
        ],
      ),
      body: Consumer<ThemeService>(
        builder: ((context, themeService, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: themeService.isDarkModeOn
                          ? [
                              Colors.blue,
                              Colors.purple,
                            ]
                          : [
                              Colors.yellow,
                              Colors.pink,
                            ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Stack(children: [
                    Positioned(
                      top: 100,
                      right: 200,
                      child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: themeService.isDarkModeOn ? 1 : 0,
                          child: const Star()),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      top: themeService.isDarkModeOn ? 100 : 130,
                      right: themeService.isDarkModeOn ? 100 : -40,
                      child: AnimatedOpacity(
                        opacity: themeService.isDarkModeOn ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: const Moon(),
                      ),
                    ),
                    AnimatedPadding(
                        padding: EdgeInsets.only(
                            top: themeService.isDarkModeOn ? 110 : 50),
                        duration: const Duration(milliseconds: 200),
                        child: const Sun()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 225,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 0, 204, 255),
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 30, 13, 124),
                              blurRadius: 15,
                              spreadRadius: 5,
                            )
                          ],
                          color: themeService.isDarkModeOn
                              ? Colors.black
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Switch(
                                value: themeService.isDarkModeOn,
                                onChanged: (value) {
                                  themeService.toggleDarkMode();
                                }),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
