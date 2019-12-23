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
  String get change_psw_change => "Change";
  String get change_psw_enter_old_psw_null => "Please enter your old password";
  String get change_psw_fail => "Change password failed";
  String get change_psw_old_psw => "Old Password";
  String get change_psw_old_psw_error => "Incorrect Current password";
  String get change_psw_success => "Password changed successfully";
  String get change_psw_title => "Change Password";
  String get dSet_device_info => "Device Info";
  String get dSet_device_setting => "Device Setting";
  String get dSet_fan_set => "风扇运行时间闸";
  String get dSet_rename => "Device Rename";
  String get dSet_rename_tip => "Please enter device name";
  String get dSet_sensor => "Sensor Setting";
  String get dSet_temp => "温度单位选择";
  String get dSet_temp_unit => "温度单位";
  String get dSet_vacation => "Vacation Setting";
  String get device_fan_time => "需要运行的风扇最小运行时间:(min/h)";
  String get device_max => "100 min/h";
  String get device_min => "0 min/h";
  String get device_unit => "min/h";
  String get global_account_exist => "Account has been registered";
  String get global_cancel => "Cancel";
  String get global_delete => "Remove";
  String get global_enter_psw_not_match => "New Password and Confirmed Password do not match";
  String get global_enter_verify_null => "Please enter your verification code";
  String get global_fri => "Fri";
  String get global_get_verify_code => "Get Code";
  String get global_get_verify_code_email_success => "A verification code has been sent to your email";
  String get global_get_verify_code_fail => "Failed to send";
  String get global_get_verify_code_often => "You are trying too often. Please try again later";
  String get global_get_verify_code_phone_num_error => "Phone number error";
  String get global_get_verify_code_phone_success => "A verification code has been sent to your phone";
  String get global_hint_confirm_password => "Confirm Password";
  String get global_hint_new_password => "New Password";
  String get global_hint_password => "Password";
  String get global_hint_user => "E-Mail / Phone";
  String get global_hint_verify_code => "Verification Code";
  String get global_lock_account => "Your account has been locked";
  String get global_mon => "Mon";
  String get global_not_account => "Account does not exist";
  String get global_not_agentid => "Agent does not exist";
  String get global_ok => "OK";
  String get global_password_regex_string => "The password can\\'t contain space and other special characters,the length range is from 6 to 16 characteristics.";
  String get global_psw_retry_limit => "You have reached the maximum number of invalid login attempts";
  String get global_register => "Register";
  String get global_register_account_fail => "Registration failed";
  String get global_register_account_success => "Registration successful";
  String get global_sat => "Sat";
  String get global_save => "Save";
  String get global_save_fail => "Save failed";
  String get global_save_success => "Save successfully";
  String get global_sun => "Sun";
  String get global_thermostat => "Thermostat";
  String get global_thur => "Thur";
  String get global_timeout => "Time out";
  String get global_tues => "Tues";
  String get global_unknown => "Unknow";
  String get global_user_name_regex_string => "The name can only contain (0-9,a-z,A-Z,\"_\",\"@\",\" \"),and can only start with letters or numbers,the length range is from 4 to 15 characteristics.";
  String get global_verify_code_error => "Verification code error";
  String get global_verify_code_remaining1 => "";
  String get global_verify_code_remaining2 => " seconds left";
  String get global_wed => "Wed";
  String get list_disconnect => "Disconnected";
  String get login_button => "Login";
  String get login_fail => "Login failed";
  String get login_forgot => "Forgot";
  String get login_hi => "Hi,";
  String get login_lock_account => "The account has been locked\n Please wait for the account to unlock and try again";
  String get login_no_account => "Account does not exist";
  String get login_no_network => "No network currently";
  String get login_password_less_six_digits => "Password must be no less than 6 digits";
  String get login_privacy1 => "By signing in or registering, you are agreeing to the ";
  String get login_privacy2 => "Privacy Policy";
  String get login_retry_limit => "You have reached the maximum number of invalid login attempts ";
  String get login_retry_time => "minutes.";
  String get login_retry_time_alert => " Account will be locked after attempt";
  String get login_username_null => "Please enter username";
  String get login_welcome => "Welcome";
  String get login_wrong_psw => "Wrong password";
  String get reset_psw_confirm => "Confirm";
  String get reset_psw_fail => "Password reset failed";
  String get reset_psw_password => "Password";
  String get reset_psw_reset => "Reset";
  String get reset_psw_success => "Password reset succeeded";
  String get reset_psw_title => "Reset Password";
  String get schedule_copy_sch => "Copy to other day";
  String get schedule_disabled_tip => "The schedule has been disabled.";
  String get schedule_mode_away => "Away";
  String get schedule_mode_home => "Home";
  String get schedule_mode_sleep => "Sleep";
  String get schedule_mode_wake => "Wake";
  String get schedule_setting_title => "Schedule Settings";
  String get schedule_title => "Schedule";
  String get set_about => "About";
  String get set_appearance => "Appearance";
  String get set_dig => "Electric Fence";
  String get set_exit => "Log out";
  String get set_help => "Help";
  String get set_resetPsw => "Reset Password";
  String get tab_list => "Thermostat List";
  String get tab_set => "Setting";
  String get vacation_delete => "Vacation Delete";
  String get vacation_depart => "Depart";
  String get vacation_noEvent => "You have not created any current or future vacation events";
  String get vacation_return => "Return";
  String get vacation_title => "Vacation List";
}

