import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ThemeData/GlobalThemeData.dart';
import 'router/navigation.dart';
import 'ScrollView/imageSlider.dart';
import 'ScrollView/scrollview_img.dart';
import 'Local_Storage/shared_preferences.dart';
import 'pages/Article/article_details.dart';
import 'pages/users/edit_profile_page.dart';
import 'pages/users/favorites_page.dart';
import 'pages/users/privacy_page.dart';
import 'pages/users/About_page.dart';
import 'pages/login/login.dart';
import 'SplashScreen.dart';

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
        home: SplashScreen(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // notifyListeners();
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
  HomePageState createState() => HomePageState();
  const HomePage({super.key});
}

class HomePageState extends State<HomePage> {
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
        padding: EdgeInsets.zero,
        child: CustomScrollView(
          slivers: [
            // 使用 SliverToBoxAdapter 代替 SliverAppBar 来显示图片轮播和手势
            SliverToBoxAdapter(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      navigateToPages(
                        context,
                        () => ScrollviewImgPage(),
                        SlideDirection.right,
                      );
                    },
                    child: ImageSlider(imageUrls: imageUrls),
                  ),
                ],
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              final article = Articles[index];
              return ArticleCard(article: article);
            }, childCount: Articles.length))
          ],
        ),
      ),
    );
  }
}

// 文章卡片布局
class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        child: Container(
          height: 160,
          child: ListTile(
            title: Text.rich(TextSpan(children: [
              TextSpan(
                text: '${article.title}   ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextSpan(
                text: article.author,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ])),
            subtitle: Text(article.Main_body,
                maxLines: 5, overflow: TextOverflow.ellipsis),
            isThreeLine: true,
            onTap: () {
              navigateToPages(
                  context,
                  () => ArticleDetails(
                        article: article,
                      ),
                  SlideDirection.right);
            },
          ),
        ));
  }
}

// 个人页布局
class PersonalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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

class Article {
  final String title;
  final String author;
  final String Main_body;

  Article({
    required this.title,
    required this.author,
    required this.Main_body,
  });
}

