import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../services/component_data_service.dart';

/// Service for scraping product images from web retailers
class ImageScraperService {
  static const Map<String, String> _retailerUrls = {
    'SteelSeries': 'https://steelseries.com',
    'Logitech G': 'https://www.logitechg.com',
    'Razer': 'https://www.razer.com',
    'Corsair': 'https://www.corsair.com',
    'HyperX': 'https://www.hyperxgaming.com',
    'ASUS': 'https://rog.asus.com',
    'Acer': 'https://www.acer.com',
    'BenQ': 'https://www.benq.com',
    'LG': 'https://www.lg.com',
    'Samsung': 'https://www.samsung.com',
    'Sennheiser': 'https://www.sennheiser.com',
    'Audio-Technica': 'https://www.audio-technica.com',
    'Blue': 'https://www.bluemic.com',
    'Elgato': 'https://www.elgato.com',
  };

  static const String _userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

  /// Search for product image using DuckDuckGo HTML scrape
  static Future<String?> searchProductImage(
    String productName,
    String brand,
    String category,
  ) async {
    try {
      final query = Uri.encodeComponent('$brand $productName $category product image');
      final url = 'https://duckduckgo.com/html/?q=$query&kl=us-en';
      final response = await http
          .get(
            Uri.parse(url),
            headers: {'User-Agent': _userAgent},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        debugPrint('Image search failed: ${response.statusCode}');
        return null;
      }

      final document = parse(response.body);
      final imageElements = document.querySelectorAll('img.result__image__img');

      for (final img in imageElements) {
        final src = img.attributes['data-src'] ?? img.attributes['src'];
        if (src != null && src.startsWith('http')) {
          return src;
        }
      }

      // Try alternative selector
      final altImages = document.querySelectorAll('img[src^="http"]');
      for (final img in altImages) {
        final src = img.attributes['src'];
        if (src != null &&
            !src.contains('duckduckgo') &&
            !src.contains('icon') &&
            !src.contains('logo')) {
          return src;
        }
      }

      return null;
    } catch (e) {
      debugPrint('Image search error for $productName: $e');
      return null;
    }
  }

  /// Search Google Images (HTML fallback)
  static Future<String?> searchGoogleImages(
    String productName,
    String brand,
    String category,
  ) async {
    try {
      final query = Uri.encodeComponent('$brand $productName $category site:amazon.com OR site:newegg.com OR site:bestbuy.com');
      final url = 'https://www.google.com/search?q=$query&tbm=isch';
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'User-Agent': _userAgent,
              'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final document = parse(response.body);
      final scripts = document.querySelectorAll('script');
      for (final script in scripts) {
        final text = script.text;
        if (text.contains('AF_initDataCallback') && text.contains('"ou"')) {
          // Parse the JavaScript array for image URLs
          final matches = RegExp(r'"ou":"([^"]+)"').allMatches(text);
          for (final match in matches) {
            final url = match.group(1);
            if (url != null && url.startsWith('http')) {
              return url;
            }
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('Google image search error: $e');
      return null;
    }
  }

  /// Fetch product page and extract main image
  static Future<String?> fetchProductPageImage(String productUrl) async {
    try {
      final response = await http
          .get(
            Uri.parse(productUrl),
            headers: {'User-Agent': _userAgent},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final document = parse(response.body);

      // Try Open Graph image first
      final ogImage = document.querySelector('meta[property="og:image"]');
      if (ogImage != null) {
        return ogImage.attributes['content'];
      }

      // Try Twitter card image
      final twitterImage = document.querySelector('meta[name="twitter:image"]');
      if (twitterImage != null) {
        return twitterImage.attributes['content'];
      }

      // Try main product image selectors
      final selectors = [
        '.product-image img',
        '#product-image img',
        '.main-image img',
        '[data-testid="product-image"] img',
        '.product-gallery img',
        '.gallery-image img',
        'img.product-image',
        'img[id*="product"]',
        'img[class*="product"]',
      ];

      for (final selector in selectors) {
        final img = document.querySelector(selector);
        if (img != null) {
          final src = img.attributes['src'] ?? img.attributes['data-src'];
          if (src != null && src.startsWith('http')) return src;
        }
      }

      // Fallback: largest image on page
      final allImages = document.querySelectorAll('img[src^="http"]');
      String? largest;
      int maxArea = 0;
      for (final img in allImages) {
        final src = img.attributes['src'];
        if (src != null && !src.contains('icon') && !src.contains('logo')) {
          final w = int.tryParse(img.attributes['width'] ?? '0') ?? 0;
          final h = int.tryParse(img.attributes['height'] ?? '0') ?? 0;
          if (w * h > maxArea) {
            maxArea = w * h;
            largest = src;
          }
        }
      }
      return largest;
    } catch (e) {
      debugPrint('Product page fetch error: $e');
      return null;
    }
  }

  /// Download and cache image locally
  static Future<String?> downloadAndCacheImage(
    String imageUrl,
    String componentId,
  ) async {
    try {
      final dir = Directory('${Directory.current.path}/assets/images');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final response = await http
          .get(Uri.parse(imageUrl), headers: {'User-Agent': _userAgent})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        final extension = _getImageExtension(imageUrl, response.headers['content-type']);
        final file = File('${dir.path}/$componentId.$extension');
        await file.writeAsBytes(response.bodyBytes);
        return 'assets/images/$componentId.$extension';
      }
    } catch (e) {
      debugPrint('Image download error for $componentId: $e');
    }
    return null;
  }

  static String _getImageExtension(String url, String? contentType) {
    if (contentType != null) {
      if (contentType.contains('jpeg') || contentType.contains('jpg')) return 'jpg';
      if (contentType.contains('png')) return 'png';
      if (contentType.contains('webp')) return 'webp';
      if (contentType.contains('gif')) return 'gif';
    }
    final uri = Uri.parse(url);
    final path = uri.path.toLowerCase();
    if (path.endsWith('.png')) return 'png';
    if (path.endsWith('.webp')) return 'webp';
    if (path.endsWith('.gif')) return 'gif';
    return 'jpg';
  }

  /// Batch scrape images for all components
  static Future<void> scrapeAllComponentImages() async {
    final components = ComponentDataService.components;
    for (final component in components) {
      if (component.images.isEmpty ||
          component.images.first.startsWith('assets/images/')) {
        debugPrint('Scraping image for ${component.name}...');
        String? imageUrl;

        // Try product page first if we have a known retailer URL
        final retailerUrl = _retailerUrls[component.brand];
        if (retailerUrl != null) {
          final searchUrl = '$retailerUrl/search?q=${Uri.encodeComponent(component.name)}';
          imageUrl = await fetchProductPageImage(searchUrl);
        }

        // Fallback to DuckDuckGo search
        imageUrl ??= await searchProductImage(
          component.name,
          component.brand,
          component.category.label,
        );

        // Fallback to Google Images
        imageUrl ??= await searchGoogleImages(
          component.name,
          component.brand,
          component.category.label,
        );

        if (imageUrl != null) {
          final localPath = await downloadAndCacheImage(imageUrl, component.id);
          if (localPath != null) {
            debugPrint('Downloaded image for ${component.name}: $localPath');
          }
        }

        // Rate limiting
        await Future.delayed(const Duration(milliseconds: 1500));
      }
    }
  }
}