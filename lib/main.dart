import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './spice.dart';
import './new_spice.dart';
import './theme.dart';
import 'data/repository.dart';
import 'data/sqlite/sqlite_repository.dart';
import 'models/models.dart';
import 'models/profile_manager.dart';
import 'models/spice_manager.dart';
import 'screens/screen_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = SqliteRepository();
  await repository.init();
  runApp(JalapenoSpices(repository: repository));
}

class JalapenoSpices extends StatelessWidget {
  final Repository repository;
  JalapenoSpices({Key? key, required this.repository}) : super(key: key);

  final _profileManager = ProfileManager();
  final _spiceManager = SpiceManager();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Repository>(
          lazy: false,
          create: (_) => repository,
          dispose: (_, Repository repository) => repository.close(),
        ),
        ChangeNotifierProvider(create: (context) => _profileManager),
        ChangeNotifierProvider(create: (context) => _spiceManager),
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = JalapenoSpiceTheme.dark();
          } else {
            theme = JalapenoSpiceTheme.light();
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Jalapeño Spices',
            theme: theme,
            home: const ScreenManager(),
          );
        }
      ),
    );
  }
}
