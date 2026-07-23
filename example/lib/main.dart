import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. 打开 App 时先申请安卓系统麦克风权限
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

    // 创建 WebView 控制器
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://xzscl.duckdns.org'));

    // 2. 关键点：如果是 Android 平台，开启 WebView 的 H5 网页麦克风/摄像头权限自动放行
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setOnPlatformPermissionRequest(
        (AndroidWebViewPermissionRequest request) {
          // 自动批准 H5 网页发起的 AUDIO_CAPTURE（麦克风）请求
          request.grant();
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
