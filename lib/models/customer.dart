class Helper {
  String name;
  String photoURL;
  String email;
  String phone;
  bool isAvailable;
  List skills;
  String uid;

  Helper(
      {this.uid,
      this.skills,
      this.name,
      this.photoURL,
      this.email,
      this.phone,
      this.isAvailable});

  Map<String, dynamic> toJSON() => {
        'name': name,
        'uid': uid,
        'skills': skills,
        'photoURL': photoURL,
        'email': email,
        'phone': phone,
        'isAvailable': isAvailable,
      };


    
  Map<String, dynamic> toJSON1() => {
        'name': "name",
        'uid': "uid",
        'skills': "skills",
        'photoURL': "photoURL",
        'email': "email",
        'phone': "phone",
        'isAvailable': "isAvailable",
      };

  Map toMap(Helper user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['skills'] = user.skills;
    data["photoURL"] = user.photoURL;
    data["isAvailable"] = user.isAvailable;
    data["phone"] = user.phone;
    return data;
  }

  // Named constructor
  Helper.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.skills = mapData['skills'];
    this.photoURL = mapData['photoURL'];
    this.isAvailable = mapData['isAvailable'];
    this.phone = mapData['phone'];
  }
}
