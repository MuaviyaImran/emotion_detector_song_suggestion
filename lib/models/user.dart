import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  String uid;
  String name;
  String email;
  String dob;
  String profileImageUrl;

  UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.dob,
    required this.profileImageUrl,
  });

  factory UserData.fromSharedPreferences(SharedPreferences prefs) {
    return UserData(
      uid: prefs.getString('uid') ?? '',
      name: prefs.getString('name') ?? '',
      email: prefs.getString('email') ?? '',
      dob: prefs.getString('dob') ?? '',
      profileImageUrl: prefs.getString('profileImageUrl') ?? '',
    );
  }
}
