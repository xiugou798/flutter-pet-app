import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('用户名'),
            accountEmail: Text('user@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://example.com/user_avatar.png'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('通知设置'),
            onTap: () {
              // 处理通知设置的点击事件
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('隐私设置'),
            onTap: () {
              // 处理隐私设置的点击事件
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('关于'),
            onTap: () {
              // 处理关于的点击事件
            },
          ),
        ],
      ),
    );
  }
}
