import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/SignIn.dart';
import 'package:project1/globalvar.dart' as globals;

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        body: Center(
            child: isSmallScreen
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _FormContent(),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Center(child: _FormContent()),
                        ),
                      ],
                    ),
                  )));
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlutterLogo(size: isSmallScreen ? 100 : 200),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Register",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;
  String? fullName;
  String? userName;
  String? email;
  String? password;
  String? confirmPassword;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                setState(() {
                  fullName = value;
                });
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Fullname',
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.account_circle),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                setState(() {
                  userName = value;
                });
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
                prefixIcon: Icon(Icons.account_circle),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Please enter a valid email';
                }
                setState(() {
                  email = value;
                });
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                setState(() {
                  password = value;
                });
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value != password) {
                  return 'Confirm the password again';
                }
                setState(() {
                  confirmPassword = value;
                });
                return null;
              },
              obscureText: !_isPasswordConfirmVisible,
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Confirm your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordConfirmVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {

                    int count = await globals.getTotalDocumentCount('User');
                    Map<String, String> dataToSave={
                      'User_FullName': fullName.toString(),
                      'User_email': email.toString(),
                      'User_password': password.toString(),
                      'User_username': userName.toString(),
                      'User_ID': (count + 1).toString(),
                      'User_Img': ""
                      };
                      await FirebaseFirestore.instance
                          .collection('User')
                          .add(dataToSave);

                      // Navigate to the SignInPage after sign-up
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ));
                    }
                  }),
            ),
            _gap(),
            TextButton(
              onPressed: () {
                // Navigate to the SignInPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInPage(),
                  ),
                );
              },
              child: const Text("Already have an account? Sign In"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
