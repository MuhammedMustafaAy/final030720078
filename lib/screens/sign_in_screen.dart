import 'package:ev_spot_flutter/components/app_logo_image_component.dart';
import 'package:ev_spot_flutter/screens/home_screen.dart';
import 'package:ev_spot_flutter/screens/sign_up_screen.dart';
import 'package:ev_spot_flutter/utils/common.dart';
import 'package:ev_spot_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final supabase = Supabase.instance.client;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign in failed')),
      );
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthResponse response = await supabase.auth.signInWithIdToken(
      provider: Provider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken!,
    );

    if (response.session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign in failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          title: AppLogoImageComponent(isCenter: true),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(splash_image2, fit: BoxFit.cover),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hi mate,', style: secondaryTextStyle(fontSize: 16)),
                    SizedBox(height: 6),
                    Text('Sign in Now', style: boldTextStyle(fontSize: 22)),
                    SizedBox(height: 40),
                    Text('Email Address', style: primaryTextStyle()),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: inputDecoration(context,
                          hintText: 'Enter Email Address'),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: 25),
                    Text('Password', style: primaryTextStyle()),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: 25),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          await signIn();
                        },
                        child: Text('Continue',
                            style: primaryTextStyle(color: Colors.white)),
                        style: Theme.of(context).elevatedButtonTheme.style,
                      ),
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: Text('Or Continue With', style: primaryTextStyle()),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                signInWithGoogle();
                              },
                              icon: Image.asset(ic_google, height: 22, width: 22),
                              label: Text('Google', style: boldTextStyle()),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Handle other sign in options if needed
                              },
                              icon: Image.asset(ic_facebook, height: 22, width: 22),
                              label: Text('Facebook', style: boldTextStyle()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(phoneNumberFromSignIn: ''),
                          ),
                        );
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Sign Up', style: boldTextStyle(color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Provider {
  static var google;
}
