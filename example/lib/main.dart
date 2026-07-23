import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. 申请安卓系统麦克风权限
  await Permission.microphone.request();

  // 2. 初始化并开启后台保活前台服务（防止切后台被系统杀掉麦克风）
  const androidConfig = FlutterBackgroundAndroidResource(
    notificationTitle: "会议系统后台运行中",
    notificationText: "麦克风正在后台持续传输声音",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'),
  );

  bool hasPermissions = await FlutterBackground.initialize(androidConfig: androidConfig);
  if (hasPermissions) {
    await FlutterBackground.enableBackgroundExecution();
  }

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
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://xzscl.duckdns.org'));
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
