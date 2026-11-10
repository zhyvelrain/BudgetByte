import 'dart:io';

import 'package:byte_budget/services/image_scraper_service.dart';
import 'package:byte_budget/services/component_data_service.dart';

Future<void> main() async {
  // Initialize component data
  ComponentDataService.components; // triggers init

  stdout.writeln(
    'Starting image scraping for ${ComponentDataService.components.length} components...',
  );

  await ImageScraperService.scrapeAllComponentImages();

  stdout.writeln('Image scraping complete!');
}