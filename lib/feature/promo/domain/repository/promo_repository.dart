import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:aitek/api_handle/soap_client.dart';
import 'package:aitek/feature/promo/domain/model/promo_model.dart';
import 'package:xml/xml.dart';


class PromoRepository {
  final SoapClient soapClient;

  PromoRepository({required this.soapClient});

  static const String _namespace = 'http://tempuri.org/';
  static const String _action = 'http://tempuri.org/ICabinetMicroService/GetCCPromo';

  // FIXED: Expanded search footprints to process both raw elements and standard serialized class payloads
  static const List<String> _itemTags = ['CCPromo', 'CCPromoItem', 'CCPromoMaterial', 'PromoItem', 'PromoMaterial', 'item', 'Item'];

  Future<List<PromoItem>> getPromos({String lang = 'en'}) async {
    final result = await soapClient.call(
      soapAction: _action,
      envelope: SoapClient.buildEnvelope(
        namespace: _namespace,
        method: 'GetCCPromo',
        params: {'lang': lang},
      ),
    );

    if (!result.isSuccess) {
      throw Exception(result.errorMessage);
    }

    if (kDebugMode) {
      final allTags = result.document?.descendants
          .whereType<XmlElement>()
          .map((e) => e.name.local)
          .toSet()
          .toList();
      log('====> All XML tags in response: $allTags');
    }

    // Attempt collection mapping traversal across the dynamic schema tag possibilities
    for (final tag in _itemTags) {
      final elements = result.findAll(tag);
      if (elements.isNotEmpty) {
        if (kDebugMode) log('====> Matched <$tag>: ${elements.length} items parsed successfully.');
        return elements.map(PromoItem.fromXml).toList();
      }
    }

    // Dynamic Fallback Matrix: If explicit target contract mappings aren't matched, fallback
    // to scraping directly from the structural layout node of 'GetCCPromoResult'
    final fallbackResultNode = result.findAll('GetCCPromoResult').firstOrNull;
    if (fallbackResultNode != null) {
      final immediateChildren = fallbackResultNode.findElements('*');
      if (immediateChildren.isNotEmpty) {
        if (kDebugMode) log('====> Processing fallback processing node directly from GetCCPromoResult children');
        return immediateChildren.map(PromoItem.fromXml).toList();
      }
    }

    throw Exception('No structured promotional items found within the server response envelope payload.');
  }
}