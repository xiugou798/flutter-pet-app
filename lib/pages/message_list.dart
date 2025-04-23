import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/pages/chat_owner_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../global_state.dart';
import '../utils/http.dart';

/// 会话列表模型
class ConversationListItem {
  // final int listId;
  final int userId;
  final int conversationId;
  final int peerIds;
  final String peerName;
  final int lastMessageId;
  final String lastMessageText;
  final DateTime lastSentAt;
  final int unreadCount;

  ConversationListItem({
    // required this.listId,
    required this.userId,
    required this.conversationId,
    required this.peerIds,
    required this.peerName,
    required this.lastMessageId,
    required this.lastMessageText,
    required this.lastSentAt,
    required this.unreadCount,
  });

  factory ConversationListItem.fromJson(Map<String, dynamic> json) {
    return ConversationListItem(
      // listId: json['list_id'],
      userId: json['user_id'],
      conversationId: json['conversation_id'],
      peerIds: json['peer_ids'],
      peerName: json['peer_name'],
      lastMessageId: json['last_message_id'],
      lastMessageText: json['last_message_text'],
      lastSentAt: DateTime.parse(json['last_sent_at']),
      unreadCount: json['unread_count'],
    );
  }

  Map<String, dynamic> toJson() => {
        // 'list_id': listId,
        'user_id': userId,
        'conversation_id': conversationId,
        'peer_ids': peerIds,
        'peer_name': peerName,
        'last_message_id': lastMessageId,
        'last_message_text': lastMessageText,
        'last_sent_at': lastSentAt.toIso8601String(),
        'unread_count': unreadCount,
      };
}

/// 消息列表页面
class MessageListPage extends StatefulWidget {
  const MessageListPage({Key? key}) : super(key: key);

  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  late Future<List<ConversationListItem>> _futureList;

  @override
  void initState() {
    super.initState();
    _futureList = fetchConversationList();
  }

  /// 从服务器拉取会话列表
  Future<List<ConversationListItem>> fetchConversationList() async {
    var globalState = Provider.of<GlobalState>(context, listen: false);
    final response = await HttpService().get(
        "/api/user_conversation_list/list?user_id=${globalState.userInfo['id']}");
    print(response.data['data']['list']);
    List data = response.data['data']['list'];

    return data.map((e) => ConversationListItem.fromJson(e)).toList();
  }

  String _formatTime(DateTime dt) => DateFormat('MM/dd HH:mm').format(dt);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('消息列表')),
      body: FutureBuilder<List<ConversationListItem>>(
        future: _futureList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('加载失败：${snapshot.toString()}'));
          }
          final list = snapshot.data!;
          if (list.isEmpty) {
            return const Center(child: Text('暂无会话'));
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = list[index];
              // TODO: 根据 peerIds 加载头像或名称，此处使用占位图标与文字
              final peers = item.peerName;

              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.pets),
                ),
                title: Text(
                  peers,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  item.lastMessageText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(item.lastSentAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (item.unreadCount > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.unreadCount.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  // TODO: 点击进入聊天页面，传递 conversationId
                  // Navigator.push(...);
                  print("item:conversationId:${item.conversationId}");
                  print("item:peerName:${item.peerName}");
                  Navigator.of(context).pushNamed("/chat_owner", arguments: {
                    "conversation_id": item.conversationId,
                    "peer_name": item.peerName,
                    'peer_ids': item.peerIds
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}

// 注意：请在 pubspec.yaml 中添加 intl 依赖：
// dependencies:
//   intl: ^0.17.0
