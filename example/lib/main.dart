import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'; // 改用 InAppWebView
import 'package:permission_handler/permission_handler.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri("https://xzscl.duckdns.org"),
          ),
          initialSettings: InAppWebViewSettings(
            // 允许网页自动播放声音和使用麦克风
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            // 允许 H5 权限请求
            useOnPermissionRequest: true,
          ),
          // 关键核心代码：自动批准 H5 网页发起的麦克风权限申请
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT,
            );
          },
        ),
      ),
    );
  }
}
