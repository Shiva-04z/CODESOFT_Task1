import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_list/features/home_page/home_page_bindings.dart';
import 'package:to_do_list/features/splash_screen/splash_screen_bindings.dart';
import 'package:to_do_list/navigation/get_pages_constant.dart';
import 'package:to_do_list/navigation/routes_constant.dart';

import 'models/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);

    if (!Hive.isAdapterRegistered(TaskAdapter().typeId)) {
      Hive.registerAdapter(TaskAdapter());
    }

    await Hive.openBox<Task>('tasks');

    runApp(const MyApp());
  } catch (e, stack) {
    debugPrint('Initialization error: $e\n$stack');

    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'App failed to start. Please try again.',
            style: TextStyle(color: Colors.red, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

      ),
      initialRoute: RoutesConstant.splashPage,
      initialBinding: SplashScreenBindings(),
      getPages: getPages,

    );
  }
}

