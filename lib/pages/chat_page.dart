import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/http.dart';

/// 聊天页面
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // 消息列表
  final List<Message> _messages = [];

  // 输入框控制器
  final TextEditingController _controller = TextEditingController();

  final Uri url = Uri.parse('http://${BASEURL}:3001/api/v1/workspace/pet/stream-chat');
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${BASEKEY}'
  };

  @override
  void initState() {
    super.initState();
    _messages.add(Message(content: '你好呀，我是你的专属电子宠物^_^', role: 'assistant'));
  }

  /// 发送按钮触发
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.insert(0, Message(content: text, role: 'user'));
      // 占位一个空的 assistant 消息，用于流式更新
      _messages.insert(0, Message(content: '', role: 'assistant', isStreaming: true));
    });
    _controller.clear();
    _streamReply(text);
  }

  /// 流式调用 DeepSeek API 并更新消息
  Future<void> _streamReply(text) async {
    final client = http.Client();
    final request = http.Request('POST', url);
    request.headers.addAll(headers);

    // 构建发送的历史消息
    final payloadMessages = _messages.reversed
        .map((m) => {'role': m.role, 'content': m.content})
        .toList();

    request.body = json.encode({
      "message": text,
      "mode": "chat"
    });


    try {
      final streamed = await client.send(request);
      final utf8Stream = streamed.stream.transform(utf8.decoder);
      StringBuffer buffer = StringBuffer();

      utf8Stream.listen((chunk) {
        // print(chunk); // 原始 chunk 打印，方便调试

        for (final line in chunk.split('\n')) {
          if (!line.startsWith('data: ')) continue;

          final jsonStr = line.substring(6).trim();
          if (jsonStr == '[DONE]') {
            // OpenAI 标准结束标记，关闭流
            setState(() {
              _messages.firstWhere((m) => m.isStreaming).isStreaming = false;
            });
            client.close();
            return;
          }

          try {
            final data = json.decode(jsonStr);

            // 只处理自定义的 textResponseChunk 类型
            if (data['type'] == 'textResponseChunk') {
              final content = data['textResponse'] as String? ?? '';
              buffer.write(content);

              setState(() {
                final msg = _messages.firstWhere((m) => m.isStreaming);
                msg.content = buffer.toString();
              });

              // 如果服务端发来了 close = true，可以视为流结束
              if (data['close'] == true) {
                setState(() {
                  _messages.firstWhere((m) => m.isStreaming).isStreaming = false;
                });
                client.close();
                return;
              }
            }

          } catch (e) {
            // 忽略 JSON 解析或字段不存在的错误
          }
        }
      }, onError: (error) {
        print('Stream error: $error');
        client.close();
      });

    } catch (e) {
      print('调用异常: $e');
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('电子宠物')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message.role == 'system') return const SizedBox.shrink();
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
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.white,
              child: Row(
                children: [
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
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                    onPressed: _sendMessage,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

/// 消息模型
class Message {
  String content;
  final String role;
  bool isStreaming;

  Message({required this.content, required this.role, this.isStreaming = false});
}
