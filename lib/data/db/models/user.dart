class User {
  final String uid;
  
  User({this.uid});
}

class GoogleUserData{
  final String uid;
  final String email;
  final String photoURL;
  final String displayName;
  final List skills;
  final String lastSeen;
  final String phone;

  GoogleUserData({this.uid, this.email, this.photoURL, this.displayName, this.skills, this.lastSeen, this.phone});
  
}