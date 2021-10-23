import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mjengoni/UserPages/Wrapper.dart';
import 'package:progress_dialog/progress_dialog.dart';

class GettingStartedScreen extends StatefulWidget {
  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signed in');

      return '$user';
    } else {}

    return null;
  }

  Future<void> signOutGoogle() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/welcome_image.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              colors: [Colors.black, Colors.black.withOpacity(.1)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mjengoni',
                    style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                        fontSize: 32.0,
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Nyumba na viwanja kiganjani',
                style: GoogleFonts.ptSans(
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              _signInButton(),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        // signInWithGoogle(model).then((FirebaseUser user) {
        //   model.clearAllModels();
        //   Navigator.of(context).pushNamedAndRemoveUntil(
        //       RouteName.Home, (Route<dynamic> route) => false);
        // }).catchError((e) => print(e));

        signInWithGoogle().then((result) {
          if (result != null) {
            Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => Wrapper(),
                ),
                (r) => false);
          }
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: 24.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
