import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/theme/color.dart';
import 'package:pet_app/utils/data.dart';
import 'package:pet_app/widgets/category_item.dart';
import 'package:pet_app/widgets/notification_box.dart';
import 'package:pet_app/widgets/pet_item.dart';
import 'package:provider/provider.dart';

import '../global_state.dart';
import '../utils/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategory = 0;
  List pets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final response = await HttpService().get("/api/pet/list");
      print(response.data['data']['list']);
      setState(() {
        pets = response.data['data']['list'];
      });


      // var globalState = Provider.of<GlobalState>(context, listen: false);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('获取数据失败！')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColor.appBarColor,
            pinned: true,
            snap: true,
            floating: true,
            title: _buildAppBar(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildBody(),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  // AppBar布局
  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.place_outlined,
                    color: AppColor.labelColor,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Location",
                    style: TextStyle(
                      color: AppColor.labelColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                "Phnom Penh, Cambodia",
                style: TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        NotificationBox(
          notifiedNumber: 1,
          onTap: null,
        ),
      ],
    );
  }

  // 构建主页内容
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            _buildSearchBar(),
            const SizedBox(height: 25),
            _buildCategories(),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
              child: Text(
                "Adopt Me",
                style: TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
            ),
            _buildRecommendedPets(),
            const SizedBox(height: 25),
            _buildHealthTips(),
            const SizedBox(height: 25),
            _buildPetEvents(),
            const SizedBox(height: 25),
            _buildFavoritesSection(),
            const SizedBox(height: 25),
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  // 搜索框
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Pets, Categories...',
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          // Handle search logic
        },
      ),
    );
  }

  // 分类选择
  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 5, left: 15),
      child: Row(
        children: List.generate(
          categories.length,
          (index) => CategoryItem(
            data: categories[index],
            selected: index == _selectedCategory,
            onTap: () => _onCategoryTap(index),
          ),
        ),
      ),
    );
  }

  // 分类点击事件处理
  void _onCategoryTap(int index) {
    setState(() {
      _selectedCategory = index;
    });
  }

// 推荐宠物部分（Adopt Me）
  Widget _buildRecommendedPets() {
    // 显式声明类型为 List<Map<String, dynamic>>
    List<Map<String, dynamic>> recommendedPets = _selectedCategory == 0
        ? pets.toList().cast<Map<String, dynamic>>()
        : pets
            .where((pet) {
              // 确保分类匹配，category 字段是否存在且正确
              return pet["pet_type"] == categories[_selectedCategory]["pet_name"];
            })
            .toList()
            .cast<
                Map<String,
                    dynamic>>(); // 使用 .cast<Map<String, dynamic>> 强制类型转换
    log(recommendedPets.toString());
    return CarouselSlider(
      options: CarouselOptions(
        height: 400,
        enlargeCenterPage: true,
        disableCenter: true,
        viewportFraction: 0.8,
      ),
      items: List.generate(
        recommendedPets.length,
        (index) => PetItem(
          data: recommendedPets[index],
          width: MediaQuery.of(context).size.width * 0.8,
          onTap: null,
          onFavoriteTap: () {
            // 收藏/取消收藏功能
            setState(() {
              recommendedPets[index]["is_favorited"] =
                  !recommendedPets[index]["is_favorited"];
            });
          },
        ),
      ),
    );
  }

  // 收藏宠物点击事件处理
  void _onFavoriteTap(int index) {
    setState(() {
      pets[index]["is_favorited"] = !pets[index]["is_favorited"];
    });
  }

  // 宠物健康小贴士
  Widget _buildHealthTips() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Health Tips for Your Pet",
            style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "1. Regular vet checkups are essential to your pet's health.",
            style: TextStyle(color: AppColor.textColor, fontSize: 14),
          ),
          Text(
            "2. Don't forget to vaccinate your pets on time.",
            style: TextStyle(color: AppColor.textColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // 宠物活动
  Widget _buildPetEvents() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upcoming Pet Events",
            style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          ListTile(
            leading: Icon(Icons.event, color: AppColor.labelColor),
            title: Text("Pet Playdate at Park"),
            subtitle: Text("March 5th, 2025"),
          ),
          ListTile(
            leading: Icon(Icons.event, color: AppColor.labelColor),
            title: Text("Pet Adoption Fair"),
            subtitle: Text("March 12th, 2025"),
          ),
        ],
      ),
    );
  }

// 收藏宠物部分（Your Favorites）
  Widget _buildFavoritesSection() {
    // 显式声明类型为 List<Map<String, dynamic>>，过滤出已经收藏的宠物
    List<Map<String, dynamic>> favoritePets = pets
        .where((pet) {
          return pet["is_favorited"] == true; // 只取已收藏的宠物
        })
        .toList()
        .cast<Map<String, dynamic>>(); // 强制类型转换

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Favorites",
            style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          // 如果没有收藏宠物，显示提示文字
          favoritePets.isEmpty
              ? Text("No favorites yet.",
                  style: TextStyle(color: AppColor.textColor))
              : Column(
                  children: List.generate(
                    favoritePets.length,
                    (index) => PetItem(
                      data: favoritePets[index],
                      width: MediaQuery.of(context).size.width * 0.8,
                      onTap: null,
                      onFavoriteTap: () {
                        setState(() {
                          favoritePets[index]["is_favorited"] =
                              !favoritePets[index]["is_favorited"];
                        });
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // 设置项
  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Settings",
            style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          ListTile(
            leading: Icon(Icons.account_circle, color: AppColor.labelColor),
            title: Text("Edit Profile"),
            onTap: () {
              // Navigate to profile settings
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: AppColor.labelColor),
            title: Text("Notification Settings"),
            onTap: () {
              // Navigate to notification settings
            },
          ),
        ],
      ),
    );
  }
}
