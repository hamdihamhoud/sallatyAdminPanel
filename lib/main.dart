import 'package:adminpanel/providers/admin_functions.dart';
import 'package:adminpanel/providers/auth.dart';
import 'package:adminpanel/screens/account_screen.dart';
import 'package:adminpanel/screens/feedback_screen.dart';
import 'package:adminpanel/screens/orders_screen.dart';
import 'package:adminpanel/screens/delivery_screen.dart';
import 'package:adminpanel/screens/vendors_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/orders.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          create: (_) => Orders(),
          update: (ctx, auth, orders) => orders
            ..setToken(auth.token)
            ..setUserId(auth.id),
        ),
        ChangeNotifierProxyProvider<AuthProvider, AdminFunctioins>(
          create: (_) => AdminFunctioins(),
          update: (ctx, auth, orders) => orders
            ..setToken(auth.token)
            ..setUserId(auth.id),
        ),
      ],
      child: MaterialApp(
        title: 'Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // canvasColor: Color(0xFF828282),
          // buttonColor: Color(0xFF333333),
          primaryColor: Color(0xFF6fb9b8),
          accentColor: Color(0xFFd4f5ee),
          primaryColorBrightness: Brightness.dark,
          accentColorBrightness: Brightness.dark,
          fontFamily: 'Gilroy',
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                Color(0xFFd4f5ee),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                Color(0xFFd4f5ee),
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                Color(0xFFd4f5ee),
              ),
            ),
          ),
        ),

        home: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => FutureBuilder(
            future: auth.isAuth(),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? SplashScreen()
                    : snapshot.data == true
                        ? OrdersScreen()
                        : AuthScreen(),
          ),
        ),
        //  AuthScreen(),
        routes: {
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          DeliveryScreen.routeName: (ctx) => DeliveryScreen(),
          VendorsScreen.routeName: (ctx) => VendorsScreen(),
          AccountScreen.routeName: (ctx) => AccountScreen(),
          FeedbackScreen.routeName: (ctx) => FeedbackScreen(),
        },
      ),
    );
  }
}
