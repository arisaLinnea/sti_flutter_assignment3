import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_repositories/firebase_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_user/utils/utils.dart';
import 'package:shared_client/shared_client.dart';

part 'user_reg_event.dart';
part 'user_reg_state.dart';

class UserRegBloc extends Bloc<UserRegEvent, UserRegState> {
  final UserLoginRepository userLoginRepository;
  final OwnerRepository ownerRepository;

  UserRegBloc(
      {required this.userLoginRepository, required this.ownerRepository})
      : super(UserRegInitialState()) {
    on<UserRegEvent>((event, emit) async {
      try {
        if (event is UserRegisterEvent) {
          await _handleRegisterToState(event, emit);
        }
      } catch (e) {
        emit(UserRegFailedState(message: 'Failed to register'));
      }
    });
  }

  Future<void> _handleRegisterToState(
      UserRegisterEvent event, Emitter<UserRegState> emit) async {
    emit(UserRegLoadingState());
    try {
      // add user to firebase auth
      final userCredential = await userLoginRepository.registerAccount(
          userName: event.username, pwd: event.password);
      User? authUser = userLoginRepository.getCurrentUser();

      if (authUser != null) {
        Owner newOwner =
            Owner(name: event.name, ssn: event.ssn, loginId: authUser.uid);
        final response = await ownerRepository.addToList(item: newOwner);
        if (response != null) {
          emit(AuthRegistrationState());
        } else {
          emit(UserRegFailedState(message: 'Failed to add account'));
        }
      }
    } catch (e) {
      // emit(UserRegFailedState(message: 'Failed to add account'));
      Utils.toastMessage(e.toString());
    } finally {
      // only want to register the account, not login the user
      await userLoginRepository.logout();
    }

    // Owner newOwner = Owner(name: event.name, ssn: event.ssn);
    // String? uuid = await ownerRepository.addToList(item: newOwner);
    // UserLogin newLoginUser =
    //     UserLogin(ownerId: uuid, userName: event.username, pwd: event.password);
    // String? response = await userLoginRepository.addToList(item: newLoginUser);
    // if (response != null) {
    //   emit(AuthRegistrationState());
    // } else {
    //   emit(UserRegFailedState(message: 'Failed to add account'));
    // }
  }
}
