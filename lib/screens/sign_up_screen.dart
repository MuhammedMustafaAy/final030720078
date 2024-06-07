import 'package:ev_spot_flutter/components/app_logo_image_component.dart';
import 'package:ev_spot_flutter/screens/sign_in_screen.dart';
import 'package:ev_spot_flutter/screens/terms_condition_screen.dart';
import 'package:ev_spot_flutter/screens/verification_screen.dart';
import 'package:ev_spot_flutter/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert'; // For utf8.encode
import 'package:crypto/crypto.dart'; // For sha256

class SignUp extends StatefulWidget {
  final String phoneNumberFromSignIn;

  const SignUp({Key? key, required this.phoneNumberFromSignIn})
      : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final supabase = Supabase.instance.client;

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneNumberController.text = widget.phoneNumberFromSignIn;
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Hashing function
  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert string to bytes
    var digest = sha256.convert(bytes); // Hash the bytes using SHA-256
    return digest.toString(); // Convert hash to string
  }

  Future<bool> createUser({
    required final String email,
    required final String password,
  }) async {
    final response =
        await supabase.auth.signUp(email: email, password: password);
    final error = response;
    // ignore: unnecessary_null_comparison
    if (error == null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
            elevation: 0, centerTitle: true, title: AppLogoImageComponent()),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sign up Now', style: boldTextStyle(fontSize: 22)),
              SizedBox(height: 6),
              Text('Looks like you\'re not registered yet',
                  style: secondaryTextStyle(fontSize: 16)),
              SizedBox(height: 40),
              Text('Phone Number', style: primaryTextStyle()),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                decoration:
                    inputDecoration(context, hintText: 'Enter Phone Number'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                cursorColor: Theme.of(context).colorScheme.primary,
                cursorWidth: 1,
                maxLength: 10,
              ),
              SizedBox(height: 20),
              Text('Full Name', style: primaryTextStyle()),
              SizedBox(height: 10),
              TextFormField(
                controller: _fullNameController,
                decoration:
                    inputDecoration(context, hintText: 'Enter Full Name'),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: Theme.of(context).colorScheme.primary,
                cursorWidth: 1,
              ),
              SizedBox(height: 20),
              Text('Email Address', style: primaryTextStyle()),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration:
                    inputDecoration(context, hintText: 'Enter Email Address'),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Theme.of(context).colorScheme.primary,
                cursorWidth: 1,
              ),
              SizedBox(height: 20),
              Text('Password', style: primaryTextStyle()),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration:
                    inputDecoration(context, hintText: 'Enter Password'),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                cursorColor: Theme.of(context).colorScheme.primary,
                cursorWidth: 1,
              ),
              SizedBox(height: 25),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    final isSuccess =
                        await createUser(email: email, password: password);
                    if (isSuccess) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerificationScreen()));
                    } else {
                      // Handle error (e.g., show a Snackbar with an error message)
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                    }

                    // Şifreyi hashle
                    String hashedPassword =
                        hashPassword(_passwordController.text);

                    // Kullanıcı verisini Supabase'e ekle
                    final response = await supabase.from('profile').insert([
                      {
                        'phonenumber': _phoneNumberController.text,
                        'name': _fullNameController.text,
                        'email': _emailController.text,
                        'password': hashedPassword,
                      }
                    ]);

                    if (response.error == null) {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerificationScreen()));
                      });
                    } else {
                      // Hata durumu
                      print('Error signing up: ${response.error!.message}');
                    }
                  },
                  child: Text('Continue',
                      style: primaryTextStyle(color: Colors.white)),
                  style: Theme.of(context).elevatedButtonTheme.style,
                ),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text('By Continue you\'re agreed to our',
                        style: primaryTextStyle()),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TermsAndConditionScreen()));
                      },
                      child: Text('Terms & Conditions',
                          style: primaryTextStyle(
                              color: Theme.of(context).colorScheme.primary)),
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

  newMethod(response) {}
}