class Customer{
   String name;
   String photoURL;
   String email;
   String phone;
   bool isAvailable;
   List skills;
   String uid;

  Customer({this.uid, this.skills,this.name, this.photoURL,  this.email, this.phone,  this.isAvailable});

Map<String, dynamic> toJSON()=>{
  'name': name,
  'uid': uid,
  'skills': skills,
  'photoURL':photoURL,
  'email': email,
  'phone': phone,
  'isAvailable': isAvailable,
  
};
Map<String, dynamic> toJSON1()=>{
  'name': "name",
  'uid': "uid",
  'skills': "skills",
  'photoURL':"photoURL",
  'email': "email",
  'phone': "phone",
  'isAvailable': "isAvailable",
  
};
}