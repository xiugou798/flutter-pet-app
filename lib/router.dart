import 'package:flutter/material.dart';
import 'package:pet_app/pages/home.dart';
import 'package:pet_app/pages/login.dart';
import 'package:pet_app/pages/pet.dart';
import 'package:pet_app/pages/pet_detail.dart';
import 'package:pet_app/pages/register.dart';
import 'package:pet_app/pages/root_app.dart';
import 'package:pet_app/pages/setting_page.dart';

/// 路由配置项
class RouteConfig {
  final String path;
  final WidgetBuilder builder;

  RouteConfig({required this.path, required this.builder});
}

/// 全局路由配置数组
final List<RouteConfig> routeConfigs = [
  RouteConfig(path: '/', builder: (context) => RootApp()),
  RouteConfig(path: '/home', builder: (context) => HomePage()),
  RouteConfig(path: '/pet_manage', builder: (context) => PetPage()),
  RouteConfig(path: '/chat', builder: (context) => PetPage()),
  RouteConfig(path: '/settings', builder: (context) => SettingsPage()),
  RouteConfig(path: '/login', builder: (context) => LoginPage()),
  RouteConfig(path: '/register', builder: (context) => RegisterPage()),
  RouteConfig(path: '/pet_detail', builder: (context) => PetDetailsPage()),
];

/// 路由生成器，用于管理应用中的路由跳转
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // 获取路由参数（如果有传递参数）
    final args = settings.arguments;

    // 从路由配置数组中查找匹配的路由
    final matchingRoute = routeConfigs.firstWhere(
          (route) => route.path == settings.name,
      orElse: () => RouteConfig(
        path: '/error',
        builder: (context) => _errorPage(),
      ),
    );

    // 如果匹配到错误页面，则直接返回错误页面
    if (matchingRoute.path == '/error') {
      return MaterialPageRoute(builder: (context) => _errorPage());
    }

    return MaterialPageRoute(
      builder: matchingRoute.builder,
      settings: settings,
    );
  }

  /// 未知路由时显示的错误页面
  static Widget _errorPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('错误'),
      ),
      body: Center(
        child: Text('ERROR: 找不到该路由！'),
      ),
    );
  }
}
