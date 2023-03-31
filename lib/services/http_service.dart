// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import '../models/app_config.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? _baseUrl;

  HTTPService()
  {
    _appConfig = GetIt.instance.get<AppConfig>();
    _baseUrl = _appConfig!.COIN_API_BASE_URL;
    print('here: $_baseUrl');
  }

  Future<Response?> get(String path) async{
    try{
      //https://api.coingecko.com/api/v3/
      String url = "$_baseUrl$path";
      Response? resp =  await dio.get(url);
      return resp;
    }
    catch(e)
    {
      print('HTTPService: Unable to perform get request');
      print(e);
    }
    return null;
  }

}