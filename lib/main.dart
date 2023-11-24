import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider_example/product.dart';
import 'package:provider_example/product_page.dart';
import 'package:provider/provider.dart';
import 'package:provider_example/selected_product_list.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';

Box? box;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  // Stripe.publishableKey =
  //     'pk_test_51OA5VDSF5l2QMOmHoqYPN7DBV6ZpRgkKZ7L65k26tQoBllr1C44epptJ1i5rNEraFLAMg5gOHCMSAic0ud63tktO008ROjkoO0';

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await Firebase.initializeApp(
  //     name: "provider_example",
  //     options: const FirebaseOptions(
  //         apiKey: "AIzaSyC3NlZdhSIsjdmH_ZO1yONQJ4Fw1-xZ_88",
  //         authDomain: "e-commerce-bdc67.firebaseapp.com",
  //         projectId: "e-commerce-bdc67",
  //         storageBucket: "e-commerce-bdc67.appspot.com",
  //         messagingSenderId: "956782711879",
  //         appId: "1:956782711879:web:207208107d9b2a341c4d62",
  //         measurementId: "G-NT28WKZ5Z2"));

  Hive.registerAdapter(ProductAdapter());
  await Hive.initFlutter();
  box = await Hive.openBox<Product>("productbox");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SelectedProductList())
  ], child: const MyApp()));
}

@pragma("vm:entry-point")
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print(message.notification!.title.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const ProductPage(),
          );
        });
  }
}
