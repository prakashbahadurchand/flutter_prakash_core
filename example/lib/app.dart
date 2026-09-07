import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/auth_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final appEnv = getIt<AppEnv>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
        BlocProvider(create: (_) => getIt<AdsCubit>()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
      ],
      child: BlocSelector<ThemeCubit, ThemeMode, ThemeMode>(
        selector: (state) => state,
        builder: (context, themeMode) {
          return BlocSelector<LocaleCubit, Locale, Locale>(
            selector: (state) => state,
            builder: (context, locale) {
              return MaterialApp.router(
                title: appEnv.appName,
                scaffoldMessengerKey: Toast.scaffoldMessengerKey,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                routerConfig: _appRouter.config(),
                builder: (context, child) {
                  return DevtoolsFloatingDock(
                    enabled: appEnv.isDev,
                    navigatorKey: _appRouter.navigatorKey,
                    child: child ?? const SizedBox.shrink(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
