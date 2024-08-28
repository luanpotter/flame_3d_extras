import 'package:example/playground_game.dart';
import 'package:flame/game.dart' show GameWidget;
import 'package:flutter/widgets.dart';

void main() async {
  runApp(const PlaygroundApp());
}

class PlaygroundApp extends StatefulWidget {
  const PlaygroundApp({super.key});

  @override
  State<PlaygroundApp> createState() => _PlaygroundAppState();
}

class _PlaygroundAppState extends State<PlaygroundApp>
    with WidgetsBindingObserver {
  final game = PlaygroundGame();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      return;
    }

    if (!game.isPaused) {
      game.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: game);
  }
}
