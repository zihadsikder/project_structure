import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:gat/routes/app_routes.dart';
import 'package:get/get.dart';
import 'core/bindings/controller_binder.dart';
import '../../../../core/utils/constants/app_sizer.dart';

import 'core/utils/theme/theme.dart';


class PlatformUtils {
  static bool get isIOS =>
      foundation.defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isAndroid =>
      foundation.defaultTargetPlatform == TargetPlatform.android;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Initialize LanguageController
    //final languageController = Get.put(LanguageController());

    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoute.init,
          //initialRoute: AppRoute.navBar,
          getPages: AppRoute.routes,
          initialBinding: ControllerBinder(),
          themeMode: ThemeMode.system,
          theme: _getLightTheme(),
          darkTheme: _getDarkTheme(),
          defaultTransition:
              PlatformUtils.isIOS ? Transition.cupertino : Transition.fade,
          locale: Get.deviceLocale,
          builder: (context, child) => PlatformUtils.isIOS
              ? CupertinoTheme(data: const CupertinoThemeData(), child: child!)
              : child!,
          /// Builder wraps widgets with text direction
          // builder: (context, child) {
          //   final textDirection = TextDirection.ltr; // Spanish is LTR
          //   return Directionality(
          //     textDirection: textDirection,
          //     child:
          //     PlatformUtils.isIOS
          //         ? CupertinoTheme(
          //       data: CupertinoThemeData(
          //         textTheme: CupertinoTextThemeData(
          //           textStyle: GoogleFonts.(),
          //         ),
          //       ),
          //       child: child!,
          //     )
          //         : child!,
          //   );
          // },

          // translations: AppTranslations(),
          // locale: Locale(controller.selectedLanguage.value),
          // fallbackLocale: const Locale('en', 'US'),
          //
          // localizationsDelegates: const [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   GlobalCupertinoLocalizations.delegate,
          // ],
          //
          // supportedLocales: const [
          //   Locale('en', 'US'), // English
          //   Locale('es', 'ES'), // Spanish
          // ],
          //
          //
          // localeResolutionCallback: (locale, supportedLocales) {
          //   final selectedLang = controller.selectedLanguage.value;
          //   log('Resolving locale: device=$locale, selected=$selectedLang');
          //   return Locale(selectedLang);
          // },
        );
      },
    );
  }

  ThemeData _getLightTheme() {
    return PlatformUtils.isIOS
        ? AppTheme.lightTheme.copyWith(platform: TargetPlatform.iOS)
        : AppTheme.lightTheme;
  }

  ThemeData _getDarkTheme() {
    return PlatformUtils.isIOS
        ? AppTheme.darkTheme.copyWith(platform: TargetPlatform.iOS)
        : AppTheme.darkTheme;
  }
}
