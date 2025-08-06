import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trustdevice_pro_plugin/trustdevice_se_plugin.dart';

void main() {
  print(">>> App started"); // 查看控制台是否输出
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _trustdeviceSePlugin = TrustdeviceSePlugin();
  Future<void> _initWithOptions() async {
    //  var options = {
    //   "partner": "tongdun", // 需要替换成你自己的
    //   "appKey": "0d2e7e22f9737acbac739056aa23c738", // 需要替换成你自己的
    //   "appName": "App", // 需要替换成你自己的
    //   "country": "sg", // 需要替换成你自己的
    //   "debug": kDebugMode, // 上线时删除本行代码，防止应用被调试
    // };

    // 可用
    // var options = {
    //   "partner": "LPZ13", // 需要替换成你自己的
    //   "appKey": "a8b06ec77ad0b3ad80254701f4755941", // 需要替换成你自己的
    //   "appName": "App", // 需要替换成你自己的
    //   "country": "sg", // 需要替换成你自己的
    //   "debug": kDebugMode, // 上线时删除本行代码，防止应用被调试
    // };


    var options = {
      "partner": "LPZ_tddfse", // 需要替换成你自己的
      "appKey": "84baafd5810ddd090237252ed40b0027", // 需要替换成你自己的
      "appName": "App", // 需要替换成你自己的
      "country": "cn", // 需要替换成你自己的
      "debug": kDebugMode, // 上线时删除本行代码，防止应用被调试
    };
    //Anti debugging switch, used during development phase
    options["debug"] = true;
    _trustdeviceSePlugin.initWithOptions(options);
    
    // 1. 调用插件方法并接收结果
    try {
      Map<String, dynamic> resultData = await _trustdeviceSePlugin.getDeviceInfo();
      
      // 2. 解析返回的数据
      String fpVersion = resultData['fpVersion'] as String? ?? '';
      String blackBox = resultData['blackBox'] as String? ?? '';
      String anonymousId = resultData['anonymousId'] as String? ?? '';
      int deviceRiskScore = resultData['deviceRiskScore'] as int? ?? 0;
      String sealedResult = resultData['sealedResult'] as String? ?? '';
      
      // 3. 解析嵌套的apiStatus对象
      Map<String, dynamic> apiStatus = resultData['apiStatus'] as Map<String, dynamic>? ?? {};
      int statusCode = apiStatus['code'] as int? ?? -1;
      String statusMessage = apiStatus['message'] as String? ?? '';
      
      // 4. 使用解析后的数据
      print('''
      设备信息获取成功:
      FP版本: $fpVersion
      黑盒数据: $blackBox
      匿名ID: $anonymousId
      风险分数: $deviceRiskScore
      密封结果: $sealedResult
      API状态: $statusCode ($statusMessage)
    ''');
      
    } on PlatformException catch (e) {
      // 处理原生端返回的错误
      print('设备信息获取失败: ${e.code} - ${e.message}');
    } catch (e) {
      // 处理其他异常
      print('未知错误: $e');
    }   


  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    _initWithOptions();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
