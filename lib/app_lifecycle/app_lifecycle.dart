import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class AppLifeCycleObserver extends StatefulWidget {
  final Widget child;
  const AppLifeCycleObserver({required this.child, Key? key}) : super(key: key);

  @override
  State<AppLifeCycleObserver> createState() => _AppLifeCycleObserverState();
}

class _AppLifeCycleObserverState extends State<AppLifeCycleObserver>
    with WidgetsBindingObserver {
  static final _log = Logger('AppLifecycleObserver');

  final ValueNotifier<AppLifecycleState> lifecycleListenable =
      ValueNotifier(AppLifecycleState.inactive);
  @override
  Widget build(BuildContext context) {
    return InheritedProvider<ValueNotifier<AppLifecycleState>>.value(
        value: lifecycleListenable, child: widget.child);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    _log.info(() => 'didChangeAppLifecycleState: $state');
    super.didChangeAppLifecycleState(state);
    lifecycleListenable.value = state;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _log.info('Subscribed to app lifecycle updates');
  }
}
