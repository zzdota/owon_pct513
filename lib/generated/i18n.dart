import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
class S implements WidgetsLocalizations {
  const S();

  static S current;

  static const GeneratedLocalizationsDelegate delegate =
    GeneratedLocalizationsDelegate();

  static S of(BuildContext context) => Localizations.of<S>(context, S);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get about_version => "Version";
  String get app_listView => "ListView";
  String get app_name => "OWON";
  String get app_test => "test";
  String get app_title => "app title";
  String get appearance_dark => "Dark";
  String get appearance_light => "Light";
  String get global_cancel => "Cancel";
  String get global_delete => "Remove";
  String get global_get_verify_code => "Get Code";
  String get global_hint_confirm_password => "Confirm Password";
  String get global_hint_new_password => "New Password";
  String get global_hint_password => "Password";
  String get global_hint_user => "E-Mail / Phone";
  String get global_hint_verify_code => "Verification Code";
  String get global_ok => "OK";
  String get global_register => "Register";
  String get global_thermostat => "Thermostat";
  String get global_verify_code_remaining1 => "";
  String get global_verify_code_remaining2 => " seconds left";
  String get list_disconnect => "Disconnected";
  String get login_button => "Login";
  String get login_forgot => "Forgot";
  String get login_hi => "Hi,";
  String get login_password_less_six_digits => "Password must be no less than 6 digits";
  String get login_privacy1 => "By signing in or registering, you are agreeing to the ";
  String get login_privacy2 => "Privacy Policy";
  String get login_username_null => "Please enter username";
  String get login_welcome => "Welcome";
  String get reset_psw_confirm => "Confirm";
  String get reset_psw_password => "Password";
  String get reset_psw_reset => "Reset";
  String get reset_psw_title => "Reset Password";
  String get set_about => "About";
  String get set_appearance => "Appearance";
  String get set_dig => "Electric Fence";
  String get set_exit => "Log out";
  String get set_help => "Help";
  String get set_resetPsw => "Reset Password";
  String get tab_list => "Thermostat List";
  String get tab_set => "Setting";
}

class $en extends S {
  const $en();
}

class $zh extends S {
  const $zh();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get login_privacy1 => "登录或注册即代表阅读并同意";
  @override
  String get list_disconnect => "连接断开";
  @override
  String get set_exit => "退出登录";
  @override
  String get login_button => "登录";
  @override
  String get login_hi => "Hi,";
  @override
  String get global_verify_code_remaining1 => "剩余";
  @override
  String get global_hint_password => "密码";
  @override
  String get login_password_less_six_digits => "密码不得小于6位";
  @override
  String get global_verify_code_remaining2 => " 秒";
  @override
  String get reset_psw_reset => "重置";
  @override
  String get about_version => "版本号";
  @override
  String get reset_psw_confirm => "确认修改";
  @override
  String get set_resetPsw => "重置密码";
  @override
  String get global_cancel => "取消";
  @override
  String get tab_set => "设置";
  @override
  String get global_thermostat => "温控器";
  @override
  String get global_get_verify_code => "校验码";
  @override
  String get app_listView => "ListView";
  @override
  String get appearance_dark => "深色";
  @override
  String get set_help => "帮助";
  @override
  String get tab_list => "温控器列表";
  @override
  String get app_title => "app title";
  @override
  String get global_ok => "确认";
  @override
  String get set_appearance => "主题";
  @override
  String get reset_psw_title => "重置密码";
  @override
  String get app_test => "test";
  @override
  String get global_hint_confirm_password => "再次确认密码";
  @override
  String get login_welcome => "Welcome";
  @override
  String get global_hint_verify_code => "输入校验码";
  @override
  String get reset_psw_password => "密码";
  @override
  String get set_dig => "电子围栏";
  @override
  String get app_name => "OWON";
  @override
  String get global_register => "注册账号";
  @override
  String get login_username_null => "请输入用户名";
  @override
  String get appearance_light => "浅色";
  @override
  String get login_forgot => "忘记密码";
  @override
  String get global_delete => "删除";
  @override
  String get set_about => "关于";
  @override
  String get global_hint_new_password => "输入新密码";
  @override
  String get global_hint_user => "电子邮件/手机号码";
  @override
  String get login_privacy2 => "隐私条例";
}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en", ""),
      Locale("zh", ""),
    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback, bool withCountry = true}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported, withCountry);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback, bool withCountry = true}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported, withCountry);
    };
  }

  @override
  Future<S> load(Locale locale) {
    final String lang = getLang(locale);
    if (lang != null) {
      switch (lang) {
        case "en":
          S.current = const $en();
          return SynchronousFuture<S>(S.current);
        case "zh":
          S.current = const $zh();
          return SynchronousFuture<S>(S.current);
        default:
          // NO-OP.
      }
    }
    S.current = const S();
    return SynchronousFuture<S>(S.current);
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale, true);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;

  ///
  /// Internal method to resolve a locale from a list of locales.
  ///
  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported, bool withCountry) {
    if (locale == null || !_isSupported(locale, withCountry)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  ///
  /// Returns true if the specified locale is supported, false otherwise.
  ///
  bool _isSupported(Locale locale, bool withCountry) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        // Language must always match both locales.
        if (supportedLocale.languageCode != locale.languageCode) {
          continue;
        }

        // If country code matches, return this locale.
        if (supportedLocale.countryCode == locale.countryCode) {
          return true;
        }

        // If no country requirement is requested, check if this locale has no country.
        if (true != withCountry && (supportedLocale.countryCode == null || supportedLocale.countryCode.isEmpty)) {
          return true;
        }
      }
    }
    return false;
  }
}

String getLang(Locale l) => l == null
  ? null
  : l.countryCode != null && l.countryCode.isEmpty
    ? l.languageCode
    : l.toString();
