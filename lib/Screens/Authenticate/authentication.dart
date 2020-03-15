import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:helpdesk/models/helper.dart';
import 'package:helpdesk/models/user.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  //dependencies object
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Observable<FirebaseUser> users; // for auth changes
  Observable<Map<String, dynamic>> profile;

  // signin with google
   Future<FirebaseUser> signInWithGoogle() async {
    users = Observable(_auth.onAuthStateChanged);

    profile = users.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('user')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print("signed in sucessful" + user.displayName);
      await DatabaseServices (uid: user.uid).updateUserDataGoogle(user);
      print("USER ${user.metadata}");
      return user;
      // print("Signed In"+users.displayName);
      // AuthResult result = await ;
      // FirebaseUser user = result.user;
      // return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString()+ " error in SignIn()");
      return null;
    }
  }
  //signout

  Future signOut() async{
    try{

      print("Signed Out Sucessful");
      return await _auth.signOut();
    }catch(e){
      print(e.toString()+" error in signOut()");
    }
  }  
  


  
//create user object baesd on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user streams

  Stream<User> get user {
    return _auth.onAuthStateChanged
        // .map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

}

final AuthService authService = AuthService(); 










class DatabaseServices{
  final String uid;

  DatabaseServices({this.uid});
    final CollectionReference userDataCollection =
      Firestore.instance.collection('users');

      //update user data Google


  Future<void> updateUserDataGoogle(FirebaseUser user) async {
    DocumentReference ref = userDataCollection.document(user.uid);
print(ref.documentID);

    return ref.setData(
      { 
        'uid': user.uid,
        'email': user.email,
        'photoURL': user.photoUrl,
        'displayName': user.displayName,
        'skills': ["Python", "Java", "Guitar", "Public Speaking"],
        'lastSeen': DateTime.now()

      },
      merge: true,
    );
  }

  Stream<GoogleUserData> get userDataGoogle {
    return userDataCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshotGoogle);
  }
// read data
  GoogleUserData _userDataFromSnapshotGoogle(DocumentSnapshot snapshot) {
    return GoogleUserData(
      uid: uid,
      displayName: snapshot.data['displayname'],
      photoURL: snapshot.data['photoUrl'],
      skills: snapshot.data['skills'],
      email: snapshot.data['email'],
    );
  }
 

  






  final CollectionReference userData =
      Firestore.instance.collection('users');
  // room list from snapshot
  List<Helper> _helperDetailListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Helper(
        
        uid: doc.data['uid'] ?? '',
        displayName: doc.data['displayName']??'',
        email: doc.data['email']??'',
        // lastSeen:  doc.data['lastSeen']??'',
        photoURL:  doc.data['photoURL']??'',
        skills:  doc.data['skills']??'',
      );
    }).toList();
  }


 Stream<List<Helper>> get userDetails {
    return userData.snapshots().map(_helperDetailListFromSnapshot);
  }


  // delete data

  // update data
}