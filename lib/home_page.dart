import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider_example/google_signin_provider.dart';

import 'notifi_service.dart';

import 'product_page.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  NotificationService service = NotificationService();
  String? token;

  Future saveUserDetails(GoogleSignInAccount _user, String? token) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(_user.id).set({
      'username': _user.displayName,
      'email': _user.email,
      'photoUrl': _user.photoUrl,
      'Device token': token
      // Add more fields as needed
    });
  }

  @override
  void initState() {
    super.initState();
    service.firebaseInit(context);
    service.isTokenRefresh();
    service.setupInteractMessage(context);
    service.requestNotificationPermission();
    service.getDeviceToken().then((value) {
      token = value;
      print("Device Token:");
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: ElevatedButton.icon(
              onPressed: () async {
                final provider = context.read<GoogleSignInProvider>();
                await provider.googleLogin();
                saveUserDetails(provider.user, token);
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductPage()));
              },
              icon: const Icon(Icons.key),
              label: const Text("Google Sign In")),
        ));
  }
}
