// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/features/authentication/presentation/pages/choose_auth.dart';
import 'package:vertex/features/authentication/presentation/pages/login.dart';
import 'package:vertex/features/authentication/presentation/pages/otp_verification_page.dart';
import 'package:vertex/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:vertex/features/authentication/presentation/pages/update_profile.dart';
import 'package:vertex/features/home/domain/entities/buy_sell_item_entity.dart';
import 'package:vertex/features/home/domain/entities/lost_found_item_entity.dart';
import 'package:vertex/features/home/domain/entities/post_entity.dart';
import 'package:vertex/features/home/presentation/widgets/about.dart';
import 'package:vertex/features/home/presentation/pages/job_portal.dart';
import 'package:vertex/features/home/presentation/pages/home.dart';
import 'package:vertex/features/home/presentation/widgets/PORs_page.dart';
import 'package:vertex/features/home/presentation/widgets/academic_calendar_page.dart';
import 'package:vertex/features/home/presentation/widgets/achievements_page.dart';
import 'package:vertex/features/home/presentation/widgets/buy_sell_add_or_edit_item_page.dart';
import 'package:vertex/features/home/presentation/widgets/buy_sell_page.dart';
import 'package:vertex/features/home/presentation/widgets/cafeteria.dart';
import 'package:vertex/features/home/presentation/widgets/campus_map_page.dart';
import 'package:vertex/features/home/presentation/widgets/events_page.dart';
import 'package:vertex/features/home/presentation/widgets/job_details_page.dart';
import 'package:vertex/features/home/presentation/widgets/lost_found_add_or_edit_item_page.dart';
import 'package:vertex/features/home/presentation/widgets/lost_found_page.dart';
import 'package:vertex/features/home/presentation/widgets/mess_menu_page.dart';
import 'package:vertex/features/home/presentation/widgets/notification_details_page.dart';
import 'package:vertex/features/home/presentation/widgets/quick_links_page.dart';
import 'package:vertex/features/home/presentation/widgets/settings_page.dart';
import 'package:vertex/features/home/presentation/widgets/notifications_page.dart';
import 'package:vertex/features/home/presentation/widgets/add_notification_page.dart';
import 'package:vertex/features/home/presentation/widgets/post_add_or_edit_item_page.dart';

