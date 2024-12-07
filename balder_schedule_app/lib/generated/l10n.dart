// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Schedule`
  String get scheduleTitle {
    return Intl.message(
      'Schedule',
      name: 'scheduleTitle',
      desc: '',
      args: [],
    );
  }

  /// `Schedule editor`
  String get editTitle {
    return Intl.message(
      'Schedule editor',
      name: 'editTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message(
      'Settings',
      name: 'settingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearanceTitle {
    return Intl.message(
      'Appearance',
      name: 'appearanceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationsTitle {
    return Intl.message(
      'Notifications',
      name: 'notificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `QR`
  String get qrTitle {
    return Intl.message(
      'QR',
      name: 'qrTitle',
      desc: '',
      args: [],
    );
  }

  /// `Light theme`
  String get appearanceScreenThemeLight {
    return Intl.message(
      'Light theme',
      name: 'appearanceScreenThemeLight',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme`
  String get appearanceScreenThemeDark {
    return Intl.message(
      'Dark theme',
      name: 'appearanceScreenThemeDark',
      desc: '',
      args: [],
    );
  }

  /// `app language`
  String get applanguageTitle {
    return Intl.message(
      'app language',
      name: 'applanguageTitle',
      desc: '',
      args: [],
    );
  }

  /// `en`
  String get ru_enTitle {
    return Intl.message(
      'en',
      name: 'ru_enTitle',
      desc: '',
      args: [],
    );
  }

  /// `Shedule for tomorrow`
  String get shedule_tomorrowTitle {
    return Intl.message(
      'Shedule for tomorrow',
      name: 'shedule_tomorrowTitle',
      desc: '',
      args: [],
    );
  }

  /// `Scan new schedule`
  String get scanNewScheduleTitle {
    return Intl.message(
      'Scan new schedule',
      name: 'scanNewScheduleTitle',
      desc: '',
      args: [],
    );
  }

  /// `Share schedule`
  String get shareScheduleTitle {
    return Intl.message(
      'Share schedule',
      name: 'shareScheduleTitle',
      desc: '',
      args: [],
    );
  }

  /// `The parity of the week`
  String get settingsHonesty {
    return Intl.message(
      'The parity of the week',
      name: 'settingsHonesty',
      desc: '',
      args: [],
    );
  }

  /// `Add a lesson`
  String get lessonCreateScreenTitle {
    return Intl.message(
      'Add a lesson',
      name: 'lessonCreateScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit a lesson`
  String get lessonEditScreenTitle {
    return Intl.message(
      'Edit a lesson',
      name: 'lessonEditScreenTitle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
