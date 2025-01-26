import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_repositories/firebase_repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_user/blocs/auth/auth_bloc.dart';
import 'package:parking_user/blocs/user/user_reg_bloc.dart';
import 'package:parking_user/blocs/vehicle/vehicle_bloc.dart';
import 'package:parking_user/firebase_options.dart';
import 'package:parking_user/providers/theme_provider.dart';
import 'package:parking_user/routes/router.dart';
import 'package:parking_user/style/theme.dart';
import 'package:parking_user/views/login_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_client/shared_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "../.env");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /*
MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ItemRepository>(
              create: (context) => ItemRepository()),
          RepositoryProvider<AuthRepository>(
              create: (context) => AuthRepository()),
          RepositoryProvider<UserRepository>(
              create: (context) => UserRepository()),
        ],
        child: BlocProvider(
            create: (context) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
                userRepository: context.read<UserRepository>())
              ..add(AuthUserSubscriptionRequested()),
            child: const MyApp())),
  );
  */
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthBloc(
                userLoginRepository: UserLoginRepository(),
                ownerRepository: OwnerRepository())),
        BlocProvider(
            create: (context) => UserRegBloc(
                userLoginRepository: UserLoginRepository(),
                ownerRepository: OwnerRepository())),
        BlocProvider(
            create: (context) => VehicleBloc(
                vehicleRepository: VehicleRepository(),
                authBloc: context.read<AuthBloc>())),
        BlocProvider(
            create: (context) =>
                ParkingLotBloc(parkingLotRepository: ParkingLotRepository())),
        BlocProvider(
            create: (context) =>
                ParkingBloc(parkingRepository: ParkingRepository())),
      ],
      child: ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(),
        child: const FindMeASpot(),
      )));
}

class FindMeASpot extends StatelessWidget {
  const FindMeASpot({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const AuthViewSwitcher(),
    );
  }
}

class AuthViewSwitcher extends StatelessWidget {
  const AuthViewSwitcher({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeOutCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          print('In main user, state: $state');
          if (state is AuthAuthenticatedState) {
            return const UserView();
          } else {
            return const LoginView();
          }
        },
      ),
    ));
  }
}

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          title: 'Find Me A Spot',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeNotifier.themeMode,
        );
      },
    );
  }
}
