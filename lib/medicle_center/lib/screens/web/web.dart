import 'dart:async';
import 'dart:io';

import 'package:united_natives/medicle_center/lib/models/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Web extends StatefulWidget {
  final WebViewModel? web;
  const Web({super.key, this.web});

  @override
  State<Web> createState() {
    return _WebState();
  }
}

class _WebState extends State<Web> {
  // final _cookieManager = CookieManager();

  bool _loadCompleted = false;
  bool _receiveCallback = false;
  String? _callbackResult;

  @override
  void initState() {
    super.initState();
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light);
    SVProgressHUD.show();
  }

  @override
  void dispose() {
    SVProgressHUD.dismiss();
    super.dispose();
  }

  void _onResult() {
    Navigator.pop(context, _callbackResult);
  }

  ///Clear Cookie
  Future<void> _clearCookie() async {
    if (Platform.isIOS) {
      await controller.clearCache();
    } else {
      // await _cookieManager.clearCookies();
    }
  }

  ///After load page finish
  void onPageFinished(String url) async {
    SVProgressHUD.dismiss();
    if (!_loadCompleted) {
      setState(() {
        _loadCompleted = true;
      });
    }

    ///Handle callback
    if (_callbackResult != null && !_receiveCallback) {
      await _clearCookie();
      _receiveCallback = true;
      _onResult();
    }
  }

  WebViewController controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.web!.title,
        ),
      ),
      body: IndexedStack(
        index: _loadCompleted ? 1 : 0,
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
          ),
          WebViewWidget(
            controller: controller
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(NavigationDelegate(
                onNavigationRequest: (request) {
                  for (var item in widget.web!.callbackUrl) {
                    if (request.url.contains(item)) {
                      _callbackResult = item;
                      break;
                    }
                  }
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  SVProgressHUD.show();
                },
                onPageFinished: onPageFinished,
              ))
              ..loadRequest(
                Uri.parse(
                  widget.web!.url.toString(),
                ),
              ),
          )
        ],
      ),
    );
  }
}
