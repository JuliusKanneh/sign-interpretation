import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sign_interpretation/no_internet_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  late WebViewController controller;
  // bool hasInternet = false;

  void handleOnFinished(String url) {
    log("response: $url");

    log("On Finished URL: $url");
    if (url.contains('res=success') || url.contains('res=already')) {
    } else if (url.contains('res=failed')) {
      // Handle failure here
      log("Failed to load page");
      // display a toast to the user that the token is invalid.
    } else {
      log("Unknown");
    }
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar
            log('Loading: $progress%');
          },
          onPageStarted: (String url) {
            log("On Started URL: $url");
          },
          onPageFinished: handleOnFinished,
          onWebResourceError: (WebResourceError error) {
            // setState(() {
            //   hasInternet = true;
            // });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          'https://slanguageapp.website/',
          // 'https://slanguageapp.website/androide',
          // 'http://192.168.80.99/ARED/WiFI-Captive_Portal/land-webview.php?res=ready',
        ),
      );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Language App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: FutureBuilder(
          future: InternetConnectionChecker().hasConnection,
          builder: (context, snapshot) {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(color: Colors.white),
              child: snapshot.data == false
                  ? const NoInternetView()
                  : WebViewWidget(controller: controller),
            );
          },
        ),
      ),
    );
  }
}