class $en extends S {
  const $en();
}

class $zh extends S {
  const $zh();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get login_retry_limit => "密码重试次数超出限制";
  @override
  String get login_button => "登录";
  @override
  String get reset_psw_success => "重置密码成功";
  @override
  String get login_hi => "Hi,";
  @override
  String get global_verify_code_remaining1 => "剩余";
  @override
  String get reset_psw_fail => "重置密码失败";
  @override
  String get global_verify_code_remaining2 => " 秒";
  @override
  String get global_get_verify_code_phone_success => "验证码已发送到您的手机，请查收";
  @override
  String get global_register_account_success => "账号注册成功";
  @override
  String get schedule_mode_away => "外出";
  @override
  String get appearance_dark => "深色";
  @override
  String get device_fan_time => "需要运行的风扇最小运行时间:(min/h)";
  @override
  String get global_save_success => "保存成功";
  @override
  String get global_enter_verify_null => "请输入验证码";
  @override
  String get dSet_sensor => "传感器设置";
  @override
  String get login_retry_time_alert => " 次后,账户会被锁定";
  @override
  String get schedule_mode_home => "在家";
  @override
  String get global_hint_verify_code => "输入校验码";
  @override
  String get reset_psw_password => "密码";
  @override
  String get global_register => "注册账号";
  @override
  String get login_no_account => "账号不存在";
  @override
  String get schedule_setting_title => "计划表设置";
  @override
  String get global_hint_new_password => "输入新密码";
  @override
  String get schedule_disabled_tip => "The schedule has been disabled.";
  @override
  String get change_psw_enter_old_psw_null => "请输入您的旧密码";
  @override
  String get global_get_verify_code_fail => "验证码发送失败";
  @override
  String get change_psw_old_psw => "旧密码";
  @override
  String get global_hint_password => "密码";
  @override
  String get global_save => "保存";
  @override
  String get global_cancel => "取消";
  @override
  String get global_fri => "周五";
  @override
  String get global_thermostat => "温控器";
  @override
  String get global_get_verify_code => "校验码";
  @override
  String get global_get_verify_code_phone_num_error => "手机号错误";
  @override
  String get global_lock_account => "账号被锁定";
  @override
  String get login_lock_account => "账号被限制，请联系管理员";
  @override
  String get global_sun => "周日";
  @override
  String get app_title => "app title";
  @override
  String get vacation_delete => "删除假期";
  @override
  String get schedule_mode_wake => "起床";
  @override
  String get global_enter_psw_not_match => "输入密码不一致，请重新输入";
  @override
  String get app_test => "test";
  @override
  String get login_welcome => "Welcome";
  @override
  String get global_wed => "周三";
  @override
  String get device_max => "100 min/h";
  @override
  String get set_dig => "电子围栏";
  @override
  String get app_name => "OWON";
  @override
  String get global_delete => "删除";
  @override
  String get dSet_device_info => "设备信息";
  @override
  String get change_psw_success => "修改密码成功";
  @override
  String get global_not_account => "账号不存在";
  @override
  String get device_min => "0 min/h";
  @override
  String get dSet_rename_tip => "请输入设备名称";
  @override
  String get list_disconnect => "连接断开";
  @override
  String get set_exit => "退出登录";
  @override
  String get global_account_exist => "账号已注册";
  @override
  String get schedule_copy_sch => "拷贝到其他天";
  @override
  String get change_psw_change => "修改";
  @override
  String get login_password_less_six_digits => "密码不得小于6位";
  @override
  String get reset_psw_reset => "重置";
  @override
  String get set_resetPsw => "重置密码";
  @override
  String get login_retry_time => "分钟后才能重试";
  @override
  String get global_register_account_fail => "账号注册失败";
  @override
  String get global_save_fail => "保存失败";
  @override
  String get global_verify_code_error => "验证码错误";
  @override
  String get schedule_title => "计划表";
  @override
  String get global_not_agentid => "代理商不存在";
  @override
  String get global_sat => "周六";
  @override
  String get login_wrong_psw => "密码错误";
  @override
  String get vacation_title => "假期列表";
  @override
  String get set_help => "帮助";
  @override
  String get global_mon => "周一";
  @override
  String get set_appearance => "主题";
  @override
  String get global_hint_confirm_password => "再次确认密码";
  @override
  String get dSet_vacation => "假期设置";
  @override
  String get global_psw_retry_limit => "密码重试次数超出限制";
  @override
  String get vacation_noEvent => "当前还没有任何设置";
  @override
  String get vacation_depart => "离家";
  @override
  String get global_get_verify_code_email_success => "校验码已发送到您的电子邮箱，请查收";
  @override
  String get login_privacy2 => "隐私条例";
  @override
  String get login_privacy1 => "登录或注册即代表阅读并同意";
  @override
  String get vacation_return => "回家";
  @override
  String get global_timeout => "请求超时";
  @override
  String get login_no_network => "当前没有网络";
  @override
  String get device_unit => "min/h";
  @override
  String get dSet_fan_set => "风扇运行时间闸";
  @override
  String get global_password_regex_string => "密码不能包含空格和其他特殊字符，长度请控制在6到16之间";
  @override
  String get about_version => "版本号";
  @override
  String get reset_psw_confirm => "确认修改";
  @override
  String get change_psw_old_psw_error => "请输入正确的原密码";
  @override
  String get tab_set => "设置";
  @override
  String get global_tues => "周二";
  @override
  String get schedule_mode_sleep => "睡觉";
  @override
  String get dSet_device_setting => "设备设置";
  @override
  String get dSet_rename => "设备名称";
  @override
  String get global_user_name_regex_string => "账号只能包含,数字，大小写字母以及下划线,@或空格，并且只能以数字或字母开头，长度请控制在4到15之间";
  @override
  String get app_listView => "ListView";
  @override
  String get dSet_temp => "温度单位选择";
  @override
  String get change_psw_fail => "修改密码失败";
  @override
  String get tab_list => "温控器列表";
  @override
  String get global_ok => "确认";
  @override
  String get dSet_temp_unit => "温度单位";
  @override
  String get reset_psw_title => "重置密码";
  @override
  String get global_get_verify_code_often => "操作过于频繁，请稍后在尝试";
  @override
  String get global_unknown => "未知错误";
  @override
  String get login_username_null => "请输入用户名";
  @override
  String get appearance_light => "浅色";
  @override
  String get login_forgot => "忘记密码";
  @override
  String get set_about => "关于";
  @override
  String get login_fail => "登录失败";
  @override
  String get change_psw_title => "修改密码";
  @override
  String get global_thur => "周四";
  @override
  String get global_hint_user => "电子邮件/手机号码";
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
