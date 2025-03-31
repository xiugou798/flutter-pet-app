import 'package:flutter/material.dart';
import 'package:pet_app/pages/root_app.dart';
import 'package:provider/provider.dart';

import '../global_state.dart';
import '../utils/http.dart';
import '../widgets/custom_image.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 用于表单验证的全局key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _username_controller =
  TextEditingController(text: 'admin');
  final TextEditingController _password_controller =
  TextEditingController(text: '123456');
  final TextEditingController _phone_controller =
  TextEditingController(text: '15528731728');

  // 用于保存表单输入的用户名和密码
  // String _username = 'admin';
  // String _password = '123456';
  // String _phone = '15528731728';

  // 模拟登录过程时显示加载
  bool _isLoading = false;

  // 点击登录按钮时调用的提交方法
  Future<void> _submit() async {
    // 先验证表单数据
    if (_formKey.currentState?.validate() ?? false) {
      // 保存表单数据
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true;
      });

      // 模拟网络请求的延迟
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      try {
        final response = await HttpService().post("/api/user/register", data: {
          "user_name": _username_controller.text,
          "user_password": _password_controller.text,
          "user_phone": _phone_controller.text,
          "user_icon": " "
        });
        print(response.data);
        if (response.data['code'] != 200) {
          var _msg = "注册失败！${response.data['msg']}";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_msg),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        var globalState = Provider.of<GlobalState>(context, listen: false);
        // 登录成功后跳转到主页（这里直接使用pushReplacement，可替换为你的主页页面）
        globalState.login();
        globalState.updateUserInfo(response.data['data']);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RootApp()),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登录失败！')),
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('注册'),
              InkWell(
                child: Text('去登录'),
                onTap: ()=>{
                  Navigator.pop(context)
                },
              )

            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            CustomImage(
              'https://images.unsplash.com/photo-1530281700549-e82e7bf110d6?q=80&w=1976&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              radius: 0,
              isShadow: false,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Container(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                      border: Border.all(
                        color: Color(0xffE1E6EF),
                      ),
                      color: Colors.white70),
                  padding: const EdgeInsets.fromLTRB(16, 48, 16, 48),
                  margin: const EdgeInsets.all(16),
                  height: 400,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 用户名输入框
                        TextFormField(
                          controller: _username_controller,
                          decoration: const InputDecoration(
                            labelText: '用户名',
                            border: OutlineInputBorder(),
                          ),
                          // onSaved: (value) {
                          //   _username = value ?? '';
                          // },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入用户名';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // 手机号输入框
                        TextFormField(
                          controller: _phone_controller,
                          decoration: const InputDecoration(
                            labelText: '手机号',
                            border: OutlineInputBorder(),
                          ),
                          // onSaved: (value) {
                          //   _phone = value ?? '';
                          // },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入手机号';
                            }
                            // 正则校验手机号格式
                            final regex = RegExp(r'^1[3-9]\d{9}$');
                            if (!regex.hasMatch(value)) {
                              return '手机号格式不正确';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // 密码输入框
                        TextFormField(
                          controller: _password_controller,
                          decoration: const InputDecoration(
                            labelText: '密码',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          // onSaved: (value) {
                          //   _password = value ?? '';
                          // },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入密码';
                            }
                            if (value.length < 6) {
                              return '密码长度至少6位';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // 登录按钮或加载指示器
                        _isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: const Text('注册'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
