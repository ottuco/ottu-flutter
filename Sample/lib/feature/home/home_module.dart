import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ottu_flutter_checkout_sample/api/model/ottu_api_impl.dart';
import 'package:ottu_flutter_checkout_sample/api/ottu_api.dart';
import 'package:ottu_flutter_checkout_sample/di/Module.dart';
import 'package:ottu_flutter_checkout_sample/feature/home/home_screen.dart';
import 'package:ottu_flutter_checkout_sample/feature/home/home_screen_cubit.dart';
import 'package:ottu_flutter_checkout_sample/main.dart' show ThemeModeNotifierHolder;
import 'package:provider/provider.dart';

final class HomeModule implements Module {

  late final GetIt _service;

  @override
  void init(GetIt service) {
    this._service = service;
    service.registerSingleton<OttuApi>(OttuApiImpl());
  }

  @override
  List<RouteBase> router() {
    return [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            BlocProvider(
              create: (_) =>
                  HomeScreenCubit(
                      navigator: GoRouter.of(context),
                      themeModeNotifier: context.watch<ThemeModeNotifierHolder>(),
                      api: _service<OttuApi>()
                  ),
              child: const HomeScreen(),
            ),
      ),
    ];
  }
}
