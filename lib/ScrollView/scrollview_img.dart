import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class ExampleParallax extends StatelessWidget {
  const ExampleParallax({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            '世界八大奇迹',
            style: TextStyle(fontSize: 20),
          ),
          for (final location in locations)
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(location.Url);
                if (!await launchUrl(url,
                    mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              },
              child: LocationListItem(
                imageUrl: location.imageUrl,
                name: location.name,
                country: location.country,
              ),
            )
        ],
      ),
    );
  }
}

class LocationListItem extends StatelessWidget {
  LocationListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.country,
  });

  final String imageUrl;
  final String name;
  final String country;
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.asset(
          imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            country,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}

class Parallax extends SingleChildRenderObjectWidget {
  const Parallax({
    super.key,
    required Widget background,
  }) : super(child: background);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderParallax(scrollable: Scrollable.of(context));
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderParallax renderObject) {
    renderObject.scrollable = Scrollable.of(context);
  }
}

class ParallaxParentData extends ContainerBoxParentData<RenderBox> {}

class RenderParallax extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin {
  RenderParallax({
    required ScrollableState scrollable,
  }) : _scrollable = scrollable;

  ScrollableState _scrollable;

  ScrollableState get scrollable => _scrollable;

  set scrollable(ScrollableState value) {
    if (value != _scrollable) {
      if (attached) {
        _scrollable.position.removeListener(markNeedsLayout);
      }
      _scrollable = value;
      if (attached) {
        _scrollable.position.addListener(markNeedsLayout);
      }
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _scrollable.position.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollable.position.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! ParallaxParentData) {
      child.parentData = ParallaxParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // Force the background to take up all available width
    // and then scale its height based on the image's aspect ratio.
    final background = child!;
    final backgroundImageConstraints =
        BoxConstraints.tightFor(width: size.width);
    background.layout(backgroundImageConstraints, parentUsesSize: true);

    // Set the background's local offset, which is zero.
    (background.parentData as ParallaxParentData).offset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Get the size of the scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;

    // Calculate the global position of this list item.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final backgroundOffset =
        localToGlobal(size.centerLeft(Offset.zero), ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final scrollFraction =
        (backgroundOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final background = child!;
    final backgroundSize = background.size;
    final listItemSize = size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
        background,
        (background.parentData as ParallaxParentData).offset +
            offset +
            Offset(0.0, childRect.top));
  }
}

class ScrollviewImgPage extends StatelessWidget {
  const ScrollviewImgPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('列表详情'),
      ),
      body: Center(
        child: ExampleParallax(),
      ),
    );
  }
}

class Location {
  final String Url;
  final String imageUrl;
  final String name;
  final String country;

  Location(
      {required this.Url,
      required this.imageUrl,
      required this.name,
      required this.country});
}

final List<Location> locations = [
  Location(
    Url:
        'https://baike.baidu.com/item/%E8%83%A1%E5%A4%AB%E9%87%91%E5%AD%97%E5%A1%94/448327?lemmaFrom=lemma_starMap&fromModule=lemma_starMap&starNodeId=73c81632c23dff3d9026ddd3&lemmaIdFrom=147601',
    imageUrl: 'assets/金字塔.webp',
    name: '胡夫金字塔',
    country: '古埃及',
  ),
  Location(
    Url:
        "https://baike.baidu.com/item/%E7%A9%BA%E4%B8%AD%E8%8A%B1%E5%9B%AD/34908?lemmaFrom=lemma_starMap&fromModule=lemma_starMap&starNodeId=73c81632c23dff3d9026ddd3&lemmaIdFrom=147601",
    imageUrl: 'assets/空中花园.webp',
    name: '空中花园',
    country: '伊拉克',
  ),
  Location(
      Url:
          "https://baike.baidu.com/item/%E9%98%BF%E5%B0%94%E5%BF%92%E5%BC%A5%E6%96%AF%E7%A5%9E%E5%BA%99/669090?lemmaFrom=lemma_starMap&fromModule=lemma_starMap&starNodeId=73c81632c23dff3d9026ddd3&lemmaIdFrom=147601",
      imageUrl: 'assets/阿尔忒弥斯神庙.webp',
      name: '阿尔忒弥斯神庙',
      country: '希腊'),
  Location(
    Url:
        "https://baike.baidu.com/item/%E5%A5%A5%E6%9E%97%E5%8C%B9%E4%BA%9A%E5%AE%99%E6%96%AF%E5%B7%A8%E5%83%8F/7688845?structureClickId=7688845&structureId=73c81632c23dff3d9026ddd3&structureItemId=19986ed3cb3c7d3d663552f0&lemmaFrom=starMapContent_star&fromModule=starMap_content&lemmaIdFrom=147601",
    imageUrl: 'assets/奥林匹亚宙斯巨像.jpeg',
    name: '奥林匹亚宙斯巨像',
    country: '希腊',
  ),
  Location(
    Url:
        "https://baike.baidu.com/item/%E6%91%A9%E7%B4%A2%E6%8B%89%E6%96%AF%E9%99%B5%E5%A2%93/157895?structureClickId=157895&structureId=73c81632c23dff3d9026ddd3&structureItemId=e6d27944c4e0a9735dd29bcd&lemmaFrom=starMapContent_star&fromModule=starMap_content&lemmaIdFrom=147601",
    imageUrl: 'assets/摩索拉斯陵墓.jpg',
    name: '摩索拉斯陵墓',
    country: '土耳其',
  ),
  Location(
    Url:
        "https://baike.baidu.com/item/%E7%BD%97%E5%BE%B7%E5%B2%9B%E5%A4%AA%E9%98%B3%E7%A5%9E%E5%B7%A8%E5%83%8F/142057?structureClickId=142057&structureId=73c81632c23dff3d9026ddd3&structureItemId=f39dc6c7378a2e4079767908&lemmaFrom=starMapContent_star&fromModule=starMap_content&lemmaIdFrom=147601",
    imageUrl: 'assets/罗德岛太阳神巨像.webp',
    name: '罗德岛太阳神巨像',
    country: '希腊',
  ),
  Location(
    Url:
        "https://baike.baidu.com/item/%E4%BA%9A%E5%8E%86%E5%B1%B1%E5%A4%A7%E7%81%AF%E5%A1%94/158711?structureClickId=158711&structureId=73c81632c23dff3d9026ddd3&structureItemId=d4c4e5133d08d137e28f6bc9&lemmaFrom=starMapContent_star&fromModule=starMap_content&lemmaIdFrom=147601",
    imageUrl: 'assets/亚历山大灯塔.jpg',
    name: '亚历山大灯塔',
    country: '埃及',
  ),
  Location(
    Url:
        "https://baike.baidu.com/item/%E5%85%B5%E9%A9%AC%E4%BF%91/60649?structureClickId=60649&structureId=73c81632c23dff3d9026ddd3&structureItemId=eff646771b30d8c7dfa07b4a&lemmaFrom=starMapContent_star&fromModule=starMap_content&lemmaIdFrom=147601",
    imageUrl: 'assets/兵马俑.webp',
    name: '兵马俑',
    country: '中国',
  ),
];
