import 'package:rick_morty_flutter_app/app/app.dart';
import 'package:rick_morty_flutter_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
