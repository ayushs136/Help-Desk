import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'  ;

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Stream<String> get onAuthStateChange => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );


// get UID

Future<String> getCurrentUID() async{
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
    userUpdateInfo.displayName = name;
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
  signOut() {
    return _firebaseAuth.signOut();
  }


  //signin anonymously

  Future signInAnonymously(){
    return _firebaseAuth.signInAnonymously();
  }

  // converting anonymous user
  Future convertUserWithEmail(String email, String password, String name) async{
    final currentUser = await _firebaseAuth.currentUser();
    final credentials = EmailAuthProvider.getCredential(email: email, password: password);
    await currentUser.linkWithCredential(credentials);
    await updateUserName(name, currentUser);
  }

//convert with google
Future<String> convertWithGoogle()async{
    final currentUser = await _firebaseAuth.currentUser();
    final GoogleSignInAccount account  =  await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
     await currentUser.linkWithCredential(credential);
    await updateUserName(_googleSignIn.currentUser.displayName, currentUser);
    return currentUser.uid;
}
// forgot password
  Future sendPasswordResetEmail(String email) async{
    return _firebaseAuth.sendPasswordResetEmail(email: email);

  }



  //google sign in

  Future<String> signInWithGoogle() async{
    final GoogleSignInAccount account  =  await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

    return (await _firebaseAuth.signInWithCredential(credential)).uid;

  }
}


class EmailValidator{

  static String validate(String value){
    if(value.isEmpty){
      return "Email can't be empty";
    }
    // if(!value.contains("@")){
    //   return "Please enter a valid email!";
    // }

    return null;
  }
}

class NameValidator{

  static String validate(String value){
    if(value.isEmpty){
      return "Name can't be empty";
    }
    if(value.length<2){
      return "Name must be at least 2 characters long";
    }
    
    if(value.length>50){
      return "Name can't be more than 50 characters";
    }
    return null;
  }
}

class PasswordValidator{

  static String validate(String value){
    if(value.isEmpty){
      return "Password can't be empty";
    }
    return null;
  }
}