import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes.dart';
import 'package:uhl_link/features/authentication/data/data_sources/user_data_sources.dart';
import 'package:uhl_link/features/authentication/domain/usecases/get_user_by_email.dart';
import 'package:uhl_link/features/authentication/domain/usecases/signup_user.dart';
import 'package:uhl_link/features/authentication/domain/usecases/update_password.dart';
import 'package:uhl_link/features/home/domain/usecases/add_lost_found_item.dart';
import 'package:uhl_link/features/home/domain/usecases/get_lost_found_items.dart';
import 'package:uhl_link/utils/theme.dart';

import 'features/authentication/data/repository_implementations/user_repository_impl.dart';
import 'features/authentication/domain/usecases/send_otp.dart';
import 'features/authentication/domain/usecases/signin_user.dart';
import 'features/authentication/presentation/bloc/user_bloc.dart';
import 'features/home/data/data_sources/job_portal_data_sources.dart';
import 'features/home/data/data_sources/lost_found_data_sources.dart';
import 'features/home/data/repository_implementations/job_portal_repository_impl.dart';
import 'features/home/data/repository_implementations/lost_found_repository_impl.dart';
import 'features/home/domain/usecases/get_jobs.dart';
import 'features/home/presentation/bloc/job_portal_bloc/job_bloc.dart';
import 'features/home/presentation/bloc/lost_found_bloc/lnf_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "institute.env");
  await UhlUsersDB.connect(dotenv.env['DB_CONNECTION_URL']!);
  await JobPortalDB.connect(dotenv.env['DB_CONNECTION_URL']!);
  await LostFoundDB.connect(dotenv.env['DB_CONNECTION_URL']!);
  const storage = FlutterSecureStorage();
  final GoRouter router = UhlLinkRouter().router;
  runApp(BlocProvider<ThemeBloc>(
    create: (context) => ThemeBloc(storage: storage)..loadSavedTheme(),
    child: UhlLink(router: router),
  ));
}

class UhlLink extends StatelessWidget {
  final GoRouter router;

  const UhlLink({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SignUpUser>(
            create: (_) => SignUpUser(UserRepositoryImpl(UhlUsersDB()))),
        RepositoryProvider<SendOTP>(
            create: (_) => SendOTP(UserRepositoryImpl(UhlUsersDB()))),
        RepositoryProvider<SignInUser>(
            create: (_) => SignInUser(UserRepositoryImpl(UhlUsersDB()))),
        RepositoryProvider<UpdatePassword>(
            create: (_) => UpdatePassword(UserRepositoryImpl(UhlUsersDB()))),
        RepositoryProvider<GetUserByEmail>(
            create: (_) => GetUserByEmail(UserRepositoryImpl(UhlUsersDB()))),
        RepositoryProvider<GetJobs>(
            create: (_) => GetJobs(JobPortalRepositoryImpl(JobPortalDB()))),
        RepositoryProvider<GetLostFoundItems>(
            create: (_) =>
                GetLostFoundItems(LostFoundRepositoryImpl(LostFoundDB()))),
        RepositoryProvider<AddLostFoundItem>(
            create: (_) =>
                AddLostFoundItem(LostFoundRepositoryImpl(LostFoundDB()))),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
              create: (context) => AuthenticationBloc(
                  loginUser: SignInUser(UserRepositoryImpl(UhlUsersDB())),
                  updatePassword:
                      UpdatePassword(UserRepositoryImpl(UhlUsersDB())),
                  getUserByEmail:
                      GetUserByEmail(UserRepositoryImpl(UhlUsersDB())),
                  signUpUser: SignUpUser(UserRepositoryImpl(UhlUsersDB())),
                  sendOTP: SendOTP(UserRepositoryImpl(UhlUsersDB())))),
          BlocProvider<JobPortalBloc>(
              create: (context) => JobPortalBloc(
                    getJobs: GetJobs(JobPortalRepositoryImpl(JobPortalDB())),
                  )),
          BlocProvider<LnfBloc>(
              create: (context) => LnfBloc(
                  getLostFoundItems:
                      GetLostFoundItems(LostFoundRepositoryImpl(LostFoundDB())),
                  addLostFoundItem: AddLostFoundItem(
                      LostFoundRepositoryImpl(LostFoundDB())))),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: 'UhlLink',
              themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
              theme: UhlLinkTheme.lightTheme,
              darkTheme: UhlLinkTheme.darkTheme,
              routerConfig: router,
            );
          },
        ),
      ),
    );
  }
}
