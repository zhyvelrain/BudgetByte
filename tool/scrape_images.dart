import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:byte_budget/services/component_data_service.dart';
import 'package:byte_budget/services/image_scraper_service.dart';
import 'package:byte_budget/services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();

  log('Starting image scraping for ByteBudget components...');
  log('Total components: ${ComponentDataService.components.length}');

  await ImageScraperService.scrapeAllComponentImages();

  log('Image scraping completed!');
  exit(0);
}