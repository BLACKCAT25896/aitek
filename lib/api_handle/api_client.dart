import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:aitek/api_handle/error_response.dart';
import 'package:aitek/util/app_constants.dart';

class ApiClient extends GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;
  final int timeoutInSeconds = 30;

  late String token, tokenTwo;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.token) ?? '';
    tokenTwo = sharedPreferences.getString(AppConstants.tokenTwo) ?? '';
    if(kDebugMode) {
      print('Token: $token');
    }
    updateHeader(
      tokenTwo, sharedPreferences.getString(AppConstants.languageCode) ?? '',
    );
  }

  void updateHeader(String token, String? languageCode, {bool ifPdf = false}) {
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept' : 'application/json',
      'Access-Control-Allow-Origin': '*',
      'passkey' : token,
    };
    _mainHeaders = header;
  }


  Future<Response> getData(String uri, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      if(kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
      }
      http.Response response = await http.get(
        Uri.parse(appBaseUrl+uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }



  Future<Response> getFullUrlData(String uri, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      if(kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
      }
      http.Response response = await http.get(
        Uri.parse(uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      if(kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
        log('====> API Body: $body');
      }
      http.Response response = await http.post(
        Uri.parse(appBaseUrl+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      // _chuckerHttpClient.post(Uri.parse('$appBaseUrl$uri'), body: jsonEncode(body));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }


  Future<Response> postFullUrlData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      if(kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
        log('====> API Body: $body');
      }
      http.Response response = await http.post(
        Uri.parse(uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      // _chuckerHttpClient.post(Uri.parse('$appBaseUrl$uri'), body: jsonEncode(body));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }



  Future<dynamic> fileDownload(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      if(kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
        log('====> API Body: $body');
      }
      http.Response response = await http.post(
        Uri.parse(appBaseUrl+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      // _chuckerHttpClient.post(Uri.parse('$appBaseUrl$uri'), body: jsonEncode(body));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(
      String uri,
      Map<String, String> body,
      List<MultipartBody> multipartBody,
      MultipartBody? logo,
      List<MultipartDocument> otherFile, {
        Map<String, String>? headers,
        MultipartDocument? videoFile,
      }) async {
    try {
      if (kDebugMode) {
        log('====> API Call: $uri');
        log('====> Headers: ${headers ?? _mainHeaders}');
        log('====> Body fields: $body');
      }

      final request = http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      request.headers.addAll(headers ?? _mainHeaders);

      // === Upload Logo ===
      if (logo != null && logo.file != null) {
        Uint8List fileBytes = await logo.file!.readAsBytes();
        final file = http.MultipartFile.fromBytes(
          logo.key,
          fileBytes,
          filename: basename(logo.file!.name),
        );
        request.files.add(file);

        if (kDebugMode) {
          log('[LOGO] key: ${logo.key}, filename: ${basename(logo.file!.name)}, bytes: ${fileBytes.length}');
        }
      }

      // === Upload Images ===
      for (MultipartBody multipart in multipartBody) {
        if (multipart.file != null) {
          Uint8List fileBytes = await multipart.file!.readAsBytes();
          final file = http.MultipartFile.fromBytes(
            multipart.key,
            fileBytes,
            filename: basename(multipart.file!.name),
          );
          request.files.add(file);

          if (kDebugMode) {
            log('[IMAGE] key: ${multipart.key}, filename: ${basename(multipart.file!.name)}, bytes: ${fileBytes.length}');
          }
        }
      }

      // === Upload Other Documents ===
      for (MultipartDocument file in otherFile) {
        if (file.file != null) {
          Uint8List fileBytes = await getFileBytes(file.file!);
          final multipartFile = http.MultipartFile.fromBytes(
            file.key,
            fileBytes,
            filename: file.file!.name,
          );
          request.files.add(multipartFile);

          if (kDebugMode) {
            log('[DOCUMENT] key: ${file.key}[], filename: ${file.file!.name}, bytes: ${fileBytes.length}');
          }
        }
      }

      // === Upload Video File ===
      if (videoFile != null && videoFile.file != null) {
        Uint8List fileBytes = await getFileBytes(videoFile.file!);
        final multipartFile = http.MultipartFile.fromBytes(
          videoFile.key,
          fileBytes,
          filename: videoFile.file!.name,
        );
        request.files.add(multipartFile);

        if (kDebugMode) {
          log('[VIDEO] key: ${videoFile.key}, filename: ${videoFile.file!.name}, bytes: ${fileBytes.length}');
        }
      }

      // === Fields ===
      request.fields.addAll(body);

      // === Summary Log before sending ===
      if (kDebugMode) {
        log('====> Prepared to send ${request.files.length} file(s)');
        for (var f in request.files) {
          log('File attached: key=${f.field}, filename=${f.filename}, length=${f.length}');
        }
      }

      // === Send Request ===
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (kDebugMode) {
        log('====> Response (${response.statusCode}): ${response.body}');
      }

      return handleResponse(response, uri);
    } catch (e, stack) {
      log('Multipart upload failed: $e\n$stack');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Uint8List> getFileBytes(PlatformFile file) async {
    if (kIsWeb) {
      if (file.bytes != null) {
        return file.bytes!;
      } else if (file.readStream != null) {
        final completer = Completer<Uint8List>();
        final chunks = <int>[];
        file.readStream!.listen((data) => chunks.addAll(data),
          onDone: () => completer.complete(Uint8List.fromList(chunks)),
          onError: (e) => completer.completeError(e),
        );
        return completer.future;
      } else {
        throw Exception('File bytes and readStream are both null on web.');
      }
    } else {
      if (file.bytes != null) {
        return file.bytes!;
      } else if (file.path != null) {
        return await io.File(file.path!).readAsBytes();
      } else {
        throw Exception('Invalid file: no bytes, no path, no stream.');
      }
    }
  }




  Future<Response> updateMultipartData(String uri, Map<String, String> body, List<MultipartBody> multipartBody, MultipartBody? logo, List<MultipartDocument> otherFile,  {Map<String, String>? headers}) async {
    try {
      if(kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
        log('====> API Body: $body with ${multipartBody.length} picture');
      }
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(appBaseUrl+uri));
      request.headers.addAll(headers ?? _mainHeaders);




      if(logo != null){
        if(logo.file != null) {
          Uint8List list = await logo.file!.readAsBytes();
          request.files.add(http.MultipartFile(
            logo.key, logo.file!.readAsBytes().asStream(), list.length,
            filename: '${DateTime.now().toString()}.png',
          ));
        }
      }


      for(MultipartBody multipart in multipartBody) {
        if(multipart.file != null) {
          Uint8List list = await multipart.file!.readAsBytes();
          request.files.add(http.MultipartFile(
            multipart.key, multipart.file!.readAsBytes().asStream(), list.length,
            filename: '${DateTime.now().toString()}.png',
          ));
        }
      }

      if(otherFile.isNotEmpty){
        for(MultipartDocument file in otherFile){
          File aaa = File(file.file!.path!);
          Uint8List list0 = await aaa.readAsBytes();
          var part = http.MultipartFile('upload_documents[]', aaa.readAsBytes().asStream(), list0.length, filename: basename(aaa.path));
          request.files.add(part);
        }
      }



      request.fields.addAll(body);
      http.Response response = await http.Response.fromStream(await request.send());
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }


  Future<Response> postMultipartDataConversation(
      String? uri,
      Map<String, String> body,
      List<MultipartBody>? multipartBody,
      {Map<String, String>? headers,PlatformFile? otherFile}) async {

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(appBaseUrl+uri!));
    request.headers.addAll(headers ?? _mainHeaders);

    if(otherFile != null) {
      request.files.add(http.MultipartFile('files[${multipartBody!.length}]', otherFile.readStream!, otherFile.size, filename: basename(otherFile.name)));
    }
    if(multipartBody!=null){
      for(MultipartBody multipart in multipartBody) {
        Uint8List list = await multipart.file!.readAsBytes();
        request.files.add(http.MultipartFile(
          multipart.key, multipart.file!.readAsBytes().asStream(), list.length, filename:'${DateTime.now().toString()}.png',
        ));
      }
    }
    request.fields.addAll(body);
    http.Response response = await http.Response.fromStream(await request.send());
    return handleResponse(response, uri);
  }



  Future<Response> putData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      if(kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
        log('====> API Body: $body');
      }
      http.Response response = await http.put(
        Uri.parse(appBaseUrl+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      // _chuckerHttpClient.put(Uri.parse('$appBaseUrl$uri'), body: jsonEncode(body));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri, {Map<String, String>? headers}) async {
    try {
      if(kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
      }
      http.Response response = await http.delete(
        Uri.parse(appBaseUrl+uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      // _chuckerHttpClient.delete(Uri.parse('$appBaseUrl$uri'));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    // ignore: empty_catches
    }catch(e) {}
    Response localResponse = Response(
      body: body ?? response.body, bodyString: response.body.toString(),
      request: Request(headers: response.request!.headers, method: response.request!.method, url: response.request!.url),
      headers: response.headers, statusCode: response.statusCode, statusText: response.reasonPhrase,
    );
    if(localResponse.statusCode != 200 && localResponse.body != null && localResponse.body is !String) {
      if(localResponse.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(localResponse.body);
        localResponse = Response(statusCode: localResponse.statusCode, body: localResponse.body, statusText: errorResponse.errors![0].message);
      }else if(localResponse.body.toString().startsWith('{message')) {
        localResponse = Response(statusCode: localResponse.statusCode, body: localResponse.body, statusText: localResponse.body['message']);
      }
    }else if(localResponse.statusCode != 200 && localResponse.body == null) {
      localResponse = Response(statusCode: 0, statusText: noInternetMessage);
    }
    if(kDebugMode) {
      log('====> API Response: [${localResponse.statusCode}] $uri\n${localResponse.body}');
    }
    return localResponse;
  }
  Future<Response> uploadFile(String uri, Map<String, String> body, MultipartBody? image, {Map<String, String>? headers}) async {
    try {
      if (kDebugMode) {
        log('====> API Call: $uri\nHeader: $_mainHeaders');
        log('====> API Body: $body with ${image?.key} picture');
      }

      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      request.headers.addAll(headers ?? _mainHeaders);
      if (image != null && image.file != null) {
        Uint8List fileBytes = await image.file!.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          image.key, fileBytes,
          filename: basename(image.file!.name),
        ));
      }
      request.fields.addAll(body);
      http.Response response = await http.Response.fromStream(await request.send());
      return handleResponse(response, uri);
    } catch (e, stack) {
      if (kDebugMode) {
        log("POST error: $e\n$stack");
      }
      return Response(statusCode: 1, statusText: "Upload error: $e");
    }
  }

}

class MultipartBody {
  String key;
  XFile? file;
  MultipartBody(this.key, this.file);
}

class MultipartDocument {
  String key;
  PlatformFile? file;
  MultipartDocument(this.key, this.file);
}
