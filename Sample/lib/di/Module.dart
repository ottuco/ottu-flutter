import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart' show RouteBase;

abstract class Module {
  void init(GetIt service);

  List<RouteBase> router();
}
