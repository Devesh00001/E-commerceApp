import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:provider_example/cart_page.dart';
import 'package:provider_example/main.dart';
import 'package:provider_example/product.dart';
import 'package:provider_example/product_page.dart';
import 'package:provider_example/selected_product_list.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'cart page ...',
    (tester) async {
      await Firebase.initializeApp();

      Hive.registerAdapter(ProductAdapter());
      await Hive.initFlutter();
      box = await Hive.openBox<Product>("productbox");
      Stripe.publishableKey =
          'pk_test_51OA5VDSF5l2QMOmHoqYPN7DBV6ZpRgkKZ7L65k26tQoBllr1C44epptJ1i5rNEraFLAMg5gOHCMSAic0ud63tktO008ROjkoO0';
      // WidgetsFlutterBinding.ensureInitialized();
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => SelectedProductList())
          ],
          child: const ScreenUtilInit(
              designSize: Size(360, 690),
              minTextAdapt: true,
              splitScreenMode: true,
              child: MaterialApp(home: ProductPage()))));

      await tester.pumpAndSettle();

      // final productButton = find.image(const NetworkImage("https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg"));
      final specificNetworkImageFinder =
          find.byWidgetPredicate((Widget widget) {
        if (widget is Image && widget.image is NetworkImage) {
          NetworkImage networkImage = widget.image as NetworkImage;
          return networkImage.url ==
              'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg';
        }
        return false;
      });
      expect(specificNetworkImageFinder, findsOneWidget);

      await tester.tap(specificNetworkImageFinder);

      await tester.pumpAndSettle();

      final addToCartButton = find.text("Add To Cart");

      expect(addToCartButton, findsOneWidget);

      await tester.tap(addToCartButton);

      await tester.pump();

      // final placeOrderButton = find.text('Place Order');
      //
      // expect(placeOrderButton, findsOneWidget);
      //
      // await tester.tap(placeOrderButton);
      //
      // await tester.pump();
      //
      // final cardNumberField = find.widgetWithText(TextField, 'Card number');
      // final expiryDateField = find.widgetWithText(TextField, 'MM/YY');
      // final cvcField = find.widgetWithText(TextField, 'CVC');
      // final pinCodeField = find.widgetWithText(TextField, 'Zip Code');
      //
      // expect(cardNumberField, findsOneWidget);
      // expect(expiryDateField, findsOneWidget);
      // expect(cvcField, findsOneWidget);
      // expect(pinCodeField, findsOneWidget);
      //
      // await tester.enterText(cardNumberField, '4242424242424242');
      // await tester.enterText(expiryDateField, '12/23');
      // await tester.enterText(cvcField, '123');
      // await tester.enterText(pinCodeField, '12345');
      //
      // final payButton = find.text('Pay \$10.00');
      // expect(payButton, findsOneWidget);
      // await tester.tap(payButton);
      // await tester.pumpAndSettle();
      //
      // final snackBar = find.byType(SnackBar);
      // expect(snackBar, findsOneWidget);
      // expect(find.text('paid successfully'), findsOneWidget);
    },
  );
}
