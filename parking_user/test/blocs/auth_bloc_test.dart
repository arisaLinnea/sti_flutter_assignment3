import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_repositories/firebase_repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_user/blocs/auth/auth_bloc.dart';

import '../mocks/mock_data.dart';

class MockUserLoginRepository extends Mock implements UserLoginRepository {}

void main() {
  late MockUserLoginRepository mockUserLoginRepository;
  late AuthBloc authBloc;

  setUp(() {
    mockUserLoginRepository = MockUserLoginRepository();
    authBloc = AuthBloc(userLoginRepository: mockUserLoginRepository);
  });

  setUpAll(() {
    registerFallbackValue(mockOwner);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Tests', () {
    test('initial state is AuthInitialState', () {
      expect(authBloc.state, equals(AuthInitialState()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits AuthAuthenticatedState when login is successful',
      build: () {
        when(() => mockUserLoginRepository.login(userName: any(), pwd: any()))
            .thenAnswer((_) async => mockOwner);
        return authBloc;
      },
      act: (bloc) => bloc.add(
        AuthLoginEvent(userName: mockUsername, pwd: mockPassword),
      ),
      expect: () => [
        AuthLoadingState(),
        AuthAuthenticatedState(newUser: mockOwner),
      ],
      verify: (_) {
        verify(() => mockUserLoginRepository.login(userName: any(), pwd: any()))
            .called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthFailedState when login is unsuccessful',
      build: () {
        when(() => mockUserLoginRepository.login(userName: any(), pwd: any()))
            .thenAnswer((_) async => null);
        return authBloc;
      },
      act: (bloc) => bloc.add(
        AuthLoginEvent(userName: mockUsername, pwd: mockPassword),
      ),
      expect: () => [
        AuthLoadingState(),
        AuthFailedState(message: 'Login Failed'),
        AuthUnauthorizedState(),
      ],
      verify: (_) {
        verify(() => mockUserLoginRepository.login(userName: any(), pwd: any()))
            .called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthUnauthorizedState when logout is successful',
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthLogoutEvent()),
      expect: () => [
        AuthUnauthorizedState(),
      ],
    );
  });
}
