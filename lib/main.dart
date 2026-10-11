import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:refer_app/features/cart/bloc/pickup_time_bloc.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import 'core/theme.dart';
import 'core/env.dart';
import 'core/widgets/app_snackbar.dart';
import 'core/di.dart';
import 'core/router.dart';
import 'core/network/server_health.dart';
import 'core/bloc/locale_cubit.dart';
import 'features/cart/bloc/cart_bloc.dart';
import 'features/home/bloc/home_bloc.dart';
import 'features/cart/bloc/locations_bloc.dart';
import 'core/services/stripe_service.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // .env solo dev (no empaquetado); en release todo viene de --dart-define.
  await AppEnv.load();
  await StripeService.init();
  initDI();
  await LiquidGlassWidgets.initialize();
  runApp(LiquidGlassWidgets.wrap(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    ServerHealth.isDown.addListener(_goToMaintenance);
  }

  @override
  void dispose() {
    ServerHealth.isDown.removeListener(_goToMaintenance);
    super.dispose();
  }

  /// Si el servidor se cae en cualquier momento (cualquier request),
  /// mostrar la vista de mantenimiento.
  void _goToMaintenance() {
    if (!ServerHealth.isDown.value) return;
    final location = router.state.matchedLocation;
    // Splash (/) ya redirige solo vía SplashError; no duplicar.
    if (location == '/maintenance' || location == '/') return;
    router.go('/maintenance');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<LocaleCubit>()),
        BlocProvider.value(value: sl<CartBloc>()),
        BlocProvider.value(value: sl<HomeBloc>()),
        BlocProvider.value(value: sl<LocationsBloc>()),
        BlocProvider(create: (context) => sl<PickupTimeBloc>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: 'Artisan Espresso',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            scaffoldMessengerKey: AppSnackBar.messengerKey,
            routerConfig: router,
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
