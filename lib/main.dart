import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/pages/start_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 获取屏幕宽高
  final data = WidgetsBinding.instance.window.physicalSize;
  final width = data.width;
  final height = data.height;

  // 如果是手机（宽 < 高），强制横屏
  if (width < height) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    // 平板或大屏，竖屏也可以
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StartPage(),
    );
  }
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: '点击计数器', home: CounterPage());
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  bool maxTip = false;
  bool removeBtn = true;

  void _incrementCounter() {
    setState(() {
      _counter++; // 每次点击加1
      edgeJudge();
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
      edgeJudge();
    });
  }

  void edgeJudge() {
    if (_counter >= 10) {
      maxTip = true;
    } else {
      maxTip = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('点击计数')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            !maxTip
                ? Text('你已经点击了：', style: TextStyle(fontSize: 18))
                : SizedBox(),
            !maxTip
                ? Text(
                    '$_counter 次',
                    style: TextStyle(fontSize: 32, color: Colors.amber),
                  )
                : SizedBox(),
            maxTip
                ? Text(
                    "不能再加啦！",
                    style: TextStyle(fontSize: 32, color: Colors.deepOrange),
                  )
                : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0.0,
            left: 32.0,
            child: FloatingActionButton(
              heroTag: 'decrement',
              onPressed: _counter > 0 ? _decrementCounter : null,
              backgroundColor: _counter > 0
                  ? theme.floatingActionButtonTheme.backgroundColor
                  : Colors.grey,
              tooltip: '减少',
              child: Icon(Icons.remove),
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: FloatingActionButton(
              heroTag: 'increment',
              onPressed: _counter < 10 ? _incrementCounter : null,
              backgroundColor: _counter < 10
                  ? theme.floatingActionButtonTheme.backgroundColor
                  : Colors.grey,
              tooltip: '增加',
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
