import '../models/app_models.dart';

/// Sample data service with PC peripheral components - 10 curated items
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
        price: 199.99,
        originalPrice: 229.99,
        description:
            'The world\'s fastest mechanical gaming keyboard with OmniPoint 2.0 adjustable switches. Per-key RGB illumination and OLED smart display.',
        images: ['assets/images/kb_001_0.jpg', 'assets/images/kb_001_1.jpg', 'assets/images/kb_001_2.jpg'],
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
      ),
      Component(
        id: 'kb_002',
        name: 'G915 TKL Lightspeed',
        brand: 'Logitech G',
        category: ComponentCategory.keyboard,
        price: 229.99,
        description:
            'Low-profile GL mechanical switches with Lightspeed wireless. 40-hour battery life and premium aluminum alloy design.',
        images: ['assets/images/kb_002_0.jpg', 'assets/images/kb_002_1.jpg', 'assets/images/kb_002_2.jpg'],
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
      ),

      // Mice (2)
      Component(
        id: 'ms_001',
        name: 'DeathAdder V3 Pro',
        brand: 'Razer',
        category: ComponentCategory.mouse,
        price: 159.99,
        description:
            'Ultra-lightweight 63g ergonomic esports mouse with Focus Pro 30K optical sensor. Gen-3 optical switches.',
        images: ['assets/images/ms_001_0.jpg', 'assets/images/ms_001_1.jpg', 'assets/images/ms_001_0.jpg'],
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
      ),
      Component(
        id: 'ms_002',
        name: 'GPX Superlight 2',
        brand: 'Logitech G',
        category: ComponentCategory.mouse,
        price: 159.99,
        originalPrice: 179.99,
        description:
            'Sub-60g wireless gaming mouse with Hero 2 sensor. 95-hour battery and hybrid optical-mechanical switches.',
        images: ['assets/images/ms_002_0.jpg', 'assets/images/ms_002_1.jpg', 'assets/images/ms_002_2.jpg'],
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
      ),

      // Monitors (2)
      Component(
        id: 'mon_001',
        name: 'ROG Swift PG27AQDM',
        brand: 'ASUS',
        category: ComponentCategory.monitor,
        price: 999.99,
        description:
            '26.5" 1440p OLED 240Hz gaming monitor with 0.03ms response time. G-SYNC compatible and true 10-bit color.',
        images: ['assets/images/mon_001_0.jpg', 'assets/images/mon_001_1.jpg', 'assets/images/mon_001_2.jpg'],
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
      ),
      Component(
        id: 'mon_002',
        name: '27GP95R-B',
        brand: 'LG',
        category: ComponentCategory.monitor,
        price: 549.99,
        originalPrice: 649.99,
        description:
            '27" 4K 144Hz Nano IPS with HDMI 2.1. DisplayHDR 600 and 98% DCI-P3 for content creation and gaming.',
        images: ['assets/images/mon_002_0.jpg', 'assets/images/mon_002_1.jpg', 'assets/images/mon_002_0.jpg'],
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
      ),

      // Audio (2)
      Component(
        id: 'aud_001',
        name: 'Arctis Nova Pro Wireless',
        brand: 'SteelSeries',
        category: ComponentCategory.audio,
        price: 349.99,
        description:
            'Premium wireless gaming headset with Active Noise Cancellation. Infinity Power System with hot-swappable batteries.',
        images: ['assets/images/aud_001_0.jpg', 'assets/images/aud_001_1.jpg', 'assets/images/aud_001_2.jpg'],
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
      ),
      Component(
        id: 'aud_002',
        name: 'BlackShark V2 Pro 2023',
        brand: 'Razer',
        category: ComponentCategory.audio,
        price: 199.99,
        description:
            'Ultra-lightweight 282g esports headset with Titanium 50mm drivers. HyperSpeed wireless and 70-hour battery.',
        images: ['assets/images/aud_002_0.jpg', 'assets/images/aud_001_1.jpg', 'assets/images/aud_002_2.jpg'],
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
      ),

      // Camera (1)
      Component(
        id: 'cam_001',
        name: 'Facecam Pro',
        brand: 'Elgato',
        category: ComponentCategory.camera,
        price: 299.99,
        description:
            '4K60/1080p120 studio-grade webcam with Sony STARVIS sensor. Fixed focus f/2.0 lens and uncompressed video.',
        images: ['assets/images/cam_001_0.jpg', 'assets/images/cam_001_1.jpg', 'assets/images/cam_001_2.jpg'],
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
      ),

      // Accessory (1)
      Component(
        id: 'acc_001',
        name: 'QcK Heavy XL',
        brand: 'SteelSeries',
        category: ComponentCategory.accessory,
        price: 29.99,
        description:
            'Extra-thick 6mm micro-woven cloth mousepad. Non-slip rubber base and optimized for low/high DPI tracking.',
        images: ['assets/images/acc_001_0.jpg', 'assets/images/acc_001_1.jpg', 'assets/images/acc_001_2.jpg'],
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
      ),
    ];
    _components = [for (final c in _components) c.copyWith(options: _placeholderVariants(c))];
    _initialized = true;
  }

  // ponytail: placeholder variants (max 3 per item) until real SKUs exist.
  static const _swatches = {'Black': '#1E1E1E', 'White': '#F2F2F2', 'Pink': '#F4A7B9', 'Black/Red': '#5A1A1A'};

  static List<ComponentOption> _placeholderVariants(Component c) {
    final names = [...c.colors, 'Special Edition', 'Pro Bundle'].take(3).toList();
    return [
      for (var i = 0; i < names.length; i++)
        ComponentOption(
          id: '${c.id}_v$i',
          name: names[i],
          type: _swatches.containsKey(names[i]) ? 'color' : 'edition',
          isDefault: i == 0,
          colorHex: _swatches[names[i]],
          // Colorways share the base price; editions cost a little more.
          price: _swatches.containsKey(names[i]) ? c.price : c.price + 20.0 * i,
          originalPrice: _swatches.containsKey(names[i]) ? c.originalPrice : null,
          image: c.images.isEmpty ? null : c.images[i % c.images.length],
        ),
    ];
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