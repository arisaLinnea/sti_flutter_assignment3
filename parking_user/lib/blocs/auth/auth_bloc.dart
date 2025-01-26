import 'package:equatable/equatable.dart';
import 'package:firebase_repositories/firebase_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_user/utils/utils.dart';
import 'package:shared_client/shared_client.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLoginRepository userLoginRepository;
  final OwnerRepository ownerRepository;

  AuthBloc({required this.ownerRepository, required this.userLoginRepository})
      : super(AuthInitialState()) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthLoginEvent) {
          await _handleLoginToState(event, emit);
        } else if (event is AuthLogoutEvent) {
          await _handleLogoutToState(emit);
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          emit(AuthFailedState(
              message: e.message ?? 'An unknown error occurred'));
        } else {
          emit(AuthFailedState(message: 'An unknown error occurred'));
        }
        emit(AuthUnauthorizedState());
      }
    });
  }

  Future<void> _handleLoginToState(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    print('Before repo call in bloc');
    final authUser = await userLoginRepository.login(
        userName: event.userName, pwd: event.pwd);
    User? user = userLoginRepository.getCurrentUser();

    Owner owner = await ownerRepository.getElementByAuthId(id: user!.uid);

    print('After repo call in bloc');
    emit(AuthAuthenticatedState(newUser: owner));
    print('Sent AuthAuthenticatedState');
  }

  Future<void> _handleLogoutToState(Emitter<AuthState> emit) async {
    await userLoginRepository.logout();
    print('Logout');
    emit(AuthUnauthorizedState());
  }
}
