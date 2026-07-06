import '../../data/models/user.dart';

abstract class UserRepository {
  Future<bool> login(String email, String password);
  Future<bool> register(Map<String, dynamic> userData);
  Future<User> getProfile();
}