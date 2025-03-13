import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// 示例商品数据
final List<Map<String, String>> products = [
  {'image': 'https://via.placeholder.com/150', 'title': '商品1', 'price': '¥9.9'},
  {'image': 'https://via.placeholder.com/150', 'title': '商品2', 'price': '¥19.9'},
  // 添加更多商品数据
];

// 示例分类数据
final List<Map<String, dynamic>> categories = [
  {'icon': Icons.local_offer, 'label': '9.9元特卖'},
  {'icon': Icons.flash_on, 'label': '限时秒杀'},
  // 添加更多分类数据
];

// 示例轮播图数据
final List<String> banners = [
  'https://via.placeholder.com/300x150',
  'https://via.placeholder.com/300x150',
  // 添加更多轮播图数据
];

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '搜索商品',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.category, color: Colors.grey),
          ],
        ),
      ),
      body: ListView(
        children: [
          // 轮播图
          Container(
            height: 150,
            // child: Swiper(
            //   itemBuilder: (BuildContext context, int index) {
            //     return Image.network(banners[index], fit: BoxFit.cover);
            //   },
            //   itemCount: banners.length,
            //   pagination: SwiperPagination(),
            //   autoplay: true,
            // ),
          ),
          // 分类导航
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: categories.map((category) {
                return Column(
                  children: [
                    CircleAvatar(
                      child: Icon(category['icon']),
                    ),
                    SizedBox(height: 5),
                    Text(category['label']),
                  ],
                );
              }).toList(),
            ),
          ),
          // 商品推荐
          Padding(
            padding: const EdgeInsets.all(8.0),
            // child: StaggeredGridView.countBuilder(
            //   crossAxisCount: 4,
            //   itemCount: products.length,
            //   itemBuilder: (BuildContext context, int index) => Card(
            //     child: Column(
            //       children: [
            //         Image.network(products[index]['image']),
            //         Text(products[index]['title']),
            //         Text(products[index]['price'], style: TextStyle(color: Colors.red)),
            //       ],
            //     ),
            //   ),
            //   staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
            //   mainAxisSpacing: 4.0,
            //   crossAxisSpacing: 4.0,
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            // ),
          ),
          // 拼团专区
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('拼团专区', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Container(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 120,
                        margin: EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            // Image.network(products[index]['image'], height: 100, fit: BoxFit.cover),
                            // Text(products[index]['title']),
                            // Text(products[index]['price'], style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // 活动会场
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('活动会场', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Image.network('https://via.placeholder.com/300x100', fit: BoxFit.cover),
              ],
            ),
          ),
          // 多多视频
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('多多视频', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5, // 示例视频数量
                    itemBuilder: (context, index) {
                      return Container(
                        width: 150,
                        margin: EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            Image.network('https://via.placeholder.com/150x100', fit: BoxFit.cover),
                            Text('视频标题'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
