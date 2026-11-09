import 'package:byte_budget/services/image_scraper_service.dart';
import 'package:byte_budget/services/component_data_service.dart';

void main() async {
  // Initialize component data
  ComponentDataService.components; // triggers init
  
  print('Starting image scraping for ${ComponentDataService.components.length} components...');
  
  await ImageScraperService.scrapeAllComponentImages();
  
  print('Image scraping complete!');
}