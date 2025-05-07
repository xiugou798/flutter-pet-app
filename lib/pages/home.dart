import 'dart:developer';
import 'dart:math';
// import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  List announcements = [];

  // 文本控件默认值
  final _nameController = TextEditingController(
      text: 'Maxi'); // 宠物名字&#8203;:contentReference[oaicite:6]{index=6}
  final _breedController = TextEditingController(
      text: 'Bulldog'); // 宠物品种&#8203;:contentReference[oaicite:7]{index=7}
  final _imageUrlController = TextEditingController(
    text:
        'https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?...q=60',
  ); // 图片链接&#8203;:contentReference[oaicite:8]{index=8}
  final _locationController = TextEditingController(
      text:
          'Battambang, Cambodia'); // 地点&#8203;:contentReference[oaicite:9]{index=9}
  final _descriptionController = TextEditingController(
    text: 'Lorem ipsum is a placeholder text commonly used…',
  ); // 描述&#8203;:contentReference[oaicite:10]{index=10}
  final _priceController = TextEditingController(
      text: '￥1350'); // 价格&#8203;:contentReference[oaicite:11]{index=11}
  final _ownerNameController = TextEditingController(
      text: 'Sangvaleap'); // 主人姓名&#8203;:contentReference[oaicite:12]{index=12}
  final _ownerPhotoController = TextEditingController(text: ''); // 主人头像链接（可留空）
  final _ageController = TextEditingController(
      text: '5 Months'); // 年龄&#8203;:contentReference[oaicite:13]{index=13}
  final _albumController = TextEditingController(
    text:
        'https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?...q=60',
  ); // 相册链接&#8203;:contentReference[oaicite:14]{index=14}

  // 状态变量默认值
  String? _gender =
      'Male'; // 性别：Male/Female&#8203;:contentReference[oaicite:15]{index=15}
  String? _type = 'Dog'; // 宠物类型&#8203;:contentReference[oaicite:16]{index=16}
  final _birthdayController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  ); // 宠物生日：默认今天&#8203;:contentReference[oaicite:17]{index=17}
  final _adoptDateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  ); // 迎接家庭的日子：默认今天&#8203;:contentReference[oaicite:18]{index=18}
  Color _selectedColor = Colors.blue; // 颜色默认蓝色
  double _rate = 4.5; // 评分默认 4.5&#8203;:contentReference[oaicite:19]{index=19}
  bool _isFavorited =
      false; // 是否收藏：默认 false&#8203;:contentReference[oaicite:20]{index=20}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _birthdayController.dispose();
    _adoptDateController.dispose();
    _imageUrlController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _ownerNameController.dispose();
    _ownerPhotoController.dispose();
    _ageController.dispose();
    _albumController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    try {
      final response = await HttpService().get("/api/pet/list");
      print(response.data['data']['list']);
      setState(() {
        pets = response.data['data']['list'];
      });

      final announcements_response =
          await HttpService().get("/api/announcements/list");
      print(announcements_response.data['data']['list']);
      setState(() {
        announcements = announcements_response.data['data']['list'];
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
                    "位置",
                    style: TextStyle(
                      color: AppColor.labelColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                "四川成都",
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
          onTap: () => {Navigator.of(context).pushNamed("/message_list")},
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
            // _buildSearchBar(),
            // const SizedBox(height: 25),
            // TODO 轮播图
            _buildCategories(),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // 添加 crossAxisAlignment 实现垂直居中
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 将 Padding 调整为对称垂直内边距
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 15.0),
                  child: Text(
                    "领养宠物列表",
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    margin:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "发布宠物",
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  onTap: () => {_showAddPetDialog()},
                ),
              ],
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
          hintText: '搜索宠物、类别...',
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
              return pet["pet_type"] == categories[_selectedCategory]["name"];
            })
            .toList()
            .cast<
                Map<String,
                    dynamic>>(); // 使用 .cast<Map<String, dynamic>> 强制类型转换
    // log(recommendedPets.toString());
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
          onTap: () => {
            print(recommendedPets[index]),
            Navigator.of(context).pushNamed("/pet_detail",
                arguments: recommendedPets[index]["id"])
          },
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
            "宠物健康指南",
            style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "1.定期的兽医检查对宠物的健康至关重要。",
            style: TextStyle(color: AppColor.textColor, fontSize: 14),
          ),
          Text(
            "2.别忘了按时给宠物接种疫苗。",
            style: TextStyle(color: AppColor.textColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate).toLocal();
    final formatter = DateFormat('yyyy年MM月dd日');
    return formatter.format(date);
  }

  // 宠物活动
  Widget _buildPetEvents() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "即将举行的宠物活动",
            style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          Column(
            children: List.generate(
              announcements.length,
              (index) => ListTile(
                leading: const Icon(Icons.event, color: Colors.grey),
                title: Text(announcements[index]['title']),
                subtitle:
                    Text(formatDate(announcements[index]['published_at'])),
              ),
            ),
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
            "你的收藏",
            style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          // 如果没有收藏宠物，显示提示文字
          favoritePets.isEmpty
              ? Text("暂无收藏宠物.", style: TextStyle(color: AppColor.textColor))
              : Column(
                  children: List.generate(
                    favoritePets.length,
                    (index) => PetItem(
                      data: favoritePets[index],
                      width: MediaQuery.of(context).size.width * 0.8,
                      onTap: () => {
                        print(favoritePets[index]),
                        Navigator.of(context).pushNamed("/pet_detail",
                            arguments: favoritePets[index]["id"])
                      },
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
            "设置",
            style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          ListTile(
            leading: Icon(Icons.account_circle, color: AppColor.labelColor),
            title: Text("编辑资料"),
            onTap: () {
              // Navigate to profile settings
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: AppColor.labelColor),
            title: Text("通知设置"),
            onTap: () {
              // Navigate to 通知设置
            },
          ),
        ],
      ),
    );
  }

  void _showAddPetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('添加宠物'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 图片 URL
                    TextField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(labelText: '图片链接'),
                    ),
                    // 地点
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(labelText: '地点'),
                    ),
                    // 名字
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: '宠物名字'),
                    ),
                    // 种类
                    // TextField(
                    //   controller: _breedController,
                    //   decoration: InputDecoration(labelText: '宠物品种'),
                    // ),
                    // 宠物类型（下拉）
                    DropdownButtonFormField<String>(
                      value: _type,
                      decoration: InputDecoration(labelText: '宠物类型'),
                      items: ['Dog', 'Cat', 'Bird', 'Other']
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setStateDialog(() => _type = val),
                    ),
                    // 性别
                    Row(
                      children: [
                        Text('性别: '),
                        Radio<String>(
                          value: 'Male',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() => _gender = value);
                            setStateDialog(() {});
                          },
                        ),
                        Text('公'),
                        Radio<String>(
                          value: 'Female',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() => _gender = value);
                            setStateDialog(() {});
                          },
                        ),
                        Text('母'),
                      ],
                    ),
                    // 生日
                    // TextField(
                    //   controller: _birthdayController,
                    //   decoration: InputDecoration(
                    //     labelText: '宠物生日',
                    //     hintText: 'yyyy-MM-dd',
                    //   ),
                    //   readOnly: true,
                    //   onTap: () async {
                    //     DateTime? d = await showDatePicker(
                    //       context: context,
                    //       initialDate: DateTime.now(),
                    //       firstDate: DateTime(2000),
                    //       lastDate: DateTime(2100),
                    //     );
                    //     if (d != null) {
                    //       _birthdayController.text =
                    //           DateFormat('yyyy-MM-dd').format(d);
                    //     }
                    //   },
                    // ),
                    // 迎接日
                    // TextField(
                    //   controller: _adoptDateController,
                    //   decoration: InputDecoration(
                    //     labelText: '迎接家庭的日子',
                    //     hintText: 'yyyy-MM-dd',
                    //   ),
                    //   readOnly: true,
                    //   onTap: () async {
                    //     DateTime? d = await showDatePicker(
                    //       context: context,
                    //       initialDate: DateTime.now(),
                    //       firstDate: DateTime(2000),
                    //       lastDate: DateTime(2100),
                    //     );
                    //     if (d != null) {
                    //       _adoptDateController.text =
                    //           DateFormat('yyyy-MM-dd').format(d);
                    //     }
                    //   },
                    // ),
                    // 年龄
                    TextField(
                      controller: _ageController,
                      decoration: InputDecoration(labelText: '年龄'),
                    ),
                    // 价格
                    TextField(
                      controller: _priceController,
                      decoration: InputDecoration(labelText: '价格'),
                    ),
                    // 描述（多行）
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: '描述'),
                      maxLines: 3,
                    ),
                    // 评分
                    Row(
                      children: [
                        Text('评分: '),
                        // 这里示例用 Slider
                        Expanded(
                          child: Slider(
                            activeColor: Colors.red,
                            value: _rate,
                            min: 0,
                            max: 5,
                            divisions: 10,
                            label: _rate.toString(),
                            onChanged: (v) => setStateDialog(() => _rate = v),
                          ),
                        ),
                        Text(_rate.toStringAsFixed(1)),
                      ],
                    ),
                    // 是否收藏
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('是否收藏'),
                        Switch(
                          value: _isFavorited,
                          onChanged: (v) =>
                              setStateDialog(() => _isFavorited = v),
                        ),
                      ],
                    ),
                    // 颜色选择（保留原有）
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        Color? color = await showDialog(
                          context: context,
                          builder: (_) => StatefulBuilder(
                            builder: (c, setStateColor) => AlertDialog(
                              title: Text('选择宠物颜色'),
                              content: ColorPicker(
                                color: _selectedColor,
                                onColorChanged: (color) {
                                  setState(() => _selectedColor = color);
                                  setStateColor(() {});
                                },
                                showColorCode: true,
                                colorCodeHasColor: true,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(_selectedColor),
                                  child: Text("确定"),
                                ),
                              ],
                            ),
                          ),
                        );
                        if (color != null) {
                          setState(() => _selectedColor = color);
                          setStateDialog(() {});
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: _selectedColor,
                        child:
                            Text("选择颜色", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    // 主人姓名 & 头像
                    TextField(
                      controller: _ownerNameController,
                      decoration: InputDecoration(labelText: '主人姓名'),
                    ),
                    TextField(
                      controller: _ownerPhotoController,
                      decoration: InputDecoration(labelText: '主人头像链接'),
                    ),
                    // 相册链接
                    TextField(
                      controller: _albumController,
                      decoration: InputDecoration(labelText: '相册链接'),
                    ),
                    SizedBox(height: 10),
                    // 提交按钮
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () {
                        var globalState =
                            Provider.of<GlobalState>(context, listen: false);
                        // 这里把所有的数据打包成一个 Map，调用你的 _addPet 方法
                        final petData = {
                          "image": _imageUrlController.text,
                          "pet_name": _nameController.text,
                          "location": _locationController.text,
                          "is_favorited": _isFavorited,
                          "pet_description": _descriptionController.text,
                          "rate": _rate,
                          "pet_id": generateUuidV4(),
                          "price": _priceController.text,
                          "owner_name": _ownerNameController.text,
                          "owner_photo": _ownerPhotoController.text,
                          "sex": _gender,
                          "age": _ageController.text,
                          "color": _selectedColor.value.toRadixString(16),
                          "pet_type": _type,
                          "album": _albumController.text,
                          "user_id": globalState.userInfo["id"]
                          // "breed": _breedController.text,
                          // "birthday": _birthdayController.text,
                          // "adopt_date": _adoptDateController.text,
                        };
                        _addPet(petData);
                        Navigator.of(context).pop();
                      },
                      child: Text("添加宠物"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addPet(Map<String, Object?> petData) async {
    try {
      print(petData);
      final response =
          await HttpService().post("/api/pet/create", data: petData);
      if (response.data['code'] == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('发布成功！')));

        this.getData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('发布失败！')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('发布失败！')),
      );
    }
  }

  /// 生成一个符合 UUID v4 格式的随机字符串，无第三方依赖
  String generateUuidV4() {
    final rnd = Random(); // 随机数生成器&#8203;:contentReference[oaicite:1]{index=1}

    // 1. 生成 16 个随机字节
    final bytes = List<int>.generate(
        16,
        (_) => rnd.nextInt(
            256)); // 值域 [0,255]&#8203;:contentReference[oaicite:2]{index=2}

    // 2. 设置版本号（第 7 字节的高 4 位置为 0b0100 表示 v4）
    bytes[6] = (bytes[6] & 0x0F) | 0x40;

    // 3. 设置变体（第 9 字节的高 2 位置为 0b10 表示 RFC4122 变体 1）
    bytes[8] = (bytes[8] & 0x3F) | 0x80;

    // 4. 将每个字节转为两位十六进制，不足前补 0
    String byteToHex(int b) => b.toRadixString(16).padLeft(
        2, '0'); // toRadixString(16) :contentReference[oaicite:3]{index=3}

    // 5. 按 UUID 8-4-4-4-12 格式拼接各段
    final parts = [
      bytes.sublist(0, 4).map(byteToHex).join(),
      bytes.sublist(4, 6).map(byteToHex).join(),
      bytes.sublist(6, 8).map(byteToHex).join(),
      bytes.sublist(8, 10).map(byteToHex).join(),
      bytes.sublist(10, 16).map(byteToHex).join(),
    ];
    return parts.join('-');
  }
}
