import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
// 引入 Android 专属控件以支持网页权限放行
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. 动态申请安卓原生麦克风权限
  await Permission.microphone.request();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MeetingWebApp(),
  ));
}

class MeetingWebApp extends StatefulWidget {
  const MeetingWebApp({super.key});

  @override
  State<MeetingWebApp> createState() => _MeetingWebAppState();
}

class _MeetingWebAppState extends State<MeetingWebApp> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://xzscl.duckdns.org'));

    // 2. 关键代码：自动放行网页（H5）发起的麦克风/摄像头请求
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setOnPlatformPermissionRequest(
        (AndroidWebViewPermissionRequest request) {
          request.grant(); // 自动批准 H5 网页的麦克风请求
        },
      );
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
