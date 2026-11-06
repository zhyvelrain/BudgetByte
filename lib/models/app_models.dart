import 'package:flutter/material.dart';

/// Component categories for PC peripherals
enum ComponentCategory {
  keyboard('Keyboard', Icons.keyboard_rounded, 0xFF3A8FD6),
  mouse('Mouse', Icons.mouse_rounded, 0xFF5A9FE8),
  monitor('Monitor', Icons.monitor_rounded, 0xFF2AA9A1),
  audio('Audio', Icons.headphones_rounded, 0xFF4AA3D6),
  camera('Camera', Icons.videocam_rounded, 0xFF3A7FD6),
  accessory('Accessory', Icons.devices_other_rounded, 0xFF6AB0E8);

  const ComponentCategory(this.label, this.icon, this.colorValue);
  final String label;
  final IconData icon;
  final int colorValue;

  Color get color => Color(colorValue);
}

/// Brand model
class Brand {
  final String id;
  final String name;
  final String logoUrl;
  final String description;
  final List<ComponentCategory> categories;
  final bool isFeatured;

  Brand({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.categories,
    this.isFeatured = false,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json['id'] as String,
        name: json['name'] as String,
        logoUrl: json['logoUrl'] as String,
        description: json['description'] as String,
        categories: (json['categories'] as List)
            .map((e) => ComponentCategory.values.firstWhere(
                  (c) => c.name == e,
                  orElse: () => ComponentCategory.accessory,
                ))
            .toList(),
        isFeatured: json['isFeatured'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logoUrl': logoUrl,
        'description': description,
        'categories': categories.map((e) => e.name).toList(),
        'isFeatured': isFeatured,
      };
}

/// Component Option model (for variants like color, brand)
class ComponentOption {
  final String id;
  final String name;
  final String type; // 'color', 'brand', 'storage', etc.
  final String? value; // actual value like '#FF0000' for color
  final double? priceAdjustment;
  final bool isDefault;
  // Compatibility fields for screens
  final String? colorHex;
  final double? price;
  final double? originalPrice;
  final String? discountLabel;
  final Map<String, String>? specs;

  ComponentOption({
    required this.id,
    required this.name,
    required this.type,
    this.value,
    this.priceAdjustment,
    this.isDefault = false,
    this.colorHex,
    this.price,
    this.originalPrice,
    this.discountLabel,
    this.specs,
  });

  factory ComponentOption.fromJson(Map<String, dynamic> json) => ComponentOption(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        value: json['value'] as String?,
        priceAdjustment: (json['priceAdjustment'] as num?)?.toDouble(),
        isDefault: json['isDefault'] as bool? ?? false,
        colorHex: json['colorHex'] as String?,
        price: (json['price'] as num?)?.toDouble(),
        originalPrice: (json['originalPrice'] as num?)?.toDouble(),
        discountLabel: json['discountLabel'] as String?,
        specs: json['specs'] != null
            ? Map<String, String>.from(json['specs'] as Map)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'value': value,
        'priceAdjustment': priceAdjustment,
        'isDefault': isDefault,
        'colorHex': colorHex,
        'price': price,
        'originalPrice': originalPrice,
        'discountLabel': discountLabel,
        'specs': specs,
      };
}

/// PC Component model
class Component {
  final String id;
  final String name;
  final String brand;
  final ComponentCategory category;
  final double price;
  final String description;
  final List<String> images;
  final Map<String, String> specifications;
  final List<String> colors;
  final bool isInStock;
  final int stockCount;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final String? discountLabel;
  final double? originalPrice;
  // Options for variants (color, brand, etc.)
  final List<ComponentOption> options;

  Component({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.description,
    required this.images,
    required this.specifications,
    required this.colors,
    required this.isInStock,
    required this.stockCount,
    required this.rating,
    required this.reviewCount,
    this.isFeatured = false,
    this.discountLabel,
    this.originalPrice,
    this.options = const [],
  });

  // Compatibility getters for screens
  Map<String, String> get specs => specifications;
  List<ComponentOption> get variants => options;

  double get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  Component copyWith({
    String? id,
    String? name,
    String? brand,
    ComponentCategory? category,
    double? price,
    String? description,
    List<String>? images,
    Map<String, String>? specifications,
    List<String>? colors,
    bool? isInStock,
    int? stockCount,
    double? rating,
    int? reviewCount,
    bool? isFeatured,
    String? discountLabel,
    double? originalPrice,
    List<ComponentOption>? options,
  }) =>
      Component(
        id: id ?? this.id,
        name: name ?? this.name,
        brand: brand ?? this.brand,
        category: category ?? this.category,
        price: price ?? this.price,
        description: description ?? this.description,
        images: images ?? this.images,
        specifications: specifications ?? this.specifications,
        colors: colors ?? this.colors,
        isInStock: isInStock ?? this.isInStock,
        stockCount: stockCount ?? this.stockCount,
        rating: rating ?? this.rating,
        reviewCount: reviewCount ?? this.reviewCount,
        isFeatured: isFeatured ?? this.isFeatured,
        discountLabel: discountLabel ?? this.discountLabel,
        originalPrice: originalPrice ?? this.originalPrice,
        options: options ?? this.options,
      );

  factory Component.fromJson(Map<String, dynamic> json) => Component(
        id: json['id'] as String,
        name: json['name'] as String,
        brand: json['brand'] as String,
        category: ComponentCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => ComponentCategory.accessory,
        ),
        price: (json['price'] as num).toDouble(),
        description: json['description'] as String,
        images: List<String>.from(json['images'] as List),
        specifications: Map<String, String>.from(json['specifications'] as Map),
        colors: List<String>.from(json['colors'] as List),
        isInStock: json['isInStock'] as bool,
        stockCount: json['stockCount'] as int,
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
        isFeatured: json['isFeatured'] as bool? ?? false,
        discountLabel: json['discountLabel'] as String?,
        originalPrice: (json['originalPrice'] as num?)?.toDouble(),
        options: (json['options'] as List?)
                ?.map((e) => ComponentOption.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'brand': brand,
        'category': category.name,
        'price': price,
        'description': description,
        'images': images,
        'specifications': specifications,
        'colors': colors,
        'isInStock': isInStock,
        'stockCount': stockCount,
        'rating': rating,
        'reviewCount': reviewCount,
        'isFeatured': isFeatured,
        'discountLabel': discountLabel,
        'originalPrice': originalPrice,
        'options': options.map((e) => e.toJson()).toList(),
      };
}

/// Cart Item model
class CartItem {
  final String id;
  final Component component;
  final int quantity;
  final String? selectedColor;
  final Map<String, String>? selectedOptions;
  // Compatibility field for screens - stores selected option name/value as string
  final String? selectedOption;
  // ComponentOption object for detailed option info (color, price, specs)
  final ComponentOption? option;

  CartItem({
    required this.id,
    required this.component,
    required this.quantity,
    this.selectedColor,
    this.selectedOptions,
    this.selectedOption,
    this.option,
  });

  double get unitPrice => option?.price ?? component.price;
  double get subtotal => unitPrice * quantity;
  double get lineTotal => subtotal;
  String? get selectedOptionValue => selectedOption ?? selectedColor;

  CartItem copyWith({
    String? id,
    Component? component,
    int? quantity,
    String? selectedColor,
    Map<String, String>? selectedOptions,
    String? selectedOption,
    ComponentOption? option,
  }) =>
      CartItem(
        id: id ?? this.id,
        component: component ?? this.component,
        quantity: quantity ?? this.quantity,
        selectedColor: selectedColor ?? this.selectedColor,
        selectedOptions: selectedOptions ?? this.selectedOptions,
        selectedOption: selectedOption ?? this.selectedOption,
        option: option ?? this.option,
      );

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'] as String,
        component: Component.fromJson(json['component'] as Map<String, dynamic>),
        quantity: json['quantity'] as int,
        selectedColor: json['selectedColor'] as String?,
        selectedOptions: Map<String, String>.from(json['selectedOptions'] as Map? ?? {}),
        selectedOption: json['selectedOption'] as String?,
        option: json['option'] != null
            ? ComponentOption.fromJson(json['option'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'component': component.toJson(),
        'quantity': quantity,
        'selectedColor': selectedColor,
        'selectedOptions': selectedOptions ?? {},
        'selectedOption': selectedOption,
        'option': option?.toJson(),
      };
}

/// Build Configuration for PC Builder
class BuildConfig {
  final String id;
  final String name;
  final Map<ComponentCategory, Component?> selectedComponents;
  final String? selectedColorTheme;
  final DateTime createdAt;
  final DateTime updatedAt;

  BuildConfig({
    required this.id,
    required this.name,
    required this.selectedComponents,
    this.selectedColorTheme,
    required this.createdAt,
    required this.updatedAt,
  });

  // Alias for compatibility with screens
  BuildConfig get build => this;
  
  double get totalPrice {
    double total = 0;
    for (final component in selectedComponents.values) {
      if (component != null) total += component.price;
    }
    return total;
  }

  int get componentCount {
    int count = 0;
    for (final component in selectedComponents.values) {
      if (component != null) count++;
    }
    return count;
  }

  List<Component> get components =>
      selectedComponents.values.whereType<Component>().toList();

  bool get isComplete =>
      selectedComponents.values.every((c) => c != null);

  BuildConfig copyWith({
    String? id,
    String? name,
    Map<ComponentCategory, Component?>? selectedComponents,
    String? selectedColorTheme,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      BuildConfig(
        id: id ?? this.id,
        name: name ?? this.name,
        selectedComponents: selectedComponents ?? this.selectedComponents,
        selectedColorTheme: selectedColorTheme ?? this.selectedColorTheme,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory BuildConfig.fromJson(Map<String, dynamic> json) {
    final componentsMap = <ComponentCategory, Component?>{};
    final componentsJson = json['selectedComponents'] as Map<String, dynamic>;
    for (final entry in componentsJson.entries) {
      final category = ComponentCategory.values.firstWhere(
        (e) => e.name == entry.key,
        orElse: () => ComponentCategory.accessory,
      );
      if (entry.value != null) {
        componentsMap[category] = Component.fromJson(entry.value as Map<String, dynamic>);
      } else {
        componentsMap[category] = null;
      }
    }
    return BuildConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      selectedComponents: componentsMap,
      selectedColorTheme: json['selectedColorTheme'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final componentsJson = <String, dynamic>{};
    for (final entry in selectedComponents.entries) {
      if (entry.value != null) {
        componentsJson[entry.key.name] = entry.value!.toJson();
      } else {
        componentsJson[entry.key.name] = null;
      }
    }
    return {
      'id': id,
      'name': name,
      'selectedComponents': componentsJson,
      'selectedColorTheme': selectedColorTheme,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Order model for purchase history
class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;
  final DateTime createdAt;
  final OrderStatus status;
  final String? trackingNumber;
  final Address? shippingAddress;
  final PaymentMethod? paymentMethod;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.createdAt,
    required this.status,
    this.trackingNumber,
    this.shippingAddress,
    this.paymentMethod,
  });

  Order copyWith({
    String? id,
    List<CartItem>? items,
    double? subtotal,
    double? tax,
    double? shipping,
    double? total,
    DateTime? createdAt,
    OrderStatus? status,
    String? trackingNumber,
    Address? shippingAddress,
    PaymentMethod? paymentMethod,
  }) =>
      Order(
        id: id ?? this.id,
        items: items ?? this.items,
        subtotal: subtotal ?? this.subtotal,
        tax: tax ?? this.tax,
        shipping: shipping ?? this.shipping,
        total: total ?? this.total,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        trackingNumber: trackingNumber ?? this.trackingNumber,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        paymentMethod: paymentMethod ?? this.paymentMethod,
      );

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String,
        items: (json['items'] as List)
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotal: (json['subtotal'] as num).toDouble(),
        tax: (json['tax'] as num).toDouble(),
        shipping: (json['shipping'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        status: OrderStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => OrderStatus.pending,
        ),
        trackingNumber: json['trackingNumber'] as String?,
        shippingAddress: json['shippingAddress'] != null
            ? Address.fromJson(json['shippingAddress'] as Map<String, dynamic>)
            : null,
        paymentMethod: json['paymentMethod'] != null
            ? PaymentMethod.fromJson(json['paymentMethod'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'tax': tax,
        'shipping': shipping,
        'total': total,
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
        'trackingNumber': trackingNumber,
        'shippingAddress': shippingAddress?.toJson(),
        'paymentMethod': paymentMethod?.toJson(),
      };
}

/// Shipping Address
class Address {
  final String name;
  final String email;
  final String street;
  final String city;
  final String zipCode;
  final String? country;

  Address({
    required this.name,
    required this.email,
    required this.street,
    required this.city,
    required this.zipCode,
    this.country,
  });

  Address copyWith({
    String? name,
    String? email,
    String? street,
    String? city,
    String? zipCode,
    String? country,
  }) =>
      Address(
        name: name ?? this.name,
        email: email ?? this.email,
        street: street ?? this.street,
        city: city ?? this.city,
        zipCode: zipCode ?? this.zipCode,
        country: country ?? this.country,
      );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        name: json['name'] as String,
        email: json['email'] as String,
        street: json['street'] as String,
        city: json['city'] as String,
        zipCode: json['zipCode'] as String,
        country: json['country'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'street': street,
        'city': city,
        'zipCode': zipCode,
        'country': country,
      };
}

/// Payment Method
class PaymentMethod {
  final String type;
  final String last4;
  final String? brand;

  PaymentMethod({
    required this.type,
    required this.last4,
    this.brand,
  });

  PaymentMethod copyWith({
    String? type,
    String? last4,
    String? brand,
  }) =>
      PaymentMethod(
        type: type ?? this.type,
        last4: last4 ?? this.last4,
        brand: brand ?? this.brand,
      );

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        type: json['type'] as String,
        last4: json['last4'] as String,
        brand: json['brand'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'last4': last4,
        'brand': brand,
      };
}

enum OrderStatus {
  pending('Pending', Icons.schedule_rounded),
  confirmed('Confirmed', Icons.check_circle_rounded),
  shipped('Shipped', Icons.local_shipping_rounded),
  delivered('Delivered', Icons.done_all_rounded),
  cancelled('Cancelled', Icons.cancel_rounded);

  const OrderStatus(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// User Preferences
class UserPreferences {
  final String themeMode; // 'light', 'dark', 'system'
  final bool onboardingCompleted;
  final String? preferredCurrency;
  final bool notificationsEnabled;
  final String? preferredLanguage;
  final String? userId;

  UserPreferences({
    this.themeMode = 'system',
    this.onboardingCompleted = false,
    this.preferredCurrency = 'USD',
    this.notificationsEnabled = true,
    this.preferredLanguage = 'en',
    this.userId,
  });

  UserPreferences copyWith({
    String? themeMode,
    bool? onboardingCompleted,
    String? preferredCurrency,
    bool? notificationsEnabled,
    String? preferredLanguage,
    String? userId,
  }) =>
      UserPreferences(
        themeMode: themeMode ?? this.themeMode,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
        preferredCurrency: preferredCurrency ?? this.preferredCurrency,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        preferredLanguage: preferredLanguage ?? this.preferredLanguage,
        userId: userId ?? this.userId,
      );

  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences(
        themeMode: json['themeMode'] as String? ?? 'system',
        onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
        preferredCurrency: json['preferredCurrency'] as String? ?? 'USD',
        notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
        preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
        userId: json['userId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode,
        'onboardingCompleted': onboardingCompleted,
        'preferredCurrency': preferredCurrency,
        'notificationsEnabled': notificationsEnabled,
        'preferredLanguage': preferredLanguage,
        'userId': userId,
      };
}

/// Onboarding slide data
class OnboardingSlide {
  final String title;
  final String description;
  final String imageAsset;
  final Color accentColor;
  final IconData icon;

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.accentColor,
    required this.icon,
  });
}