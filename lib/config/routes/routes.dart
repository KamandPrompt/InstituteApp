// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import 'package:uhl_link/features/authentication/presentation/pages/choose_auth.dart';
import 'package:uhl_link/features/authentication/presentation/pages/login.dart';
import 'package:uhl_link/features/authentication/presentation/pages/otp_verification_page.dart';
import 'package:uhl_link/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:uhl_link/features/authentication/presentation/pages/update_password.dart';
import 'package:uhl_link/features/home/presentation/pages/job_portal.dart';
import 'package:uhl_link/features/home/presentation/pages/home.dart';
import 'package:uhl_link/features/home/presentation/widgets/PORs_page.dart';
import 'package:uhl_link/features/home/presentation/widgets/academic_calendar_page.dart';
import 'package:uhl_link/features/home/presentation/widgets/achievements_page.dart';
import 'package:uhl_link/features/home/presentation/widgets/campus_map_page.dart';
import 'package:uhl_link/features/home/presentation/widgets/job_details_page.dart';
import 'package:uhl_link/features/home/presentation/widgets/lost_found_add_item_page.dart';
import 'package:uhl_link/features/home/presentation/widgets/lost_found_page.dart';
import 'package:uhl_link/features/home/presentation/widgets/mess_menu_page.dart';
import 'package:uhl_link/features/home/presentation/widgets/quick_links_page.dart';
import 'package:uhl_link/features/home/presentation/widgets/settings_page.dart';
import 'package:uhl_link/features/home/presentation/widgets/notifications_page.dart';
import 'package:uhl_link/widgets/splash_screen.dart';
import 'package:uhl_link/widgets/test.dart';

class UhlLinkRouter {
  GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          name: UhlLinkRoutesNames.splash,
          path: '/',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: const SplashScreen());
          }),
      GoRoute(
          name: UhlLinkRoutesNames.chooseAuth,
          path: '/chooseAuth',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: const ChooseAuthPage());
          }),
      GoRoute(
          name: UhlLinkRoutesNames.login,
          path: '/login',
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: const LoginPage());
          }),
      GoRoute(
          name: UhlLinkRoutesNames.signup,
          path: '/signup',
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: const SignUpPage());
          }),
      GoRoute(
          name: UhlLinkRoutesNames.otpVerify,
          path: '/otpVerify/:user/:otp',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey,
                child: OtpVerificationPage(
                    user: jsonDecode(state.pathParameters['user']!),
                    otp: jsonDecode(state.pathParameters['otp']!)));
          }),
      //
      GoRoute(
          name: UhlLinkRoutesNames.home,
          path: '/home/:isGuest/:user',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey,
                child: HomePage(
                  isGuest: jsonDecode(state.pathParameters['isGuest']!),
                  user: jsonDecode(state.pathParameters['user']!),
                ));
          }),
      // Explore
      GoRoute(
          name: UhlLinkRoutesNames.messMenuPage,
          path: '/mess_menu',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: const MessMenuPage());
          }),
      GoRoute(
          name: UhlLinkRoutesNames.campusMapPage,
          path: '/campus_map',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: const CampusMapPage());
          }),
      GoRoute(
          name: UhlLinkRoutesNames.quickLinksPage,
          path: '/quick_links',
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: QuickLinksPage());
          }),
      GoRoute(
          name: UhlLinkRoutesNames.lostFoundPage,
          path: '/lost_found/:isGuest/:user',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey,
                child: LostFoundPage(
                  isGuest: jsonDecode(state.pathParameters['isGuest']!),
                  user: jsonDecode(state.pathParameters['user']!),
                ));
          }),
      GoRoute(
          name: UhlLinkRoutesNames.lostFoundAddItemPage,
          path: '/lost_found_add_item/:user',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey,
                child: LostFoundAddItemPage(
                  user: jsonDecode(state.pathParameters['user']!),
                ));
          }),

      // Academics
      GoRoute(
          name: UhlLinkRoutesNames.academicCalenderPage,
          path: '/academic_calender',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child:  const AcademicCalendarPage());
          }),
      GoRoute(
          name: UhlLinkRoutesNames.jobPortalPage,
          path: '/job_portal',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: const JobPortalPage());
          }),
      GoRoute(
          name: UhlLinkRoutesNames.achievementsPage,
          path: '/achievements',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: const AchievementsPage());
          }),

      // Profile
      GoRoute(
          name: UhlLinkRoutesNames.updatePassword,
          path: '/updatePassword/:user',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey,
                child: UpdatePasswordPage(
                    user: jsonDecode(state.pathParameters['user']!)));
          }),
      GoRoute(
          name: UhlLinkRoutesNames.porsPage,
          path: '/pors_page',
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: const PorsPage());
          }),
      GoRoute(
          name: UhlLinkRoutesNames.settingsPage,
          path: '/settings',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: const SettingsPage());
          }),

      GoRoute(
          name: UhlLinkRoutesNames.jobDetailsPage,
          path: '/job_details/:job',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey,
                child: JobDetailsPage(
                    job: jsonDecode(state.pathParameters["job"]!)));
          }),
      GoRoute(
          name: UhlLinkRoutesNames.notifications,
          path: '/notifications/:isGuest',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey,
                child: Notifications(
                    isGuest: jsonDecode(state.pathParameters["isGuest"]!)));
          }),

      GoRoute(
          name: UhlLinkRoutesNames.test,
          path: '/test',
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: const TestScreen());
          }),
    ],
    // redirect: (BuildContext context, GoRouterState state) async {
    //   const storage = FlutterSecureStorage();
    //   final token = await storage.read(key: 'user');
    //
    //   if (token == null) {
    //     if (state.matchedLocation != '/chooseAuth') {
    //       return '/chooseAuth';
    //     }
    //   }
    //   else if (state.matchedLocation == '/chooseAuth') {
    //     final user = jsonDecode(token);
    //     return '/home/false/$user';
    //   }
    //
    //   return null; // Allow navigation if conditions are met
    // }
  );
}
