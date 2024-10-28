import 'package:flutter/material.dart';
import 'ThemeData/GlobalThemeData.dart';
import 'package:provider/provider.dart';
import 'pages/users/edit_profile_page.dart';
import 'pages/users/favorites_page.dart';
import 'pages/users/privacy_page.dart';
import '/pages/users/About_page.dart';
import 'pages/login/login.dart';
import 'router/navigation.dart';
import 'ScrollView/imageSlider.dart';
import 'ScrollView/scrollview_img.dart';
import 'Local_Storage/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "my_app",
        themeMode: ThemeMode.dark,
        theme: GlobalThemData.darkThemeData,
        home: FutureBuilder<bool>(
          future: LocalStorageManager().getBool('isLoggedIn'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData && snapshot.data == true) {
              return MyHomePage();
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  notifyListeners();
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = PersonalPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 247, 245, 245),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

// 首页布局

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  const HomePage({super.key});
}

class _HomePageState extends State<HomePage> {
  bool isFirstLogin = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLogin();
  }

  Future<void> _checkFirstLogin() async {
    print(await LocalStorageManager().getBool('isFirstLogin'));
    if (await LocalStorageManager().getBool('isFirstLogin') == false) {
      @override
      final snackBar = SnackBar(
        content: Text(
          '请修改您的密码！',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        backgroundColor: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 圆角
        ),
        duration: Duration(seconds: 120),
        margin: EdgeInsets.all(10), // 设置 `SnackBar` 到屏幕边缘的距离
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
            label: '去修改',
            textColor: const Color.fromARGB(255, 240, 240, 238),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()));
            }),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  navigateToPages(
                      context, () => ScrollviewImgPage(), SlideDirection.right);
                },
                child: ImageSlider(imageUrls: imageUrls)),
          ],
        ),
      ),
    );
  }
}

final List<String> imageUrls = [
  'assets/兵马俑.webp',
  'assets/阿尔忒弥斯神庙.webp',
  'assets/奥林匹亚宙斯巨像.jpeg',
  'assets/空中花园.webp',
  'assets/罗德岛太阳神巨像.webp',
  'assets/金字塔.webp',
  'assets/摩索拉斯陵墓.jpg',
  'assets/亚历山大灯塔.jpg',
];

// 个人页布局
class PersonalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // title: IconButton(
        //   onPressed: () {
        //     navigateToPages(
        //         context, () => EditProfilePage(), SlideDirection.left);
        //   },
        //   icon: Icon(Icons.menu),
        //   padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
        // ),
        actions: [
          UnconstrainedBox(
            child: Padding(
              padding: EdgeInsets.only(right: 25),
              child: IconButton(
                onPressed: () {
                  navigateToPages(
                      context, () => EditProfilePage(), SlideDirection.right);
                },
                icon: Icon(Icons.menu),
              ),
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: null,
            centerTitle: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/image.png'),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '韩磊',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '153@163.com',
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
            expandedHeight: 180,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      navigateToPages(
                          context, () => FavoritesPage(), SlideDirection.right);
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 50, top: 30),
                      child: Text(
                        '收藏',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                } else if (index == 1) {
                  return GestureDetector(
                    onTap: () {
                      navigateToPages(
                          context, () => PrivacyPage(), SlideDirection.right);
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 50, top: 30),
                      child: Text(
                        '隐私协议',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                } else if (index == 2) {
                  return GestureDetector(
                    onTap: () {
                      navigateToPages(
                          context, () => AboutPage(), SlideDirection.right);
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 50, top: 30),
                      child: Text(
                        '关于',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                } else if (index == 3) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await LocalStorageManager()
                            .setBool('isLoggedIn', false);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                        // 执行注销操作的逻辑，比如清除用户数据并返回登录页面
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('注销', style: TextStyle(color: Colors.white)),
                    ),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.only(left: 50),
                    child: ListTile(title: Text('Item #$index')),
                  );
                }
              },
              childCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}
