import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aitek/common/widget/set_canonical_url_widget.dart';
import 'package:aitek/feature/authentication/presentation/screen/login_screen.dart';
import 'package:aitek/feature/dashboard/presentation/dashboard_screen.dart';
import 'package:aitek/feature/profile/presentation/screens/profile_screen.dart';import 'package:aitek/helper/custom_page.dart';
import 'package:aitek/util/app_constants.dart';


class RouteHelper {
  static const String initial = '/';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';


  static getInitialRoute() => initial;
static getSignInRoute() => signIn;
  static getDashboardRoute() => dashboard;
  static getProfileRoute() => profile;


  static List<GetPage> routes = [
    customPage(name: initial, page: () => const LoginScreen(),
      arguments: SeoData(title: 'Welcome to ${AppConstants.appName}',
        description: '${AppConstants.appName} is an all-in-one LMS system for modern education.'),
    ),
    customPage(name: signIn, page: () => const LoginScreen(),
      arguments: SeoData(title: 'Sign In - ${AppConstants.appName}',
        description: 'Access your ${AppConstants.appName} account securely.'),
    ),
    customPage(name: dashboard, page: () => const DashboardScreen(),
      arguments: SeoData(title: 'Dashboard - ${AppConstants.appName}',
        description: 'Your dashboard overview in ${AppConstants.appName}.'),
    ),

    customPage(name: profile, page: () => const ProfileScreen()),


  ];

  static getRoute(Widget navigateTo) {
    return  navigateTo;
  }


}





