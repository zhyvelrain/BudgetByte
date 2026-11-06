import '../models/app_models.dart';

/// Sample data service with PC peripheral components - 10 curated items
/// Prices are in Philippine Peso (₱)
class ComponentDataService {
  static List<Component> _components = [];
  static bool _initialized = false;

  static List<Component> get components {
    if (!_initialized) _init();
    return _components;
  }

  static void _init() {
    _components = [
      // Keyboards (2)
      Component(
        id: 'kb_001',
        name: 'Apex Pro TKL',
        brand: 'SteelSeries',
        category: ComponentCategory.keyboard,
        price: 11199.00,
        originalPrice: 12879.00,
        description:
            'The world\'s fastest mechanical gaming keyboard with OmniPoint 2.0 adjustable switches. Per-key RGB illumination and OLED smart display.',
        images: ['assets/images/apex_pro_tkl.jpg'],
        specifications: {
          'Switch Type': 'OmniPoint 2.0 Adjustable Mechanical',
          'Actuation Point': '0.2mm - 3.8mm Adjustable',
          'Polling Rate': '1000Hz / 0.5ms',
          'Form Factor': 'TKL (Tenkeyless)',
          'Backlight': 'Per-key RGB',
          'Connectivity': 'USB-C Wired',
          'Wrist Rest': 'Magnetic Detachable',
        },
        colors: ['Black', 'White'],
        isInStock: true,
        stockCount: 45,
        rating: 4.8,
        reviewCount: 2341,
        isFeatured: true,
        discountLabel: '13% OFF',
        options: [
          ComponentOption(
            id: 'kb_001_black',
            name: 'Black',
            type: 'color',
            value: '#000000',
            colorHex: '#000000',
            price: 11199.00,
            isDefault: true,
          ),
          ComponentOption(
            id: 'kb_001_white',
            name: 'White',
            type: 'color',
            value: '#FFFFFF',
            colorHex: '#FFFFFF',
            price: 11199.00,
          ),
        ],
      ),
      Component(
        id: 'kb_002',
        name: 'G915 TKL Lightspeed',
        brand: 'Logitech G',
        category: ComponentCategory.keyboard,
        price: 12879.00,
        description:
            'Low-profile GL mechanical switches with Lightspeed wireless. 40-hour battery life and premium aluminum alloy design.',
        images: ['assets/images/g915_tkl.jpg'],
        specifications: {
          'Switch Type': 'GL Linear / Tactile / Clicky (Low Profile)',
          'Polling Rate': '1000Hz (Lightspeed)',
          'Form Factor': 'TKL',
          'Backlight': 'Per-key LIGHTSYNC RGB',
          'Connectivity': 'Lightspeed Wireless / Bluetooth / USB-C',
          'Battery Life': '40 Hours (RGB On)',
        },
        colors: ['Black', 'White'],
        isInStock: true,
        stockCount: 27,
        rating: 4.7,
        reviewCount: 2156,
        isFeatured: true,
        options: [
          ComponentOption(
            id: 'kb_002_black',
            name: 'Black',
            type: 'color',
            value: '#000000',
            colorHex: '#000000',
            price: 12879.00,
            isDefault: true,
          ),
          ComponentOption(
            id: 'kb_002_white',
            name: 'White',
            type: 'color',
            value: '#FFFFFF',
            colorHex: '#FFFFFF',
            price: 12879.00,
          ),
        ],
      ),

      // Mice (2)
      Component(
        id: 'ms_001',
        name: 'DeathAdder V3 Pro',
        brand: 'Razer',
        category: ComponentCategory.mouse,
        price: 8959.00,
        description:
            'Ultra-lightweight 63g ergonomic esports mouse with Focus Pro 30K optical sensor. Gen-3 optical switches.',
        images: ['assets/images/deathadder_v3_pro.jpg'],
        specifications: {
          'Sensor': 'Focus Pro 30K Optical',
          'DPI': '30,000',
          'Weight': '63g',
          'Switches': 'Gen-3 Optical (90M clicks)',
          'Connectivity': 'HyperSpeed Wireless / USB-C Wired',
          'Battery Life': '90 Hours',
          'Grip Style': 'Palm / Claw',
        },
        colors: ['Black', 'White'],
        isInStock: true,
        stockCount: 67,
        rating: 4.8,
        reviewCount: 3245,
        isFeatured: true,
        options: [
          ComponentOption(
            id: 'ms_001_black',
            name: 'Black',
            type: 'color',
            value: '#000000',
            colorHex: '#000000',
            price: 8959.00,
            isDefault: true,
          ),
          ComponentOption(
            id: 'ms_001_white',
            name: 'White',
            type: 'color',
            value: '#FFFFFF',
            colorHex: '#FFFFFF',
            price: 8959.00,
          ),
        ],
      ),
      Component(
        id: 'ms_002',
        name: 'GPX Superlight 2',
        brand: 'Logitech G',
        category: ComponentCategory.mouse,
        price: 8959.00,
        originalPrice: 10079.00,
        description:
            'Sub-60g wireless gaming mouse with Hero 2 sensor. 95-hour battery and hybrid optical-mechanical switches.',
        images: ['assets/images/gpx_superlight2.jpg'],
        specifications: {
          'Sensor': 'Hero 2 44K',
          'DPI': '44,000',
          'Weight': '60g',
          'Switches': 'Lightforce Hybrid (100M clicks)',
          'Connectivity': 'Lightspeed Wireless / USB-C',
          'Battery Life': '95 Hours',
        },
        colors: ['Black', 'White', 'Pink'],
        isInStock: true,
        stockCount: 54,
        rating: 4.9,
        reviewCount: 4123,
        discountLabel: '11% OFF',
        options: [
          ComponentOption(
            id: 'ms_002_black',
            name: 'Black',
            type: 'color',
            value: '#000000',
            colorHex: '#000000',
            price: 8959.00,
            isDefault: true,
          ),
          ComponentOption(
            id: 'ms_002_white',
            name: 'White',
            type: 'color',
            value: '#FFFFFF',
            colorHex: '#FFFFFF',
            price: 8959.00,
          ),
          ComponentOption(
            id: 'ms_002_pink',
            name: 'Pink',
            type: 'color',
            value: '#FFC0CB',
            colorHex: '#FFC0CB',
            price: 8959.00,
          ),
        ],
      ),

      // Monitors (2)
      Component(
        id: 'mon_001',
        name: 'ROG Swift PG27AQDM',
        brand: 'ASUS',
        category: ComponentCategory.monitor,
        price: 55999.00,
        description:
            '26.5" 1440p OLED 240Hz gaming monitor with 0.03ms response time. G-SYNC compatible and true 10-bit color.',
        images: ['assets/images/pg27aqdm.jpg'],
        specifications: {
          'Panel': '26.5" OLED',
          'Resolution': '2560 x 1440 (QHD)',
          'Refresh Rate': '240Hz',
          'Response Time': '0.03ms (GtG)',
          'HDR': 'HDR10 / True Black 400',
          'Color Gamut': '99% DCI-P3',
          'Connectivity': 'DisplayPort 1.4, HDMI 2.0 x2, USB Hub',
          'Sync': 'G-SYNC Compatible',
        },
        colors: ['Black'],
        isInStock: true,
        stockCount: 12,
        rating: 4.8,
        reviewCount: 567,
        isFeatured: true,
        options: [
          ComponentOption(
            id: 'mon_001_black',
            name: 'Black',
            type: 'color',
            value: '#000000',
            colorHex: '#000000',
            price: 55999.00,
            isDefault: true,
          ),
        ],
      ),
      Component(
        id: 'mon_002',
        name: '27GP95R-B',
        brand: 'LG',
        category: ComponentCategory.monitor,
        price: 30799.00,
        originalPrice: 36399.00,
        description:
            '27" 4K 144Hz Nano IPS with HDMI 2.1. DisplayHDR 600 and 98% DCI-P3 for content creation and gaming.',
        images: ['assets/images/27gp95r.jpg'],
        specifications: {
          'Panel': '27" Nano IPS',
          'Resolution': '3840 x 2160 (4K UHD)',
          'Refresh Rate': '144Hz (OC 160Hz)',
          'Response Time': '1ms (GtG)',
          'HDR': 'DisplayHDR 600',
          'Color Gamut': '98% DCI-P3',
          'Connectivity': 'DP 1.4, HDMI 2.1 x2, USB Hub',
          'Sync': 'FreeSync Premium Pro / G-SYNC Compatible',
        },
        colors: ['Black/Red'],
        isInStock: true,
        stockCount: 19,
        rating: 4.7,
        reviewCount: 892,
        discountLabel: '15% OFF',
        options: [
          ComponentOption(
            id: 'mon_002_blackred',
            name: 'Black/Red',
            type: 'color',
            value: '#000000',
            colorHex: '#000000',
            price: 30799.00,
            isDefault: true,
          ),
        ],
      ),

      // Audio (2)
      Component(
        id: 'aud_001',
        name: 'Arctis Nova Pro Wireless',
        brand: 'SteelSeries',
        category: ComponentCategory.audio,
        price: 19599.00,
        description:
            'Premium wireless gaming headset with Active Noise Cancellation. Infinity Power System with hot-swappable batteries.',
        images: ['assets/images/arctis_nova_pro.jpg'],
        specifications: {
          'Driver': '40mm Neodymium',
          'Frequency Response': '10Hz - 40kHz',
          'Microphone': 'Retractable AI Noise-Canceling',
          'Connectivity': '2.4GHz + Bluetooth 5.3 (Simultaneous)',
          'Battery Life': 'Infinite (Hot-swappable)',
          'ANC': 'Active Noise Cancellation (4-mic)',
          'Weight': '342g',
        },
        colors: ['Black', 'White'],
        isInStock: true,
        stockCount: 28,
        rating: 4.8,
        reviewCount: 1876,
        isFeatured: true,
        options: [
          ComponentOption(
            id: 'aud_001_black',
            name: 'Black',
            type: 'color',
            value: '#000000',
            colorHex: '#000000',
            price: 19599.00,
            isDefault: true,
          ),
          ComponentOption(
            id: 'aud_001_white',
            name: 'White',
            type: 'color',
            value: '#FFFFFF',
            colorHex: '#FFFFFF',
            price: 19599.00,
          ),
        ],
      ),
      Component(
        id: 'aud_002',
        name: 'BlackShark V2 Pro 2023',
        brand: 'Razer',
        category: ComponentCategory.audio,
        price: 11199.00,
        description:
            'Ultra-lightweight 282g esports headset with Titanium 50mm drivers. HyperSpeed wireless and 70-hour battery.',
        images: ['assets/images/blackshark_v2_pro.jpg'],
        specifications: {
          'Driver': 'Titanium 50mm TriForce',
          'Frequency Response': '12Hz - 28kHz',
          'Microphone': 'HyperClear Super Wideband',
          'Connectivity': 'HyperSpeed 2.4GHz / Bluetooth 5.2 / USB-C',
          'Battery Life': '70 Hours',
          'Weight': '282g',
          'THX Spatial Audio': 'Yes',
        },
        colors: ['Black', 'White'],
        isInStock: true,
        stockCount: 41,
        rating: 4.7,
        reviewCount: 2134,
        options: [
          ComponentOption(
            id: 'aud_002_black',
            name: 'Black',
            type: 'color',
            value: '#000000',
            colorHex: '#000000',
            price: 11199.00,
            isDefault: true,
          ),
          ComponentOption(
            id: 'aud_002_white',
            name: 'White',
            type: 'color',
            value: '#FFFFFF',
            colorHex: '#FFFFFF',
            price: 11199.00,
          ),
        ],
      ),

      // Camera (1)
      Component(
        id: 'cam_001',
        name: 'Facecam Pro',
        brand: 'Elgato',
        category: ComponentCategory.camera,
        price: 16799.00,
        description:
            '4K60/1080p120 studio-grade webcam with Sony STARVIS sensor. Fixed focus f/2.0 lens and uncompressed video.',
        images: ['assets/images/facecam_pro.jpg'],
        specifications: {
          'Sensor': 'Sony STARVIS 1/1.8" CMOS',
          'Max Resolution': '4K @ 60fps / 1080p @ 120fps',
          'Lens': 'f/2.0, 90° FOV (Fixed Focus)',
          'Connectivity': 'USB 3.0 (USB-C)',
          'Video Format': 'Uncompressed YUY2 / MJPEG',
          'Privacy': 'Built-in Privacy Cover',
          'Mount': '1/4" Thread + Monitor Mount',
        },
        colors: ['Black'],
        isInStock: true,
        stockCount: 15,
        rating: 4.7,
        reviewCount: 654,
        isFeatured: true,
        options: [
          ComponentOption(
            id: 'cam_001_black',
            name: 'Black',
            type: 'color',
            value: '#000000',
            colorHex: '#000000',
            price: 16799.00,
            isDefault: true,
          ),
        ],
      ),

      // Accessory (1)
      Component(
        id: 'acc_001',
        name: 'QcK Heavy XL',
        brand: 'SteelSeries',
        category: ComponentCategory.accessory,
        price: 1679.00,
        description:
            'Extra-thick 6mm micro-woven cloth mousepad. Non-slip rubber base and optimized for low/high DPI tracking.',
        images: ['assets/images/qck_heavy_xl.jpg'],
        specifications: {
          'Dimensions': '900 x 400 x 6mm',
          'Surface': 'Micro-woven Cloth',
          'Base': 'Non-slip Rubber',
          'Thickness': '6mm (Heavy)',
          'Washable': 'Yes',
        },
        colors: ['Black'],
        isInStock: true,
        stockCount: 123,
        rating: 4.7,
        reviewCount: 3456,
        options: [
          ComponentOption(
            id: 'acc_001_black',
            name: 'Black',
            type: 'color',
            value: '#000000',
            colorHex: '#000000',
            price: 1679.00,
            isDefault: true,
          ),
        ],
      ),
    ];
    _initialized = true;
  }

  static List<Component> getByCategory(ComponentCategory category) {
    if (!_initialized) _init();
    return _components.where((c) => c.category == category).toList();
  }

  static List<Component> getFeatured() {
    if (!_initialized) _init();
    return _components.where((c) => c.isFeatured && c.isInStock).toList();
  }

  static List<Component> getOnSale() {
    if (!_initialized) _init();
    return _components.where((c) => c.hasDiscount && c.isInStock).toList();
  }

  static Component? getById(String id) {
    if (!_initialized) _init();
    try {
      return _components.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<Component> search(String query) {
    if (!_initialized) _init();
    final lowerQuery = query.toLowerCase();
    return _components.where((c) =>
        c.name.toLowerCase().contains(lowerQuery) ||
        c.brand.toLowerCase().contains(lowerQuery) ||
        c.description.toLowerCase().contains(lowerQuery) ||
        c.category.label.toLowerCase().contains(lowerQuery)).toList();
  }

  static List<Component> getInStock() {
    if (!_initialized) _init();
    return _components.where((c) => c.isInStock).toList();
  }
}