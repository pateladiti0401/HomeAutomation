import 'package:google_sign_in/google_sign_in.dart';

class SignIn {
  static final _googleSignIn = GoogleSignIn(
    // clientId:
    //     '679216191480-d3uosm6fdbli28q17ccpqniuhr2tu5hk.apps.googleusercontent.com',
    //  scopes: <String>[GoogleAPI.CalendarApi.calendarScope],
    scopes: <String>["email"],
  );

  static GoogleSignIn get googleSignIn => _googleSignIn;

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static final GoogleSignInAccount? _currentUser = _googleSignIn.currentUser;
  static GoogleSignInAccount? get CurrentUser => _currentUser;
  static Future<GoogleSignInAuthentication> googleSignInAuthentication =
      _currentUser!.authentication;
  static Future signOut = _googleSignIn.signOut();
}
