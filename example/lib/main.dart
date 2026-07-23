import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. 启动时申请系统麦克风权限
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
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            useOnPermissionRequest: true,
          ),
          // 2. 核心：自动批准 H5 网页发起的麦克风权限（WebRTC）
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
