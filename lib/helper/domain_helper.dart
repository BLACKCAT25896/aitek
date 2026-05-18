import 'package:flutter/foundation.dart';

// Conditional import for web-only functionality
import 'domain_helper_stub.dart'
if (dart.library.html) 'domain_helper_web.dart' as domain_impl;

/// Handles domain detection for Web.
/// Always keeps the domain EXACTLY as it is (with subdomain).
class DomainHelper {
  static const String _fallbackDomain = 'institute1.com';
  static const String _localhostDomain = 'localhost';
  static const String _vercelDomain = 'vercel.app';
  static const String _demoDomain = 'mightyschool.xyz';
  static const String _demoDomain2 = 'fuedevs.com';

  static String? _cachedDomain;

  /// Returns the exact web host unless it's localhost, vercel or demo domain.
  static String getCurrentDomain() {
    if (_cachedDomain != null) return _cachedDomain!;

    try {
      if (kIsWeb) {
        final host = domain_impl.getCurrentHost();

        if (kDebugMode) {
          print('DomainHelper: Raw host: $host');
        }

        _cachedDomain = _processDomain(host);

        if (kDebugMode) {
          print('DomainHelper: Final domain: $_cachedDomain');
        }

        return _cachedDomain!;
      } else {
        // Non-web always uses fallback
        _cachedDomain = _fallbackDomain;
        return _cachedDomain!;
      }
    } catch (e) {
      if (kDebugMode) print("DomainHelper Error: $e");

      _cachedDomain = _fallbackDomain;
      return _cachedDomain!;
    }
  }

  /// Business logic to keep exact domain unless fallback conditions apply.
  static String _processDomain(String host) {
    // Localhost → fallback
    if (host.contains(_localhostDomain) ||
        host.startsWith('127.') ||
        host.startsWith('0.0.0.0')) {
      return _fallbackDomain;
    }

    // IP address → fallback
    if (_isIpAddress(host)) {
      return _fallbackDomain;
    }

    // Vercel or your demo domains → fallback
    if (host.contains(_vercelDomain) ||
        host.contains(_demoDomain) ||
        host.contains(_demoDomain2)) {
      return _fallbackDomain;
    }

    // 👉 KEEP EXACT FULL HOST (with all subdomains unchanged)
    return host;
  }

  /// Check if string is an IPv4 address.
  static bool _isIpAddress(String host) {
    final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    return ipRegex.hasMatch(host);
  }

  /// Return full domain or subdomain exactly (no splitting).
  static String? getSubdomain() {
    try {
      if (kIsWeb) {
        final host = domain_impl.getCurrentHost();

        if (host.contains(_localhostDomain) ||
            host.contains(_vercelDomain) ||
            host.contains(_demoDomain) ||
            host.contains(_demoDomain2) ||
            _isIpAddress(host)) {
          return null;
        }

        // 👉 Return FULL host (as user requested)
        return host;
      }
    } catch (e) {
      if (kDebugMode) print("DomainHelper Error: $e");
    }

    return null;
  }

  /// Check if environment is localhost.
  static bool isLocalhost() {
    try {
      if (kIsWeb) {
        final host = domain_impl.getCurrentHost();
        return host.contains(_localhostDomain) ||
            host.startsWith('127.') ||
            host.startsWith('0.0.0.0');
      }
    } catch (_) {}
    return false;
  }

  /// Check if domain is Vercel.
  static bool isVercel() {
    try {
      if (kIsWeb) {
        final host = domain_impl.getCurrentHost();
        return host.contains(_vercelDomain);
      }
    } catch (_) {}
    return false;
  }

  /// Clear cached domain.
  static void clearCache() => _cachedDomain = null;

  /// For debugging
  static Map<String, dynamic> getDomainInfo() {
    return {
      'currentDomain': getCurrentDomain(),
      'subdomain': getSubdomain(),
      'isLocalhost': isLocalhost(),
      'isVercel': isVercel(),
      'fallbackDomain': _fallbackDomain,
    };
  }
}
