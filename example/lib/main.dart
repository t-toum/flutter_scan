import 'package:example/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan/scan.dart';
import 'package:image_picker/image_picker.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String qrcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        "/": (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Plugin example app'),
              ),
              body: Center(
                child: Column(
                  children: [
                    Text('Running on: $_platformVersion\n'),
                    Wrap(
                      children: [
                        ElevatedButton(
                          child: const Text("parse from image"),
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                            if (image != null) {
                              String? str = await Scan.parse(image.path);
                              if (str != null) {
                                setState(() {
                                  qrcode = str;
                                });
                              }
                            }
                          },
                        ),
                        ElevatedButton(
                          child: const Text('go scan page'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) {
                                return ScanPage();
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                    Text('scan result is $qrcode'),
                  ],
                ),
              ),
            ),
      },
    );
  }
}
