// 宠物拥有者聊天界面
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../global_state.dart';
import '../utils/http.dart';

class ChatOwnerPage extends StatefulWidget {
  final int? conversation_id;
  final int? peer_ids;
  final String? peer_name;

  const ChatOwnerPage(
      {Key? key, this.conversation_id, this.peer_ids, this.peer_name})
      : super(key: key);

  @override
  _ChatOwnerPageState createState() => _ChatOwnerPageState();
}

class _ChatOwnerPageState extends State<ChatOwnerPage> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  int _conversationId = 0;
  int _peerIds = 0;
  String _peerName = "";
  var globalState;

  bool _hasFetchedData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 只执行一次，避免重复获取参数和调用 getData()
    if (!_hasFetchedData) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      setState(() {
        _conversationId = args?['conversation_id'];
        _peerName = args?['peer_name'];
        _peerIds = args?['peer_ids'];
      });

      _loadHistory();
      _hasFetchedData = true;
    }
  }

  @override
  void initState() {
    super.initState();

    globalState = Provider.of<GlobalState>(context, listen: false);
    _subscribeNewMessages();
  }

  /// 拉取历史消息
  Future<void> _loadHistory() async {
    // TODO: 调用后端接口获取历史消息列表
    final history = await fetchMessagesFromServer();
    setState(() {
      _messages.addAll(history);
      print("渲染的消息：$history");
    });

    _scrollToBottom();
  }

  /// 订阅服务器推送的新消息，例如 WebSocket
  void _subscribeNewMessages() {
    // TODO: 订阅逻辑
    // onNewMessage((msg) {
    //   setState(() => _messages.add(msg));
    //   _scrollToBottom();
    // });
    // onTyping((typing) {
    //   setState(() => _isTyping = typing);
    // });
  }

  /// 自动滚动到底部
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// TODO: 以下函数需要补充与后端实际对接
  Future<List<Message>> fetchMessagesFromServer() async {
    // 发 HTTP 请求或 WebSocket 拉历史
    try {
      // 打印请求参数
      print('conversationId: $_conversationId');

      // 发起 GET 请求
      final response = await HttpService()
          .get('/api/user_message/list?conversation_id=$_conversationId');

      // 从响应中安全地提取列表数据
      final dataList = (response.data['data']?['list'] as List<dynamic>?) ?? [];
      print('数据结果：$dataList');

      // 使用 map+toList 解析并打印每条记录
      final messages = dataList.map((item) {
        print('item 数据：$item');
        return Message.fromJson(
            item as Map<String, dynamic>, globalState.userInfo['id']);
      }).toList();
      print('解析后消息列表：$messages');

      return messages;
    } on Exception catch (e, stack) {
      // 捕获并打印异常
      print('获取消息失败：$e');
      print(stack);
      // 根据需要返回空列表或重新抛出异常
      return [];
      // 若需上层处理异常，可改为： rethrow;
    }
  }

  Future<void> sendMessageToServer(Map<String, dynamic> payload) async {
    // 发 HTTP 请求推送消息

    try {
      print(payload);
      // 发起 POST 请求
      final response =
          await HttpService().post('/api/user_message/send', data: payload);
    } on Exception catch (e, stack) {
      // 捕获并打印异常
      print('发送消息失败：$e');
      print(stack);
    }
  }

  /// 发送消息处理
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final msg = Message(
      messageId: DateTime.now().millisecondsSinceEpoch,
      senderId: globalState.userInfo['id'],
      receiverId: _peerIds,
      content: text,
      sentAt: DateTime.now(),
      role: MessageRole.user,
    );

    final data = {
      "conversation_id": _conversationId,
      "sender_id": globalState.userInfo['id'],
      "receiver_id": _peerIds,
      "message_text": text
    };

    // 1. 本地添加待发送消息
    setState(() {
      _messages.insert(0, msg);
    });
    _controller.clear();
    _scrollToBottom();

    // 2. 调用后端接口发送
    try {
      await sendMessageToServer(data);
      // 3. 更新发送／已读状态
      setState(() {
        final index = _messages.indexWhere((m) => m.messageId == msg.messageId);
        if (index != -1) _messages[index].isRead = true;
      });
    } catch (e) {
      // TODO: 发送失败提示并重试
      debugPrint('发送失败：$e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dt) => DateFormat('HH:mm').format(dt);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text(_peerName)),
      body: Column(
        children: [
          Container(
            height: 100,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    _peerName,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
          // 消息列表
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, idx) {
                if (_isTyping && idx == 0) {
                  // 对方正在输入指示
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('对方正在输入...'),
                    ),
                  );
                }
                final message = _messages[idx - (_isTyping ? 1 : 0)];
                if (message.role == MessageRole.system) {
                  return const SizedBox.shrink();
                }
                final isMe = message.role == MessageRole.user;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isMe) CircleAvatar(child: Icon(Icons.pets)), // 对方头像
                      const SizedBox(width: 6),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    isMe ? Colors.blueAccent : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                message.content,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatTime(message.sentAt),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(width: 4),
                                if (isMe)
                                  Icon(
                                    message.isRead
                                        ? Icons.done_all
                                        : Icons.check,
                                    size: 14,
                                    color: message.isRead
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (isMe) CircleAvatar(child: Icon(Icons.person)), // 自己头像
                    ],
                  ),
                );
              },
            ),
          ),

          // 底部输入区 & 发送按钮
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: '请输入消息',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum MessageRole { system, user, owner }

class Message {
  final int messageId;
  final int senderId;
  final int receiverId;
  final String content;
  final DateTime sentAt;
  bool isRead;
  final MessageRole role;

  Message({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.sentAt,
    this.isRead = false,
    required this.role,
  });

  factory Message.fromJson(Map<String, dynamic> json, user_id) => Message(
        messageId: json['message_id'],
        senderId: json['sender_id'],
        receiverId: json['receiver_id'],
        content: json['message_text'],
        sentAt: DateTime.parse(json['sent_at']),
        isRead: json['read_status'] == 1,
        role:
            json['sender_id'] == user_id ? MessageRole.user : MessageRole.owner,
      );

  Map<String, dynamic> toJson() => {
        'message_id': messageId,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'message_text': content,
        'sent_at': sentAt.toIso8601String(),
        'read_status': isRead ? 1 : 0,
      };
}
