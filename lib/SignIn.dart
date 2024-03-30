import 'package:flutter/material.dart';
import 'package:project1/signup.dart';
import 'package:project1/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        body: Center(
            child: isSmallScreen
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _Logo(),
                      _FormContent(),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: const [
                        Expanded(child: _Logo()),
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
            "Login",
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
  String? email;
  String? password;

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
                email = value;

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
                  )),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('User').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No data found.'),
                  );
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    // Access data in each document
                    Map<String, dynamic> userData =
                        document.data() as Map<String, dynamic>;

                    // Example: Print email and password
                    String email = userData['email'];
                    String password = userData['password'];

                    return ListTile(
                      title: Text('Email: $email'),
                      subtitle: Text('Password: $password'),
                    );
                  }).toList(),
                );
              },
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
                    'Sign in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  // if (_formKey.currentState?.validate() ?? false) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => HomePage()),
                  //   );
                  // }

                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();

                    // Check if email and password are not null
                    if (email != null && password != null) {
                      // Call loginUser function
                      bool success = await loginUser(email!, password!);

                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        // Handle authentication failure
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid email or password')),
                        );
                      }
                    } else {
                      // Handle case where email or password is null
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email or password is null')),
                      );
                    }
                  }
                },
              ),
            ),
            _gap(),
            TextButton(
              onPressed: () {
                // Navigate to the SignUp page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text("Don’t have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}

Future<bool> loginUser(String email, String password) async {
  try {
    // Retrieve the user document from the "User" collection based on the provided email
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('email', isEqualTo: email)
        .get();

    // Check if any user with the provided email exists
    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document (assuming email is unique)
      DocumentSnapshot userDoc = querySnapshot.docs.first;

      // Get the password stored in the user document
      String storedPassword = userDoc['password'];

      // Authenticate the user using Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the password matches the stored password
      if (password == storedPassword) {
        return true; // Return true if the email and password match
      } else {
        return false; // Return false if the password doesn't match
      }
    } else {
      return false; // Return false if no user with the provided email exists
    }
  } catch (e) {
    print('Login error: $e');
    return false; // Return false if an error occurs
  }
}
