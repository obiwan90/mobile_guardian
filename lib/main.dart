import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '手机质量检测器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const IntroPage(),
    );
  }
}

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          parallaxPage(
              context, "assets/background_layer1.png", "检测手机性能", "保持设备的最佳状态"),
          parallaxPage(
              context, "assets/background_layer2.png", "高度安全", "保护您的数据隐私"),
        ],
      ),
    );
  }

  Widget parallaxPage(
      BuildContext context, String imagePath, String title, String subtitle) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 100,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                child: const Text("开始检测"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String deviceName = '未知';
  String deviceMemory = '未知';
  String deviceBrand = '未知';
  bool isDetecting = false;
  List<String> detectionItems = [
    "屏幕检测",
    "摄像头检测",
    "音频检测",
    "传感器检测",
    "电池检测",
    "网络检测",
    "存储检测",
    "GPS定位检测",
    "Wi-Fi信号强度检测",
    "蓝牙功能检测",
    "通话质量检测"
  ];

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceName = androidInfo.model ?? '未知';
        deviceMemory = androidInfo.systemFeatures.join(', ') ?? '未知';
        deviceBrand = androidInfo.brand ?? '未知';
      });
    } catch (e) {
      setState(() {
        deviceName = '不可读取设备信息';
        deviceMemory = '不可读取设备信息';
        deviceBrand = '不可读取设备信息';
      });
    }
  }

  void startDetectionProcess() {
    setState(() {
      isDetecting = true;
    });

    // Simulate detection process with a delay
    Future.forEach(detectionItems, (item) {
      return Future.delayed(const Duration(seconds: 1), () {
        print("检测完成: $item");
      });
    }).then((_) {
      // Once done
      setState(() {
        isDetecting = false;
      });
      // Navigate to results page or display detection results
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('首页'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "设备型号: $deviceName",
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              "内存信息: $deviceMemory",
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              "品牌: $deviceBrand",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isDetecting ? null : startDetectionProcess,
              child: isDetecting
                  ? const CircularProgressIndicator()
                  : const Text("开始检测"),
            ),
          ],
        ),
      ),
    );
  }
}