import 'package:vertex/widgets/splash_screen.dart';
import 'package:vertex/widgets/test.dart';

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
          path: '/otpVerify',
          pageBuilder: (context, state) {
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child: OtpVerificationPage(
                    user: parameters['user'] as UserEntity,
                    otp: parameters['otp'] as int));
          }),
      //
      GoRoute(
          name: UhlLinkRoutesNames.home,
          path: '/home',
          pageBuilder: (context, state) {
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child: HomePage(
                  isGuest: parameters['isGuest'] as bool,
                  user: parameters['user'] as UserEntity?,
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
          path: '/lost_found',
          pageBuilder: (context, state) {
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child: LostFoundPage(
                  isGuest: parameters['isGuest'] as bool,
                  user: parameters['user'] as UserEntity?,
                ));
          }),
      GoRoute(
          name: UhlLinkRoutesNames.lostFoundAddOrEditItemPage,
          path: '/lost_found_add_item',
          pageBuilder: (context, state) {
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child: LostFoundAddOrEditItemPage(
                  user: parameters['user'] as UserEntity,
                  isEditing: parameters['isEditing'] as bool,
                  lnfItem: parameters['lnfItem'] as LostFoundItemEntity?,
                ));
          }),
      // Events
      GoRoute(
        name: UhlLinkRoutesNames.events,
        path: '/events',
        pageBuilder: (context, state) {
          Map<String, dynamic> parameters = state.extra as Map<String, dynamic>;
          return MaterialPage(
            key: state.pageKey,
            child: EventsPage(
              isGuest: parameters['isGuest'] as bool,
              user: parameters['user'] as UserEntity?,
            ),
          );
        },
      ),
      // Buy & Sell
      GoRoute(
          name: UhlLinkRoutesNames.buySellPage,
          path: '/buy_sell',
          pageBuilder: (context, state) {
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child: BuySellPage(
                  isGuest: parameters['isGuest'] as bool,
                  user: parameters['user'] as UserEntity?,
                ));
          }),
      GoRoute(
          name: UhlLinkRoutesNames.buySellAddOrEditItemPage,
          path: '/buy_sell_add_item',
          pageBuilder: (context, state) {
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child: BuySellAddOrEditItemPage(
                  user: parameters['user'] as UserEntity,
                  isEditing: parameters['isEditing'] as bool,
                  bnsItem: parameters['bnsItem'] as BuySellItemEntity?,
                ));
          }),
      // Post
      GoRoute(
          name: UhlLinkRoutesNames.postAddOrEditItemPage,
          path: '/post_add_or_edit_item',
          pageBuilder: (context, state) {
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child: PostAddOrEditItemPage(
                  user: parameters['user'] as UserEntity,
                  postEditing: parameters['postEditing'] as bool,
                  postDetails: parameters['postDetails'] as PostItemEntity?,
                ));
          }),
      // Academics
      GoRoute(
          name: UhlLinkRoutesNames.academicCalenderPage,
          path: '/academic_calender',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: const AcademicCalendarPage());
          }),
      GoRoute(
          name: UhlLinkRoutesNames.jobPortalPage,
          path: '/job_portal',
          pageBuilder: (context, state) {
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child: JobPortalPage(
                  isGuest: parameters['isGuest'] as bool,
                ));
          }),
      // achievements
      GoRoute(
        name: UhlLinkRoutesNames.achievementsPage,
        path: '/achievements',
        pageBuilder: (context, state) {
          Map<String, dynamic> parameters = state.extra as Map<String, dynamic>;
          return MaterialPage(
            key: state.pageKey,
            child: AchievementsPage(
              isGuest: parameters['isGuest'] as bool,
              user: parameters['user'] as UserEntity?,
            ),
          );
        },
      ),
      // Profile
      GoRoute(
          name: UhlLinkRoutesNames.updateProfile,
          path: '/updatePassword',
          pageBuilder: (context, state) {
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child:
                    UpdateProfilePage(user: parameters['user'] as UserEntity));
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
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child: SettingsPage(
                  user: parameters['user'] as UserEntity?,
                ));
          }),
      GoRoute(
          name: UhlLinkRoutesNames.aboutPage,
          path: '/about',
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: AboutPage());
          }),
      GoRoute(
          name: UhlLinkRoutesNames.jobDetailsPage,
          path: '/job_details',
          pageBuilder: (context, state) {
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child: JobDetailsPage(job: parameters["job"]));
          }),
      GoRoute(
          name: UhlLinkRoutesNames.notifications,
          path: '/notifications',
          pageBuilder: (context, state) {
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child: NotificationsPage(
                  isGuest: parameters["isGuest"] as bool,
                  user: parameters['user'] as UserEntity?,
                ));
          }),
      GoRoute(
          name: UhlLinkRoutesNames.notificationDetails,
          path: '/notification_details',
          pageBuilder: (context, state) {
            Map<String, dynamic> parameters =
                state.extra as Map<String, dynamic>;
            return MaterialPage(
                key: state.pageKey,
                child: NotificationDetailsPage(
                  notificationMap:
                      parameters['notification'] as Map<String, dynamic>,
                ));
          }),
      GoRoute(
        name: UhlLinkRoutesNames.addNotification,
        path: '/add_notification',
        pageBuilder: (context, state) {
          Map<String, dynamic> parameters = state.extra as Map<String, dynamic>;
          return MaterialPage(
            key: state.pageKey,
            child: AddNotificationPage(
              user: parameters['user'] as UserEntity,
            ),
          );
        },
      ),
      // Test
      GoRoute(
          name: UhlLinkRoutesNames.test,
          path: '/test',
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: const TestScreen());
          }),
      // Cafeteria
      GoRoute(
          name: UhlLinkRoutesNames.cafeteria,
          path: '/cafeteria',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: const CafeteriaPage());
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
