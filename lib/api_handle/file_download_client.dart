
import 'dart:developer';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mighty_school/common/widget/custom_snackbar.dart';
import 'package:mighty_school/feature/authentication/logic/authentication_controller.dart';
import 'package:mighty_school/util/app_constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class ReportDownloader {
  static Future<void> downloadReport({
    required String endpoint,
    required String fileNamePrefix,
    required String fileExtension,
    required String mimeType,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final uri = Uri.parse("${AppConstants.baseUrl}$endpoint");

      final headers = {
        'Accept': mimeType,
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthenticationController>().getToken()}',
      };

      final bodyMap = <String, String>{};
      if (fromDate != null) bodyMap['from_date'] = fromDate;
      if (toDate != null) bodyMap['to_date'] = toDate;


      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        final String fileName = '$fileNamePrefix${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

        if (kIsWeb) {
          final blob = html.Blob([bytes], mimeType);
          final url = html.Url.createObjectUrlFromBlob(blob);
          html.AnchorElement(href: url)
            ..setAttribute("download", fileName)
            ..click();
          html.Url.revokeObjectUrl(url);
        } else {
          final io.Directory dir = await _getSaveDirectory();
          final filePath = io.File('${dir.path}/$fileName');
          await filePath.writeAsBytes(bytes);
          await OpenFile.open(filePath.path);
        }

        showCustomSnackBar("Downloaded successfully".tr, isError: false);
      } else {
        showCustomSnackBar("Download failed".tr);
        log('Status code: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      log('Download error: $e');
      showCustomSnackBar("An error occurred while downloading!".tr);
    }
  }


  static Future<io.Directory> _getSaveDirectory() async {
    if (io.Platform.isAndroid) {
      return io.Directory('/storage/emulated/0/Download');
    } else if (io.Platform.isWindows || io.Platform.isMacOS) {
      return await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }
}

