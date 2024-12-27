import 'package:aio/aio.dart';

import 'app/app_root.dart';
import 'app/constants/routes.dart';

void main() {
  App().run(
    const AppRoot(),
    dependencies: [
      InitializableDependency(Prefs()),
      InitializableDependency.withOptions(AppRouter(), appRoutes),
    ],
    // appLifeCycleHandler: AppLifeCycleHandler(
    //   onPaused: () => print("App paused"),
    //   onResumed: () => print("App resumed"),
    // ),
    // useAppSession: true,
    // debug: true,
  );
}
