import 'package:flutter/material.dart';

import 'flutter_fancy_tree_view.dart';
import 'path_drawing.dart';
import 'minimal_tree_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tree View',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const _AppHome(),
    );
  }
}

class _AppHome extends StatelessWidget {
  const _AppHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minimal Tree View')),
      body: DefaultIndentGuide(
        guide: IndentGuide.connectingLines(
          indent: 30,
          color: Theme.of(context).colorScheme.outline,
          thickness: 1,
          origin: 0.70,
          strokeCap: StrokeCap.round,
          pathModifier: _dottedPathModifier,
        ),
        child: const MinimalTreeView(),
      ),
    );
  }
}

Path _dottedPathModifier(Path path) {
  return dashPath(
    path,
    dashArray: CircularIntervalList(const [0.5, 3.5]),
    dashOffset: const DashOffset.absolute(0.5 * 3.5),
  );
}
