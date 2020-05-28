import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helpdesk_2/enum/user_state.dart';
import 'package:helpdesk_2/models/helper.dart';
import 'package:helpdesk_2/screens/home/chat_screens/widgets/online_dot_indicator.dart';
import 'package:helpdesk_2/shared/constants.dart';

class AuthServices {


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<String> get onAuthStateChange => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );





// get UID

  Future<String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }





  // Email and Password Sign Up

  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    print("create user function");
    final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);





    // update the username

    await updateUserName(name, currentUser);
    return currentUser.uid;
  }





  Future updateUserName(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();

    String initials = Util.getInitials(name);

    userUpdateInfo.displayName = name;
    userUpdateInfo.photoUrl = initials;

    await currentUser.updateProfile(userUpdateInfo);

    await currentUser.reload();
    print("create email password");
  }






  // Email & password Sign in
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .uid;
  }





  // Sign out
  signOut() async {
    await _googleSignIn.signOut();
    return _firebaseAuth.signOut();
  }






  //signin anonymously

  Future signInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }






  // converting anonymous user
  Future convertUserWithEmail(
      String email, String password, String name) async {
    final currentUser = await _firebaseAuth.currentUser();
    final credentials =
        EmailAuthProvider.getCredential(email: email, password: password);
    await currentUser.linkWithCredential(credentials);
    await updateUserName(name, currentUser);
  }





//convert with google
  Future<String> convertWithGoogle() async {
    final currentUser = await _firebaseAuth.currentUser();
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
    await currentUser.linkWithCredential(credential);
    await updateUserName(_googleSignIn.currentUser.displayName, currentUser);
    return currentUser.uid;
  }





// forgot password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }






  Helper helper;




  
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _firebaseAuth.currentUser();
    return currentUser;
  }





  Future<Helper> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection("userData")
        .document(currentUser.uid)
        .get();

    return Helper.fromMap(documentSnapshot.data);
  }



Future<Helper> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await Firestore.instance.collection('userData').document(id).get();
      return Helper.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }




    static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
     switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }


void setUserState({@required String userId, @required UserState userState}) {
   
   
    int stateNum =  stateToNum(userState);

    Firestore.instance.collection('userData').document(userId).updateData({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>      Firestore.instance.collection('userData').document(uid).snapshots();



  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await Firestore.instance
        .collection("userData")
        .where('email', isEqualTo: user.email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;
    return docs.length == 0 ? true : false;
  }








  Future<void> addDataToDb(FirebaseUser currentUser) async {
    // String username = Utils.getUserName(currentUser.email);
    helper = Helper(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      photoURL: currentUser.photoUrl,
      phone: currentUser.phoneNumber,
      skills: ["", "", "", ""],
      isAvailable: false,
    );

    Firestore.instance
        .collection("userData")
        .document(currentUser.uid)
        .setData(helper.toMap(helper));
  }






  //google sign in

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

    return (await _firebaseAuth.signInWithCredential(credential));
  }
}




class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    // if(!value.contains("@")){
    //   return "Please enter a valid email!";
    // }

    return null;
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }

    if (value.length > 50) {
      return "Name can't be more than 50 characters";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}
