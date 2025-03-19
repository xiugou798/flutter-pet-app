import 'package:flutter/material.dart';
import 'package:pet_app/pages/login.dart';
import 'package:provider/provider.dart';

import '../global_state.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var globalState = Provider.of<GlobalState>(context);
    var userInfo = globalState.userInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userInfo['user_name']),
            accountEmail: Text(userInfo['user_phone']),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  NetworkImage(userInfo['user_icon']),
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
          ListTile(
            leading: Icon(Icons.backspace_rounded),
            title: Text('退出登录'),
            onTap: () {
              // 处理关于的点击事件
              globalState.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
