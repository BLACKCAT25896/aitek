import 'package:xml/xml.dart';

class PromoItem {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? linkUrl;
  final String category;
  final String? dateStart;
  final String? dateEnd;

  const PromoItem({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.linkUrl,
    required this.category,
    this.dateStart,
    this.dateEnd,
  });

  /// FIXED: Uses prefix-agnostic extraction (searching solely by the local tag name)
  /// to dynamically shield the engine from changing WCF data contract schema definitions.
  factory PromoItem.fromXml(XmlElement el) {
    String getLocal(String localName) {
      return el.findElements('*')
          .firstWhere(
            (e) => e.name.local == localName,
        orElse: () => XmlElement(XmlName('empty')),
      )
          .innerText
          .trim();
    }

    String fixImage(String url) {
      return url
          .replaceAll('http://forex-images.instaforex.com', 'https://forex-images.ifxdb.com')
          .replaceAll('https://forex-images.instaforex.com', 'https://forex-images.ifxdb.com');
    }

    final rawId = getLocal('Id').isNotEmpty ? getLocal('Id') : getLocal('ID');

    return PromoItem(
      id: rawId.isNotEmpty ? rawId : DateTime.now().microsecondsSinceEpoch.toString(),
      title: getLocal('Title').isNotEmpty ? getLocal('Title') : getLocal('Name'),
      description: getLocal('Description').isNotEmpty ? getLocal('Description') : getLocal('Desc'),
      imageUrl: () {
        final raw = getLocal('ImageUrl').isNotEmpty ? getLocal('ImageUrl') : getLocal('Image');
        return raw.isNotEmpty ? fixImage(raw) : null;
      }(),
      linkUrl: () {
        final raw = getLocal('LinkUrl').isNotEmpty ? getLocal('LinkUrl') : getLocal('Link');
        return raw.isNotEmpty ? raw : null;
      }(),
      category: getLocal('Category').isNotEmpty ? getLocal('Category') : 'Promo',
      dateStart: getLocal('DateStart').isNotEmpty ? getLocal('DateStart') : null,
      dateEnd: getLocal('DateEnd').isNotEmpty ? getLocal('DateEnd') : null,
    );
  }
}