final List<Article> Articles = [
  Article(
      title: 'Python开发',
      author: 'hanlei',
      Main_body: '''Python 是一个高层次的结合了解释性、编译性、互动性和面向对象的脚本语言。

Python 的设计具有很强的可读性，相比其他语言经常使用英文关键字，其他语言的一些标点符号，它具有比其他语言更有特色语法结构。

Python 是一种解释型语言： 这意味着开发过程中没有了编译这个环节。类似于PHP和Perl语言。

Python 是交互式语言： 这意味着，您可以在一个 Python 提示符 >>> 后直接执行代码。

Python 是面向对象语言: 这意味着Python支持面向对象的风格或代码封装在对象的编程技术。

Python 是初学者的语言：Python 对初级程序员而言，是一种伟大的语言，它支持广泛的应用程序开发，从简单的文字处理到 WWW 浏览器再到游戏。


Python 发展历史
Python 是由 Guido van Rossum 在八十年代末和九十年代初，在荷兰国家数学和计算机科学研究所设计出来的。

Python 本身也是由诸多其他语言发展而来的,这包括 ABC、Modula-3、C、C++、Algol-68、SmallTalk、Unix shell 和其他的脚本语言等等。

像 Perl 语言一样，Python 源代码同样遵循 GPL(GNU General Public License)协议。

现在 Python 是由一个核心开发团队在维护，Guido van Rossum 仍然占据着至关重要的作用，指导其进展。

Python 2.7 被确定为最后一个 Python 2.x 版本，它除了支持 Python 2.x 语法外，还支持部分 Python 3.1 语法。


Python 特点
1.易于学习：Python 有相对较少的关键字，结构简单，和一个明确定义的语法，学习起来更加简单。

2.易于阅读：Python 代码定义的更清晰。

3.易于维护：Python的 成功在于它的源代码是相当容易维护的。

4.一个广泛的标准库：Python 的最大的优势之一是丰富的库，跨平台的，在 UNIX、Windows 和 Mac 兼容很好。

5.互动模式：互动模式的支持，您可以从终端输入执行代码并获得结果的语言，互动的测试和调试代码片段。

6.可移植：基于其开放源代码的特性，Python 已经被移植（也就是使其工作）到许多平台。

7.可扩展：如果你需要一段运行很快的关键代码，或者是想要编写一些不愿开放的算法，你可以使用 C 或 C++ 完成那部分程序，然后从你的 Python 程序中调用。

8.数据库：Python 提供所有主要的商业数据库的接口。

9.GUI 编程：Python 支持 GUI 可以创建和移植到许多系统调用。

10.可嵌入: 你可以将 Python 嵌入到 C/C++ 程序，让你的程序的用户获得"脚本化"的能力。'''),
  Article(
      title: 'Java开发',
      author: 'hanlei',
      Main_body:
          '''Java 是由 Sun Microsystems 公司于 1995 年 5 月推出的 Java 面向对象程序设计语言和 Java 平台的总称。由 James Gosling和同事们共同研发，并在 1995 年正式推出。

后来 Sun 公司被 Oracle （甲骨文）公司收购，Java 也随之成为 Oracle 公司的产品。

Java分为三个体系：

JavaSE（J2SE）（Java2 Platform Standard Edition，java平台标准版）
JavaEE(J2EE)(Java 2 Platform,Enterprise Edition，java平台企业版)
JavaME(J2ME)(Java 2 Platform Micro Edition，java平台微型版)。
2005 年 6 月，JavaOne 大会召开，SUN 公司公开 Java SE 6。此时，Java 的各种版本已经更名，以取消其中的数字 "2"：J2EE 更名为 Java EE，J2SE 更名为Java SE，J2ME 更名为 Java ME。

主要特性
Java 语言是简单的：

Java 语言的语法与 C 语言和 C++ 语言很接近，使得大多数程序员很容易学习和使用。另一方面，Java 丢弃了 C++ 中很少使用的、很难理解的、令人迷惑的那些特性，如操作符重载、多继承、自动的强制类型转换。特别地，Java 语言不使用指针，而是引用。并提供了自动分配和回收内存空间，使得程序员不必为内存管理而担忧。

Java 语言是面向对象的：

Java 语言提供类、接口和继承等面向对象的特性，为了简单起见，只支持类之间的单继承，但支持接口之间的多继承，并支持类与接口之间的实现机制（关键字为 implements）。Java 语言全面支持动态绑定，而 C++语言只对虚函数使用动态绑定。总之，Java语言是一个纯的面向对象程序设计语言。

Java语言是分布式的：

Java 语言支持 Internet 应用的开发，在基本的 Java 应用编程接口中有一个网络应用编程接口（java net），它提供了用于网络应用编程的类库，包括 URL、URLConnection、Socket、ServerSocket 等。Java 的 RMI（远程方法激活）机制也是开发分布式应用的重要手段。

Java 语言是健壮的：
Java 的强类型机制、异常处理、垃圾的自动收集等是 Java 程序健壮性的重要保证。对指针的丢弃是 Java 的明智选择。Java 的安全检查机制使得 Java 更具健壮性。

Java语言是安全的：

Java通常被用在网络环境中，为此，Java 提供了一个安全机制以防恶意代码的攻击。除了Java 语言具有的许多安全特性以外，Java 对通过网络下载的类具有一个安全防范机制（类 ClassLoader），如分配不同的名字空间以防替代本地的同名类、字节代码检查，并提供安全管理机制（类 SecurityManager）让 Java 应用设置安全哨兵。

Java 语言是体系结构中立的：

Java 程序（后缀为 java 的文件）在 Java 平台上被编译为体系结构中立的字节码格式（后缀为 class 的文件），然后可以在实现这个 Java 平台的任何系统中运行。这种途径适合于异构的网络环境和软件的分发。

Java 语言是可移植的：

这种可移植性来源于体系结构中立性，另外，Java 还严格规定了各个基本数据类型的长度。Java 系统本身也具有很强的可移植性，Java 编译器是用 Java 实现的，Java 的运行环境是用 ANSI C 实现的。

Java 语言是解释型的：

如前所述，Java 程序在 Java 平台上被编译为字节码格式，然后可以在实现这个 Java 平台的任何系统中运行。在运行时，Java 平台中的 Java 解释器对这些字节码进行解释执行，执行过程中需要的类在联接阶段被载入到运行环境中。

Java 是高性能的：

与那些解释型的高级脚本语言相比，Java 的确是高性能的。事实上，Java 的运行速度随着 JIT(Just-In-Time）编译器技术的发展越来越接近于 C++。

Java 语言是多线程的：

在 Java 语言中，线程是一种特殊的对象，它必须由 Thread 类或其子（孙）类来创建。通常有两种方法来创建线程：其一，使用型构为 Thread(Runnable) 的构造子类将一个实现了 Runnable 接口的对象包装成一个线程，其二，从 Thread 类派生出子类并重写 run 方法，使用该子类创建的对象即为线程。值得注意的是 Thread 类已经实现了 Runnable 接口，因此，任何一个线程均有它的 run 方法，而 run 方法中包含了线程所要运行的代码。线程的活动由一组方法来控制。Java 语言支持多个线程的同时执行，并提供多线程之间的同步机制（关键字为 synchronized）。

Java 语言是动态的：

Java 语言的设计目标之一是适应于动态变化的环境。Java 程序需要的类能够动态地被载入到运行环境，也可以通过网络来载入所需要的类。这也有利于软件的升级。另外，Java 中的类有一个运行时刻的表示，能进行运行时刻的类型检查。

发展历史
1995 年 5 月 23 日，Java 语言诞生
1996 年 1 月，第一个 JDK-JDK1.0 诞生
1996 年 4 月，10 个最主要的操作系统供应商申明将在其产品中嵌入 JAVA 技术
1996 年 9 月，约 8.3 万个网页应用了 JAVA 技术来制作
1997 年 2 月 18 日，JDK1.1 发布
1997 年 4 月 2 日，JavaOne 会议召开，参与者逾一万人，创当时全球同类会议规模之纪录
1997 年 9 月，JavaDeveloperConnection 社区成员超过十万
1998 年 2 月，JDK1.1 被下载超过 2,000,000次
1998 年 12 月 8 日，JAVA2 企业平台 J2EE 发布
1999 年 6月，SUN 公司发布 Java 的三个版本：标准版（JavaSE, 以前是 J2SE）、企业版（JavaEE 以前是 J2EE）和微型版（JavaME，以前是 J2ME）
2000 年 5 月 8 日，JDK1.3 发布
2000 年 5 月 29 日，JDK1.4 发布
2001 年 6 月 5 日，NOKIA 宣布，到 2003 年将出售 1 亿部支持 Java 的手机
2001 年 9 月 24 日，J2EE1.3 发布
2002 年 2 月 26 日，J2SE1.4 发布，自此 Java 的计算能力有了大幅提升
2004 年 9 月 30 日 18:00PM，J2SE1.5 发布，成为 Java 语言发展史上的又一里程碑。为了表示该版本的重要性，J2SE1.5 更名为 Java SE 5.0
2005 年 6 月，JavaOne 大会召开，SUN 公司公开 Java SE 6。此时，Java 的各种版本已经更名，以取消其中的数字 "2"：J2EE 更名为 Java EE，J2SE 更名为 Java SE，J2ME 更名为 Java ME
2006 年 12 月，SUN 公司发布 JRE6.0
2009 年 04 月 20 日，甲骨文 74 亿美元收购 Sun，取得 Java 的版权。
2010 年 11 月，由于甲骨文对于 Java 社区的不友善，因此 Apache 扬言将退出 JCP。
2011 年 7 月 28 日，甲骨文发布 Java7.0 的正式版。
2014 年 3 月 18 日，Oracle 公司发表 Java SE 8。
2017 年 9 月 21 日，Oracle 公司发表 Java SE 9
2018 年 3 月 21 日，Oracle 公司发表 Java SE 10
2018 年 9 月 25 日，Java SE 11 发布
2019 年 3 月 20 日，Java SE 12 发布'''),
  Article(
      title: 'NodeJS开发', author: 'hanlei', Main_body: '''这是小白的零基础JavaScript全栈教程。

JavaScript是世界上最流行的脚本语言，因为你在电脑、手机、平板上浏览的所有的网页，以及无数基于HTML5的手机App，交互逻辑都是由JavaScript驱动的。

简单地说，JavaScript是一种运行在浏览器中的解释型的编程语言。

那么问题来了，为什么我们要学JavaScript？尤其是当你已经掌握了某些其他编程语言如Java、C++的情况下。

简单粗暴的回答就是：因为你没有选择。在Web世界里，只有JavaScript能跨平台、跨浏览器驱动网页，与用户交互。

Flash背后的ActionScript曾经流行过一阵子，不过随着移动应用的兴起，没有人用Flash开发手机App，所以它目前已经边缘化了。相反，随着HTML5在PC和移动端越来越流行，JavaScript变得更加重要了。并且，新兴的Node.js把JavaScript引入到了服务器端，JavaScript已经变成了全能型选手。

JavaScript一度被认为是一种玩具编程语言，它有很多缺陷，所以不被大多数后端开发人员所重视。很多人认为，写JavaScript代码很简单，并且JavaScript只是为了在网页上添加一点交互和动画效果。

但这是完全错误的理解。JavaScript确实很容易上手，但其精髓却不为大多数开发人员所熟知。编写高质量的JavaScript代码更是难上加难。

一个合格的开发人员应该精通JavaScript和其他编程语言。如果你已经掌握了其他编程语言，或者你还什么都不会，请立刻开始学习JavaScript，不要被Web时代所淘汰。'''),
  Article(
      title: 'Flutter开发',
      author: 'hanlei',
      Main_body:
          '''Flutter Widget采用现代响应式框架构建，这是从 React 中获得的灵感，中心思想是用widget构建你的UI。 Widget描述了他们的视图在给定其当前配置和状态时应该看起来像什么。当widget的状态发生变化时，widget会重新构建UI，Flutter会对比前后变化的不同， 以确定底层渲染树从一个状态转换到下一个状态所需的最小更改（译者语：类似于React/Vue中虚拟DOM的diff算法）。

注意: 如果您想通过代码来深入了解Flutter，请查看 构建Flutter布局 和 为Flutter App添加交互功能。

Hello World
一个最简单的Flutter应用程序，只需一个widget即可！如下面示例：将一个widget传给runApp函数即可：

import 'package:flutter/material.dart';

void main() {
  runApp(
    new Center(
      child: new Text(
        'Hello, world!',
        textDirection: TextDirection.ltr,
      ),
    ),
  );
}
该runApp函数接受给定的Widget并使其成为widget树的根。 在此示例中，widget树由两个widget:Center(及其子widget)和Text组成。框架强制根widget覆盖整个屏幕，这意味着文本“Hello, world”会居中显示在屏幕上。文本显示的方向需要在Text实例中指定，当使用MaterialApp时，文本的方向将自动设定，稍后将进行演示。

在编写应用程序时，通常会创建新的widget，这些widget是无状态的StatelessWidget或者是有状态的StatefulWidget， 具体的选择取决于您的widget是否需要管理一些状态。widget的主要工作是实现一个build函数，用以构建自身。一个widget通常由一些较低级别widget组成。Flutter框架将依次构建这些widget，直到构建到最底层的子widget时，这些最低层的widget通常为RenderObject，它会计算并描述widget的几何形状。

基础 Widget
主要文章: widget概述-布局模型

Flutter有一套丰富、强大的基础widget，其中以下是很常用的：

Text：该 widget 可让创建一个带格式的文本。

Row、 Column： 这些具有弹性空间的布局类Widget可让您在水平（Row）和垂直（Column）方向上创建灵活的布局。其设计是基于web开发中的Flexbox布局模型。

Stack： 取代线性布局 (译者语：和Android中的LinearLayout相似)，Stack允许子 widget 堆叠， 你可以使用 Positioned 来定位他们相对于Stack的上下左右四条边的位置。Stacks是基于Web开发中的绝度定位（absolute positioning )布局模型设计的。

Container： Container 可让您创建矩形视觉元素。container 可以装饰为一个BoxDecoration, 如 background、一个边框、或者一个阴影。 Container 也可以具有边距（margins）、填充(padding)和应用于其大小的约束(constraints)。另外， Container可以使用矩阵在三维空间中对其进行变换。

以下是一些简单的Widget，它们可以组合出其它的Widget：

import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  MyAppBar({this.title});

  // Widget子类中的字段往往都会定义为"final"

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 56.0, // 单位是逻辑上的像素（并非真实的像素，类似于浏览器中的像素）
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: new BoxDecoration(color: Colors.blue[500]),
      // Row 是水平方向的线性布局（linear layout）
      child: new Row(
        //列表项的类型是 <Widget>
        children: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            tooltip: 'Navigation menu',
            onPressed: null, // null 会禁用 button
          ),
          // Expanded expands its child to fill the available space.
          new Expanded(
            child: title,
          ),
          new IconButton(
            icon: new Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Material 是UI呈现的“一张纸”
    return new Material(
      // Column is 垂直方向的线性布局.
      child: new Column(
        children: <Widget>[
          new MyAppBar(
            title: new Text(
              'Example title',
              style: Theme.of(context).primaryTextTheme.title,
            ),
          ),
          new Expanded(
            child: new Center(
              child: new Text('Hello, world!'),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(new MaterialApp(
    title: 'My app', // used by the OS task switcher
    home: new MyScaffold(),
  ));
}
请确保在pubspec.yaml文件中，将flutter的值设置为：uses-material-design: true。这允许我们可以使用一组预定义Material icons。

name: my_app
flutter:
  uses-material-design: true
为了继承主题数据，widget需要位于MaterialApp内才能正常显示， 因此我们使用MaterialApp来运行该应用。

在MyAppBar中创建一个Container，高度为56像素（像素单位独立于设备，为逻辑像素），其左侧和右侧均有8像素的填充。在容器内部， MyAppBar使用Row 布局来排列其子项。 中间的title widget被标记为Expanded, ，这意味着它会填充尚未被其他子项占用的的剩余可用空间。Expanded可以拥有多个children， 然后使用flex参数来确定他们占用剩余空间的比例。

MyScaffold 通过一个Column widget，在垂直方向排列其子项。在Column的顶部，放置了一个MyAppBar实例，将一个Text widget作为其标题传递给应用程序栏。将widget作为参数传递给其他widget是一种强大的技术，可以让您创建各种复杂的widget。最后，MyScaffold使用了一个Expanded来填充剩余的空间，正中间包含一条message。

使用 Material 组件
主要文章: Widgets 总览 - Material 组件

Flutter提供了许多widgets，可帮助您构建遵循Material Design的应用程序。Material应用程序以MaterialApp widget开始， 该widget在应用程序的根部创建了一些有用的widget，其中包括一个Navigator， 它管理由字符串标识的Widget栈（即页面路由栈）。Navigator可以让您的应用程序在页面之间的平滑的过渡。 是否使用MaterialApp完全是可选的，但是使用它是一个很好的做法。

import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: 'Flutter Tutorial',
    home: new TutorialHome(),
  ));
}

class TutorialHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Scaffold是Material中主要的布局组件.
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title: new Text('Example title'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
      //body占屏幕的大部分
      body: new Center(
        child: new Text('Hello, world!'),
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: new Icon(Icons.add),
        onPressed: null,
      ),
    );
  }
}
现在我们已经从MyAppBar和MyScaffold切换到了AppBar和 Scaffold widget， 我们的应用程序现在看起来已经有一些“Material”了！例如，应用栏有一个阴影，标题文本会自动继承正确的样式。我们还添加了一个浮动操作按钮，以便进行相应的操作处理。

请注意，我们再次将widget作为参数传递给其他widget。该 Scaffold widget 需要许多不同的widget的作为命名参数，其中的每一个被放置在Scaffold布局中相应的位置。 同样，AppBar 中，我们给参数leading、actions、title分别传一个widget。 这种模式在整个框架中会经常出现，这也可能是您在设计自己的widget时会考虑到一点。

处理手势
主要文章: Flutter中的手势

大多数应用程序包括某种形式与系统的交互。构建交互式应用程序的第一步是检测输入手势。让我们通过创建一个简单的按钮来了解它的工作原理：

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        print('MyButton was tapped!');
      },
      child: new Container(
        height: 36.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: new Center(
          child: new Text('Engage'),
        ),
      ),
    );
  }
}
该GestureDetector widget并不具有显示效果，而是检测由用户做出的手势。 当用户点击Container时， GestureDetector会调用它的onTap回调， 在回调中，将消息打印到控制台。您可以使用GestureDetector来检测各种输入手势，包括点击、拖动和缩放。

许多widget都会使用一个GestureDetector为其他widget提供可选的回调。 例如，IconButton、 RaisedButton、 和FloatingActionButton ，它们都有一个onPressed回调，它会在用户点击该widget时被触发。

根据用户输入改变widget
主要文章: StatefulWidget, State.setState

到目前为止，我们只使用了无状态的widget。无状态widget从它们的父widget接收参数， 它们被存储在final型的成员变量中。 当一个widget被要求构建时，它使用这些存储的值作为参数来构建widget。

为了构建更复杂的体验 - 例如，以更有趣的方式对用户输入做出反应 - 应用程序通常会携带一些状态。 Flutter使用StatefulWidgets来满足这种需求。StatefulWidgets是特殊的widget，它知道如何生成State对象，然后用它来保持状态。 思考下面这个简单的例子，其中使用了前面提到RaisedButton：

class Counter extends StatefulWidget {
  // This class is the configuration for the state. It holds the
  // values (in this nothing) provided by the parent and used by the build
  // method of the State. Fields in a Widget subclass are always marked "final".

  @override
  _CounterState createState() => new _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      // This call to setState tells the Flutter framework that
      // something has changed in this State, which causes it to rerun
      // the build method below so that the display can reflect the
      // updated values. If we changed _counter without calling
      // setState(), then the build method would not be called again,
      // and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance
    // as done by the _increment method above.
    // The Flutter framework has been optimized to make rerunning
    // build methods fast, so that you can just rebuild anything that
    // needs updating rather than having to individually change
    // instances of widgets.
    return new Row(
      children: <Widget>[
        new RaisedButton(
          onPressed: _increment,
          child: new Text('Increment'),
        ),
        new Text('Count:'),
      ],
    );
  }
}
您可能想知道为什么StatefulWidget和State是单独的对象。在Flutter中，这两种类型的对象具有不同的生命周期： Widget是临时对象，用于构建当前状态下的应用程序，而State对象在多次调用build()之间保持不变，允许它们记住信息(状态)。

上面的例子接受用户点击，并在点击时使_counter自增，然后直接在其build方法中使用_counter值。在更复杂的应用程序中，widget结构层次的不同部分可能有不同的职责； 例如，一个widget可能呈现一个复杂的用户界面，其目标是收集特定信息（如日期或位置），而另一个widget可能会使用该信息来更改整体的显示。

在Flutter中，事件流是“向上”传递的，而状态流是“向下”传递的（译者语：这类似于React/Vue中父子组件通信的方式：子widget到父widget是通过事件通信，而父到子是通过状态），重定向这一流程的共同父元素是State。让我们看看这个稍微复杂的例子是如何工作的：

class CounterDisplay extends StatelessWidget {
  CounterDisplay({this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return new Text('Count: ');
  }
}

class CounterIncrementor extends StatelessWidget {
  CounterIncrementor({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      onPressed: onPressed,
      child: new Text('Increment'),
    );
  }
}

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => new _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      ++_counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: <Widget>[
      new CounterIncrementor(onPressed: _increment),
      new CounterDisplay(count: _counter),
    ]);
  }
}
注意我们是如何创建了两个新的无状态widget的！我们清晰地分离了 显示 计数器（CounterDisplay）和 更改 计数器（CounterIncrementor）的逻辑。 尽管最终效果与前一个示例相同，但责任分离允许将复杂性逻辑封装在各个widget中，同时保持父项的简单性。

整合所有
让我们考虑一个更完整的例子，将上面介绍的概念汇集在一起​​。我们假设一个购物应用程序，该应用程序显示出售的各种产品，并维护一个购物车。 我们先来定义ShoppingListItem：

class Product {
  const Product({this.name});
  final String name;
}

typedef void CartChangedCallback(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({Product product, this.inCart, this.onCartChanged})
      : product = product,
        super(key: new ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different parts of the tree
    // can have different themes.  The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return new TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: () {
        onCartChanged(product, !inCart);
      },
      leading: new CircleAvatar(
        backgroundColor: _getColor(context),
        child: new Text(product.name[0]),
      ),
      title: new Text(product.name, style: _getTextStyle(context)),
    );
  }
}
该ShoppingListItem widget是无状态的。它将其在构造函​​数中接收到的值存储在final成员变量中，然后在build函数中使用它们。 例如，inCart布尔值表示在两种视觉展示效果之间切换：一个使用当前主题的主色，另一个使用灰色。

当用户点击列表项时，widget不会直接修改其inCart的值。相反，widget会调用其父widget给它的onCartChanged回调函数。 此模式可让您在widget层次结构中存储更高的状态，从而使状态持续更长的时间。在极端情况下，存储传给runApp应用程序的widget的状态将在的整个生命周期中持续存在。

当父项收到onCartChanged回调时，父项将更新其内部状态，这将触发父项使用新inCart值重建ShoppingListItem新实例。 虽然父项ShoppingListItem在重建时创建了一个新实例，但该操作开销很小，因为Flutter框架会将新构建的widget与先前构建的widget进行比较，并仅将差异部分应用于底层RenderObject。

我们来看看父widget存储可变状态的示例：

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.products}) : super(key: key);

  final List<Product> products;

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework will re-use the State object
  // instead of creating a new State object.

  @override
  _ShoppingListState createState() => new _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = new Set<Product>();

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      // When user changes what is in the cart, we need to change _shoppingCart
      // inside a setState call to trigger a rebuild. The framework then calls
      // build, below, which updates the visual appearance of the app.

      if (inCart)
        _shoppingCart.add(product);
      else
        _shoppingCart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Shopping List'),
      ),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: widget.products.map((Product product) {
          return new ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product),
            onCartChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(new MaterialApp(
    title: 'Shopping App',
    home: new ShoppingList(
      products: <Product>[
        new Product(name: 'Eggs'),
        new Product(name: 'Flour'),
        new Product(name: 'Chocolate chips'),
      ],
    ),
  ));
}
ShoppingList类继承自StatefulWidget，这意味着这个widget可以存储状态。 当ShoppingList首次插入到树中时，框架会调用其 createState 函数以创建一个新的_ShoppingListState实例来与该树中的相应位置关联（请注意，我们通常命名State子类时带一个下划线，这表示其是私有的）。 当这个widget的父级重建时，父级将创建一个新的ShoppingList实例，但是Flutter框架将重用已经在树中的_ShoppingListState实例，而不是再次调用createState创建一个新的。

要访问当前ShoppingList的属性，_ShoppingListState可以使用它的widget属性。 如果父级重建并创建一个新的ShoppingList，那么 _ShoppingListState也将用新的widget值重建（译者语：这里原文档有错误，应该是_ShoppingListState不会重新构建，但其widget的属性会更新为新构建的widget）。 如果希望在widget属性更改时收到通知，则可以覆盖didUpdateWidget函数，以便将旧的oldWidget与当前widget进行比较。

处理onCartChanged回调时，_ShoppingListState通过添加或删除产品来改变其内部_shoppingCart状态。 为了通知框架它改变了它的内部状态，需要调用setState。调用setState将该widget标记为”dirty”(脏的)，并且计划在下次应用程序需要更新屏幕时重新构建它。 如果在修改widget的内部状态后忘记调用setState，框架将不知道您的widget是”dirty”(脏的)，并且可能不会调用widget的build方法，这意味着用户界面可能不会更新以展示新的状态。

通过以这种方式管理状态，您不需要编写用于创建和更新子widget的单独代码。相反，您只需实现可以处理这两种情况的build函数。

响应widget生命周期事件
主要文章: State

在StatefulWidget调用createState之后，框架将新的状态对象插入树中，然后调用状态对象的initState。 子类化State可以重写initState，以完成仅需要执行一次的工作。 例如，您可以重写initState以配置动画或订阅platform services。initState的实现中需要调用super.initState。

当一个状态对象不再需要时，框架调用状态对象的dispose。 您可以覆盖该dispose方法来执行清理工作。例如，您可以覆盖dispose取消定时器或取消订阅platform services。 dispose典型的实现是直接调用super.dispose。

Key
主要文章: Key_

您可以使用key来控制框架将在widget重建时与哪些其他widget匹配。默认情况下，框架根据它们的runtimeType和它们的显示顺序来匹配。 使用key时，框架要求两个widget具有相同的key和runtimeType。

Key在构建相同类型widget的多个实例时很有用。例如，ShoppingList构建足够的ShoppingListItem实例以填充其可见区域：

如果没有key，当前构建中的第一个条目将始终与前一个构建中的第一个条目同步，即使在语义上，列表中的第一个条目如果滚动出屏幕，那么它将不会再在窗口中可见。

通过给列表中的每个条目分配为“语义” key，无限列表可以更高效，因为框架将同步条目与匹配的语义key并因此具有相似（或相同）的可视外观。 此外，语义上同步条目意味着在有状态子widget中，保留的状态将附加到相同的语义条目上，而不是附加到相同数字位置上的条目。

全局 Key
主要文章: GlobalKey

您可以使用全局key来唯一标识子widget。全局key在整个widget层次结构中必须是全局唯一的，这与局部key不同，后者只需要在同级中唯一。由于它们是全局唯一的，因此可以使用全局key来检索与widget关联的状态。'''),
  Article(
      title: 'Go开发',
      author: 'hanlei',
      Main_body: '''Go 是一个开源的编程语言，它能让构造简单、可靠且高效的软件变得容易。

Go是从2007年末由Robert Griesemer, Rob Pike, Ken Thompson主持开发，后来还加入了Ian Lance Taylor, Russ Cox等人，并最终于2009年11月开源，在2012年早些时候发布了Go 1稳定版本。现在Go的开发已经是完全开放的，并且拥有一个活跃的社区。

Go 语言特色
简洁、快速、安全
并行、有趣、开源
内存管理、数组安全、编译迅速
Go 语言用途
Go 语言被设计成一门应用于搭载 Web 服务器，存储集群或类似用途的巨型中央服务器的系统编程语言。

对于高性能分布式系统领域而言，Go 语言无疑比大多数其它语言有着更高的开发效率。它提供了海量并行的支持，这对于游戏服务端的开发而言是再好不过了。

第一个 Go 程序
接下来我们来编写第一个 Go 程序 hello.go（Go 语言源文件的扩展是 .go），代码如下：

hello.go 文件
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}

运行实例 »
要执行 Go 语言代码可以使用 go run 命令。

执行以上代码输出:

 go run hello.go 
Hello, World!
此外我们还可以使用 go build 命令来生成二进制文件：

 go build hello.go 
 ls
hello    hello.go
 ./hello 
Hello, World!'''),
];
