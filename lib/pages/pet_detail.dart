import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../global_state.dart';
import '../utils/http.dart';

/// 宠物数据模型
class Pet {
  final int id;
  final String image;
  final String petName;
  final String location;
  final bool isFavorited;
  final String petDescription;
  final double rate;
  final String petId;
  final String price;
  final String ownerName;
  final String ownerPhoto;
  final String sex;
  final String age;
  final String color;
  final String petType;
  final String album;
  final int userId;

  Pet({
    required this.id,
    required this.image,
    required this.petName,
    required this.location,
    required this.isFavorited,
    required this.petDescription,
    required this.rate,
    required this.petId,
    required this.price,
    required this.ownerName,
    required this.ownerPhoto,
    required this.sex,
    required this.age,
    required this.color,
    required this.petType,
    required this.album,
    required this.userId,
  });

  /// 从 JSON 数据解析出 Pet 对象
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      image: json['image'],
      petName: json['pet_name'],
      location: json['location'],
      isFavorited: json['is_favorited'],
      petDescription: json['pet_description'],
      rate: (json['rate'] as num).toDouble(),
      petId: json['pet_id'],
      price: json['price'],
      ownerName: json['owner_name'],
      ownerPhoto: json['owner_photo'],
      sex: json['sex'],
      age: json['age'],
      color: json['color'],
      petType: json['pet_type'],
      album: json['album'],
      userId: json['user_id'],
    );
  }
}

class PetDetailsPage extends StatefulWidget {
  final int? id;

  const PetDetailsPage({Key? key, this.id}) : super(key: key);

  @override
  _PetDetailsPageState createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  Pet? pet;
  int id = 0;
  bool _hasFetchedData = false;



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 只执行一次，避免重复获取参数和调用 getData()
    if (!_hasFetchedData) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int) {
        id = args;
      }
      // 如果 id 有效，则调用 getData() 加载数据
      if (id != 0) {
        getData();
      }
      _hasFetchedData = true;
    }
  }

  Future<void> getData() async {
    try {
      final response = await HttpService().get("/api/pet/info?id=$id");
      print("data:${response.data['data']}");
      setState(() {
        pet = Pet.fromJson(response.data['data']);
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('获取数据失败！')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    // 如果 id 无效，则显示错误提示
    if (id == 0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('宠物详情'),
        ),
        body: const Center(
          child: Text('无效的宠物数据'),
        ),
      );
    }
    // 如果 pet 还没加载出来，显示加载指示器
    if (pet == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('宠物详情'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pet!.petName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 展示宠物主图
            Image.network(
              pet!.image,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            // 宠物名称与位置
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet!.petName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pet!.location,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 评分与收藏按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(pet!.rate.toString()),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      pet!.isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: pet!.isFavorited ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      // 可在此处添加收藏状态切换逻辑
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 描述内容
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                pet!.petDescription,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            // 主人信息及价格

            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(pet!.ownerPhoto),
              ),
              title: Text(pet!.ownerName),
              subtitle: Text('价格: ${pet!.price}'),
              trailing: ElevatedButton(
                onPressed: () async {
                  // 弹出选择对话框
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('请选择联系方式'),
                      content: Text('您想拨打电话还是在线联系？'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // 关闭对话框
                            Navigator.of(ctx).pop();
                            // 使用 url_launcher 拨打电话
                            final Uri telUri =
                                Uri.parse('tel:17628518589');
                            launchUrl(telUri);
                          },
                          child: Text('拨打电话'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // 关闭对话框
                            Navigator.of(ctx).pop();

                            var globalState = Provider.of<GlobalState>(context, listen: false);
                            print(globalState.userInfo);
                            // 登录成功后跳转到主页（这里直接使用pushReplacement，可替换为你的主页页面）
                            final data = {
                              "user_id": globalState.userInfo['id'],
                              "peer_ids": pet?.userId,
                              "last_message_id": 0,
                              "last_message_text": "",
                              "unread_count": 0
                            };
                            final response = await HttpService().post("/api/user_conversation_list/create", data: data);
                            print("data:${response.data['data']}");

                            // 跳转到聊天页面
                            Navigator.of(context).pushNamed(
                              '/chat_owner',
                              arguments: {
                                'conversation_id': response.data['data']['list'][0]['conversation_id'],
                                'peer_name': response.data['data']['list'][0]['peer_name'],
                                'peer_ids': pet?.userId,
                              },
                            );
                          },
                          child: Text('在线联系'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('联系主人'),
              ),
            ),
            const Divider(),
            // 其他详细信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('宠物编号: ${pet!.petId}'),
                  Text('性别: ${pet!.sex}'),
                  Text('年龄: ${pet!.age}'),
                  Text('颜色: ${pet!.color}'),
                  Text('宠物类型: ${pet!.petType}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 相册展示
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('相册', style: Theme.of(context).textTheme.bodyLarge),
            ),
            const SizedBox(height: 8),
            Image.network(
              pet!.album,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
