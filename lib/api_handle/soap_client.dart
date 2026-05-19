import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class SoapClient {
  final String baseUrl;
  final int timeoutInSeconds;
  final Map<String, String> extraHeaders;

  static const String _noInternetMessage = 'Connection to API server failed or timed out.';

  const SoapClient({
    required this.baseUrl,
    this.timeoutInSeconds = 30,
    this.extraHeaders = const {},
  });

  Future<SoapResponse> call({
    required String soapAction,
    required String envelope,
    String? overrideUrl,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(overrideUrl ?? baseUrl);

    final Map<String, String> resolvedHeaders = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': '"$soapAction"',
      'Accept': 'text/xml, application/xml',
      // Anti-blocking header to verify traffic passing through corporate application gateways
      'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
      ...extraHeaders,
      ...?headers,
    };

    if (kDebugMode) {
      log('====> SOAP Call: $uri');
      log('====> Headers: $resolvedHeaders');
      log('====> Envelope: $envelope');
    }

    try {
      final http.Response response = await http
          .post(uri, headers: resolvedHeaders, body: envelope)
          .timeout(Duration(seconds: timeoutInSeconds));

      if (kDebugMode) {
        log('====> SOAP Response [${response.statusCode}]: ${response.body}');
      }

      return _handleResponse(response, soapAction);
    } catch (e, stack) {
      if (kDebugMode) {
        log('====> SOAP Error: $e\n$stack');
      }
      return SoapResponse.failure(
        statusCode: 1,
        errorMessage: _noInternetMessage,
        raw: e.toString(),
      );
    }
  }

  /// FIXED: inner parameters are generated without namespace prefixes (e.g. <lang> instead of <tns:lang>)
  /// to conform cleanly to production WCF/WSDL endpoint parameter specifications.
  static String buildEnvelope({
    required String namespace,
    required String method,
    Map<String, String> params = const {},
  }) {
    final paramXml = params.entries
        .map((e) => '<${e.key}>${e.value}</${e.key}>')
        .join('');

    return '<?xml version="1.0" encoding="utf-8"?>'
        '<soap:Envelope '
        'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" '
        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
        'xmlns:xsd="http://www.w3.org/2001/XMLSchema" '
        'xmlns:tns="$namespace">'
        '<soap:Body>'
        '<tns:$method>'
        '$paramXml'
        '</tns:$method>'
        '</soap:Body>'
        '</soap:Envelope>';
  }

  SoapResponse _handleResponse(http.Response response, String action) {
    if (response.statusCode != 200) {
      final faultMsg = _extractFaultMessage(response.body);
      return SoapResponse.failure(
        statusCode: response.statusCode,
        errorMessage: faultMsg ?? 'SOAP HTTP error: ${response.statusCode}',
        raw: response.body,
      );
    }

    try {
      final doc = XmlDocument.parse(response.body);
      return SoapResponse.success(document: doc, raw: response.body);
    } catch (e) {
      return SoapResponse.failure(
        statusCode: response.statusCode,
        errorMessage: 'Failed to parse SOAP XML: $e',
        raw: response.body,
      );
    }
  }

  String? _extractFaultMessage(String body) {
    try {
      final doc = XmlDocument.parse(body);
      return doc.findAllElements('faultstring').firstOrNull?.innerText.trim() ??
          doc.findAllElements('Reason').firstOrNull?.innerText.trim();
    } catch (_) {
      return null;
    }
  }
}

class SoapResponse {
  final bool isSuccess;
  final int statusCode;
  final String? errorMessage;
  final XmlDocument? document;
  final String raw;

  const SoapResponse._({
    required this.isSuccess,
    required this.statusCode,
    required this.raw,
    this.errorMessage,
    this.document,
  });

  factory SoapResponse.success({required XmlDocument document, required String raw}) =>
      SoapResponse._(isSuccess: true, statusCode: 200, document: document, raw: raw);

  factory SoapResponse.failure({required int statusCode, required String errorMessage, String raw = ''}) =>
      SoapResponse._(isSuccess: false, statusCode: statusCode, errorMessage: errorMessage, raw: raw);

  List<XmlElement> findAll(String localName) {
    if (document == null) return [];
    return document!.descendants
        .whereType<XmlElement>()
        .where((element) => element.name.local == localName)
        .toList();
  }

  @override
  String toString() => 'SoapResponse(isSuccess: $isSuccess, statusCode: $statusCode, error: $errorMessage)';
}