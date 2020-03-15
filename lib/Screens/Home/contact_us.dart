import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactUs extends StatefulWidget {

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DSC RJIT"),
      ),
      body: WebView(
        
                  initialUrl: "https://dscrjit.co/team",
                  javascriptMode: JavascriptMode.unrestricted,
                )
,
    );
  }
}