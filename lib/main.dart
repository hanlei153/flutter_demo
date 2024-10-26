import 'dart:ffi';

import 'package:flutter/material.dart';
import 'ThemeData/GlobalThemeData.dart';
import 'package:provider/provider.dart';
import 'pages/users/edit_profile_page.dart';
import 'pages/users/favorites_page.dart';
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
        title: "Hanlei's app",
        themeMode: ThemeMode.dark,
        theme: GlobalThemData.darkThemeData,
        home: FutureBuilder<bool>(
          future: Local_Storage_Manager().getBool('isLoggedIn'),
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
    print(await Local_Storage_Manager().getBool('isFirstLogin'));
    if (await Local_Storage_Manager().getBool('isFirstLogin') == false) {
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
              navigateToPages(
                  context, () => EditProfilePage(), SlideDirection.right);
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
        padding: EdgeInsets.all(5),
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
  'https://bkimg.cdn.bcebos.com/pic/7acb0a46f21fbe098f88af1663600c338644adda?x-bce-process=image/format,f_auto/watermark,image_d2F0ZXIvYmFpa2UyNzI,g_7,xp_5,yp_5,P_20/resize,m_lfit,limit_1,h_1080',
  'https://bkimg.cdn.bcebos.com/pic/42a98226cffc1e178a82336014dae103738da9774305?x-bce-process=image/format,f_auto/watermark,image_d2F0ZXIvYmFpa2UyNzI,g_7,xp_5,yp_5,P_20/resize,m_lfit,limit_1,h_1080',
  'https://bkimg.cdn.bcebos.com/pic/4ec2d5628535e5dde711a2574b9eb0efce1b9c16c4b9?x-bce-process=image/format,f_auto/watermark,image_d2F0ZXIvYmFpa2UyNzI,g_7,xp_5,yp_5,P_20/resize,m_lfit,limit_1,h_1080',
  'https://pic.rmb.bdstatic.com/bjh/events/af82e92fce46bfbcec63962e1f035bc0416.jpeg@h_1280',
  'https://so1.360tres.com/t01ddf0b5233615bed1.jpg',
  'https://bkimg.cdn.bcebos.com/pic/b8014a90f603738d1db3766fb01bb051f919ec86?x-bce-process=image/format,f_auto/watermark,image_d2F0ZXIvYmFpa2UyNzI,g_7,xp_5,yp_5,P_20/resize,m_lfit,limit_1,h_1080',
  'https://x0.ifengimg.com/ucms/2021_11/5F71B0424440067AC277C513CE9C0791F236D1C9_size34_w640_h359.jpg',
  'https://bkimg.cdn.bcebos.com/pic/f9dcd100baa1cd114c6ec44cbd12c8fcc2ce2d85?x-bce-process=image/format,f_auto/watermark,image_d2F0ZXIvYmFpa2UyNzI,g_7,xp_5,yp_5,P_20/resize,m_lfit,limit_1,h_1080',
];

// 个人页布局
class PersonalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: IconButton(
            onPressed: () {
              navigateToPages(
                  context, () => EditProfilePage(), SlideDirection.left);
            },
            icon: Icon(Icons.menu),
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          ),
          actions: [
            IconButton(
              onPressed: () {
                navigateToPages(
                    context, () => EditProfilePage(), SlideDirection.right);
              },
              icon: Icon(Icons.edit),
            )
          ]),
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
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await Local_Storage_Manager()
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
              childCount: 2,
            ),
          ),
        ],
      ),
    );
  }
}
