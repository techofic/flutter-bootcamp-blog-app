import 'dart:convert';
import 'dart:io';
import 'package:bootcamp_app/network/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:nb_utils/nb_utils.dart';

class Network {
  static String noInternetMessage = "Check your connection!";

  static getRequest(String endPoint) async {
    if (await isNetworkAvailable()) {
      Response response;

      var headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      print("Headers: $headers");
      response = await get(Uri.parse('${API.BASE_URL}$endPoint'), headers: headers);

      return response;
    } else {
      throw noInternetMessage;
    }
  }

  static postRequest(String endPoint, body) async {
    if (await isNetworkAvailable()) {
      var headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      print('\nURL: ${API.BASE_URL}$endPoint');
      print("Headers: $headers");
      print('Request Body: ${jsonEncode(body)}');

      Response response = await post(Uri.parse(API.BASE_URL + endPoint), body: jsonEncode(body), headers: headers);

      print('Response: $response');

      return response;
    } else {
      throw noInternetMessage;
    }
  }

  static multiPartRequest(String endPoint, String methodName, {Map<String, String>? body, File? file, String fieldName = 'file'}) async {
    if (await isNetworkAvailable()) {
      var request = MultipartRequest(
        methodName.toUpperCase(),
        Uri.parse('${API.BASE_URL}' '$endPoint'),
      );
      print('\nURL: ${API.BASE_URL}$endPoint');

      if (body != null) {
        request.fields.addAll((body));
      }
      if (file != null) {
        request.files.add(await MultipartFile.fromPath(
          fieldName,
          file.path,
          contentType: MediaType(
            mime(file.path)!.split('/')[0],
            mime(file.path)!.split('/')[1],
          ),
        ));
      }
      print('Request Files: ${request.files}');

      print('Headers: ${request.headers}');
      print('Request Fields: ${request.fields}');
      StreamedResponse streamedResponse = await request.send();
      Response response = await Response.fromStream(streamedResponse);
      return response;
    } else {
      throw noInternetMessage;
    }
  }

  static handleResponse(Response response) async {
    if (!await isNetworkAvailable()) {
      toast('No network available');
    } else if (response.statusCode >= 200 && response.statusCode <= 210) {
      print('SuccessCode: ${response.statusCode}');
      print('SuccessResponse: ${response.body}');

      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        return response.body;
      }
    } else {
      print('ErrorCode: ${response.statusCode}');
      print('ErrorResponse: ${response.body}');

      toast('Something went wrong!', bgColor: Colors.red);
    }
  }
}
