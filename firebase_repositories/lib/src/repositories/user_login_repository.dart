import 'package:firebase_auth/firebase_auth.dart';

class UserLoginRepository //extends Repository<UserLogin>
{
  final firebaseAuth = FirebaseAuth.instance;

  // static final UserLoginRepository _instance =
  //     UserLoginRepository._internal(path: 'login');

  // UserLoginRepository._internal({required super.path});

  // factory UserLoginRepository() => _instance;

  Future<UserCredential> registerAccount(
      {required String userName, required String pwd}) {
    return firebaseAuth.createUserWithEmailAndPassword(
        email: userName, password: pwd);
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  Future<UserCredential> login(
      {required String userName, required String pwd}) {
    print('Before firebase call in repo');
    return firebaseAuth.signInWithEmailAndPassword(
        email: userName, password: pwd);
  }

  Future<void> logout() async {
    firebaseAuth.signOut();
  }

  // @override
  // Future<String?> addToList({required UserLogin item}) async {
  //   await db.collection(path).doc(item.id).set(serialize(item));
  //   return "success";
  // }

  // Future<Owner?> canUserLogin({required UserLogin user}) async {
  //   final snapshot = await db.collection(path).doc(user.id).get();
  //   final json = snapshot.data();

  //   if (json == null) {
  //     return null;
  //   }
  //   return OwnerRepository().deserialize(json);
  // }

  // @override
  // UserLogin deserialize(Map<String, dynamic> json) => UserLogin.fromJson(json);

  // @override
  // Map<String, dynamic> serialize(UserLogin item) => item.toJson();
}
