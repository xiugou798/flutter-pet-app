import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// 聊天页面
class ChatDoctorPage extends StatefulWidget {
  const ChatDoctorPage({Key? key}) : super(key: key);

  @override
  _ChatDoctorPageState createState() => _ChatDoctorPageState();
}

class _ChatDoctorPageState extends State<ChatDoctorPage> {
  // 消息列表，初始为空
  final List<Message> _messages = [];

  // 输入框控制器
  final TextEditingController _controller = TextEditingController();
  final url = Uri.parse(
      'https://api.deepseek.com/v1/chat/completions'); // 请替换为实际的 DeepSeek API 地址
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer sk-ba467443b5bb4c3b88a5832e6ebaf1ea',
    // 如有需要，请替换为实际的 API 密钥
  };

  @override
  void initState() {
    super.initState();
    _messages.add(Message(content: "你现在是一个专业的宠物医生，请使用专业简洁并且有趣的话来回答用户的问题", role: "system"));
    // 调用一个独立的异步方法初始化数据
    _initialize();
  }

  Future<void> _initialize() async {
    final reply = await _sendMessageToDeepSeek();
    print(reply);
    if (reply != null) {
      setState(() {
        _messages.insert(0, Message(content: reply, role: 'assistant'));
      });
    }
  }

  /// 发送消息处理
  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    // 显示用户发送的消息
    setState(() {
      _messages.insert(0, Message(content: text, role: 'user'));
    });
    _controller.clear();
    print("发送消息");

    // 调用 DeepSeek API 发送消息
    final reply = await _sendMessageToDeepSeek();
    print(reply);
    if (reply != null) {
      // 将 API 返回的消息加入列表（作为机器人回复）
      setState(() {
        _messages.insert(0, Message(content: reply, role: 'assistant'));
      });
    }
  }

  /// 通过 DeepSeek API 发送消息，并获取回复
  Future<String?> _sendMessageToDeepSeek() async {
    var _send_messages = [];
    for (int i = _messages.length - 1; i >= 0; i--) {
      _send_messages.add(_messages[i].toJson());
    }
    final body = json.encode({
      "model": "deepseek-chat",
      "messages": _send_messages,
      "temperature": 0.5,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      print('response:${response.body}');
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final responseData = json.decode(decodedBody);
        if (responseData['choices'] != null &&
            responseData['choices'].isNotEmpty &&
            responseData['choices'][0]['message'] != null) {
          return responseData['choices'][0]['message']['content'];
        }
      } else {
        print(
            'DeepSeek API 调用失败：状态码 ${response.statusCode}，返回数据：${response.body}');
      }
    } catch (e) {
      print('调用 DeepSeek API 时出现异常: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('宠物医生'),
      ),
      body: Column(
        children: [
          // 消息列表区域
          Expanded(
            child: ListView.builder(
              reverse: true, // 最新消息显示在底部
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                // 当消息 role 为 'system' 时，不显示
                if (message.role == 'system') {
                  return const SizedBox.shrink();
                }
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  alignment: message.role == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.role == 'user'
                          ? Colors.blueAccent
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: message.role == 'user'
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // 底部输入区域（使用 SafeArea 避免系统遮挡）
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.white,
              child: Row(
                children: [
                  // 输入框
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '请输入消息',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 发送按钮
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                    onPressed: _sendMessage,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 100)
        ],
      ),
    );
  }
}

/// 消息模型
class Message {
  final String content;
  final String role; // 是否为用户消息

  Message({required this.content, required this.role});

  // 添加 toJson() 方法
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}
