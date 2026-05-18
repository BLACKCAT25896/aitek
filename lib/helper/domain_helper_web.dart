import 'package:universal_html/html.dart' as html;

/// Web-specific implementation for domain helper
String getCurrentHost() {
  try {
    return html.window.location.host;
  } catch (e) {
    return 'localhost';
  }
}
