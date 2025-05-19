import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';

class RFHomeWebViewFragment extends StatefulWidget {
  @override
  _RFHomeWebViewFragmentState createState() => _RFHomeWebViewFragmentState();
}

class _RFHomeWebViewFragmentState extends State<RFHomeWebViewFragment> {
  late final WebViewController _controller;
  bool isLoading = true;
  
  final String officialWebsiteUrl = 'https://portal.unitec.edu/';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            toast('Error al cargar la página: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(officialWebsiteUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('En La Ceiba Web Oficial', style: boldTextStyle(color: white)),
        backgroundColor: rf_primaryColor,
        iconTheme: IconThemeData(color: white),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: white),
            onPressed: () => _controller.reload(),
          ),
          IconButton(
            icon: Icon(Icons.home, color: white),
            onPressed: () => _controller.loadRequest(Uri.parse(officialWebsiteUrl)),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: rf_primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}