import 'package:dio/dio.dart';

class HttpService {
  // 单例模式
  static final HttpService _instance = HttpService._internal();
  late Dio dio;

  factory HttpService() => _instance;

  HttpService._internal() {
    // 基础配置
    BaseOptions options = BaseOptions(
      baseUrl: "http://192.168.95.144:8088/", // 请根据需要修改baseUrl
      connectTimeout: Duration(seconds: 5000),
      receiveTimeout: Duration(seconds: 5000),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    dio = Dio(options);

    // 拦截器：可在此处添加请求前/响应后的公共逻辑
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 在请求发送之前可以加入 token 或其他处理
          // options.headers['Authorization'] = 'Bearer your_token';
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 对响应数据统一处理
          return handler.next(response);
        },
        onError: (DioError error, handler) {
          // 全局错误处理
          return handler.next(error);
        },
      ),
    );
  }

  // GET 请求
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception("GET请求失败: $e");
    }
  }

  // POST 请求
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await dio.post(path, data: data, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception("POST请求失败: $e");
    }
  }

  // PUT 请求
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await dio.put(path, data: data, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception("PUT请求失败: $e");
    }
  }

  // DELETE 请求
  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await dio.delete(path, data: data, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception("DELETE请求失败: $e");
    }
  }
}
