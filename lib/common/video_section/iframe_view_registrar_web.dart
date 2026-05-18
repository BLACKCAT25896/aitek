// lib/helpers/iframe_registrar_web.dart

// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui;
import 'package:universal_html/html.dart' as html;

final Set<String> _registeredIframeViews = {};

void registerIframe(String url, {required bool interactionEnabled}) {
  final viewId = 'iframe_${url.hashCode}';
  if (_registeredIframeViews.contains(viewId)) return;

  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(viewId, (int _) {
    final iframe = html.IFrameElement()
      ..id = viewId
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.pointerEvents = interactionEnabled ? 'auto' : 'none'
      ..allowFullscreen = true
      ..allow = 'autoplay; fullscreen; encrypted-media';
    return iframe;
  });

  _registeredIframeViews.add(viewId);
}
