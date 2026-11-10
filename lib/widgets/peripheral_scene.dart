import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../theme/bb_colors.dart';
import '../theme/bb_text.dart';

/// One peripheral slot in the 3D scene.
///
/// A slot is either filled (a [Component] and optionally the chosen
/// [ComponentOption]) or empty. Empty slots are rendered as a dashed
/// silhouette so the scene never looks broken mid-build.
class SceneSlot {
  const SceneSlot({required this.category, this.component, this.option});

  final ComponentCategory category;
  final Component? component;
  final ComponentOption? option;

  bool get isFilled => component != null;

  /// Colour used to tint the model. Falls back to the category accent.
  Color get tint {
    final hex = option?.colorHex;
    if (hex != null) {
      final parsed = _parseHex(hex);
      if (parsed != null) return parsed;
    }
    return category.color;
  }

  /// Builds the six slots for a saved/active build.
  static List<SceneSlot> fromBuild(BuildConfig? build) {
    return [
      for (final category in ComponentCategory.values)
        () {
          final component = build?.selectedComponents[category];
          return SceneSlot(
            category: category,
            component: component,
            option: component?.options.firstOrNull,
          );
        }(),
    ];
  }

  /// Builds a scene from cart lines (one line per category, newest first).
  /// Used by the checkout summary so the finished setup is visible before paying.
  static List<SceneSlot> fromCart(List<CartItem> items) {
    return [
      for (final category in ComponentCategory.values)
        () {
          final matches = items.where((i) => i.component.category == category);
          if (matches.isEmpty) return SceneSlot(category: category);
          final item = matches.first;
          return SceneSlot(
            category: category,
            component: item.component,
            option: item.option,
          );
        }(),
    ];
  }

  static Color? _parseHex(String hex) {
    final cleaned = hex.replaceAll('#', '').trim();
    if (cleaned.length != 6 && cleaned.length != 8) return null;
    final value = int.tryParse(
      cleaned.length == 6 ? 'FF$cleaned' : cleaned,
      radix: 16,
    );
    return value == null ? null : Color(value);
  }
}

/// Live, fully local 3D preview of a peripheral setup.
///
/// Implemented with a small perspective renderer (painter's algorithm +
/// directional lighting) rather than a WebView. That keeps the app offline and
/// working on every Flutter target (including Windows desktop) where WebGL and
/// `<model-viewer>` are not available. A 2D fallback is still provided.
class PeripheralScene extends StatefulWidget {
  const PeripheralScene({
    super.key,
    required this.slots,
    this.height = 220,
    this.showControls = true,
    this.autoRotate = true,
    this.showLegend = false,
    this.themeColor,
  });

  final List<SceneSlot> slots;
  final double height;
  final bool showControls;
  final bool autoRotate;
  final bool showLegend;
  final Color? themeColor;

  @override
  State<PeripheralScene> createState() => _PeripheralSceneState();
}

class _PeripheralSceneState extends State<PeripheralScene>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _spin;
  bool _rotating = true;
  bool _flat = false;
  bool _motionDisabled = false;

  double _yawOffset = -0.42;
  double _pitch = 0.34;
  double _distance = 3.15;
  double _gestureStartDistance = 3.15;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _rotating = widget.autoRotate;
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 48),
    );
    if (_rotating) _spin.repeat();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _spin.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect the OS "reduce motion" setting: no endless auto-spin for users
    // who ask for less animation. The manual orbit gestures still work.
    final disabled = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disabled == _motionDisabled) return;
    _motionDisabled = disabled;
    if (disabled) {
      // Leave the scene at rest and show the "play" affordance; an explicit tap
      // can still start the spin for users who want it.
      _rotating = false;
      _spin.stop();
    } else if (_rotating) {
      _spin.repeat();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Don't burn frames while the app is in the background.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _spin.stop();
    } else if (state == AppLifecycleState.resumed &&
        _rotating &&
        !_motionDisabled) {
      _spin.repeat();
    }
  }

  void _toggleRotation() {
    setState(() {
      if (_rotating) {
        // Fold the current spin phase into the manual offset so the scene
        // doesn't jump when rotation is paused.
        _yawOffset += _spin.value * math.pi * 2;
        _spin.stop();
        _spin.value = 0;
      } else {
        _spin.repeat();
      }
      _rotating = !_rotating;
    });
  }

  void _resetView() {
    setState(() {
      _yawOffset = -0.42;
      _pitch = 0.34;
      _distance = 3.15;
    });
  }

  void _onScaleStart(ScaleStartDetails details) {
    _gestureStartDistance = _distance;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (!widget.showControls) return;
    setState(() {
      if (details.pointerCount > 1) {
        _distance = (_gestureStartDistance / details.scale).clamp(2.05, 5.4);
      } else {
        _yawOffset += details.focalPointDelta.dx * 0.0085;
        _pitch = (_pitch + details.focalPointDelta.dy * 0.0045).clamp(
          0.06,
          1.15,
        );
      }
    });
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (!widget.showControls) return;
    if (event is PointerScrollEvent) {
      setState(() {
        _distance = (_distance + event.scrollDelta.dy * 0.0022).clamp(
          2.05,
          5.4,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(BBColors.radiusLg);

    final scene = _flat
        ? _FlatScene(slots: widget.slots, themeColor: widget.themeColor)
        : AnimatedBuilder(
            animation: _spin,
            builder: (context, _) {
              final yaw = _yawOffset + _spin.value * math.pi * 2;
              return CustomPaint(
                painter: _ScenePainter(
                  slots: widget.slots,
                  yaw: yaw,
                  pitch: _pitch,
                  distance: _distance,
                  isDark: isDark,
                  themeColor: widget.themeColor,
                ),
                size: Size.infinite,
              );
            },
          );

    return Semantics(
      image: true,
      label: _semanticsLabel,
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background stays behind the 2D fallback too.
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? const [Color(0xFF211E1A), Color(0xFF141210)]
                        : const [Color(0xFFFFFFFF), Color(0xFFEDE7DD)],
                  ),
                ),
                child: widget.showControls
                    ? Listener(
                        onPointerSignal: _onPointerSignal,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onScaleStart: _onScaleStart,
                          onScaleUpdate: _onScaleUpdate,
                          onDoubleTap: _resetView,
                          child: scene,
                        ),
                      )
                    : IgnorePointer(child: scene),
              ),
              if (_flat)
                Positioned(
                  top: BBColors.padS,
                  left: BBColors.padS,
                  child: _Chip(
                    icon: Icons.grid_view_rounded,
                    label: '2D fallback view',
                    isDark: isDark,
                  ),
                )
              else
                Positioned(
                  top: BBColors.padS,
                  left: BBColors.padS,
                  child: _Chip(
                    icon: Icons.view_in_ar_rounded,
                    label: widget.showControls ? 'LIVE 3D' : 'YOUR SETUP',
                    isDark: isDark,
                    accent: true,
                  ),
                ),
              if (widget.showControls)
                Positioned(
                  top: BBColors.padS,
                  right: BBColors.padS,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SceneButton(
                        icon: _rotating
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        tooltip: _rotating
                            ? 'Pause rotation'
                            : 'Resume rotation',
                        onTap: _toggleRotation,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 6),
                      _SceneButton(
                        icon: _flat
                            ? Icons.view_in_ar_rounded
                            : Icons.grid_view_rounded,
                        tooltip: _flat ? 'Show 3D view' : 'Show 2D fallback',
                        onTap: () => setState(() => _flat = !_flat),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 6),
                      _SceneButton(
                        icon: Icons.center_focus_strong_rounded,
                        tooltip: 'Reset view',
                        onTap: _resetView,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              if (widget.showControls && !_flat)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: BBColors.padS,
                  child: Center(
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: BBColors.padS,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (isDark ? BBColors.nightBg : BBColors.dayBg)
                              .withValues(alpha: 0.72),
                          borderRadius: BorderRadius.circular(
                            BBColors.radiusFull,
                          ),
                        ),
                        child: Text(
                          'Drag to orbit  ·  Scroll / pinch to zoom',
                          style: BBTextResponsive.labelSmall(
                            context,
                            size: 10,
                            color: BBColors.textMuted(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (widget.showLegend)
                Positioned(
                  left: BBColors.padS,
                  right: BBColors.padS,
                  bottom: widget.showControls ? 28 : BBColors.padS,
                  child: IgnorePointer(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        for (final slot in widget.slots)
                          _SlotDot(slot: slot, isDark: isDark),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String get _semanticsLabel {
    final filled = widget.slots.where((s) => s.isFilled).length;
    final names = widget.slots
        .where((s) => s.isFilled)
        .map((s) => s.component!.name)
        .join(', ');
    return '3D preview of your setup. $filled of ${widget.slots.length} '
        'parts selected.${names.isEmpty ? '' : ' $names.'}';
  }
}

class _SceneButton extends StatelessWidget {
  const _SceneButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.isDark,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: (isDark ? BBColors.nightBg : BBColors.dayBg).withValues(
          alpha: 0.82,
        ),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(icon, size: 17, color: BBColors.textPrimary(context)),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.isDark,
    this.accent = false,
  });

  final IconData icon;
  final String label;
  final bool isDark;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final color = accent
        ? BBColors.readable(context, BBColors.accentBlue)
        : BBColors.textMuted(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isDark ? BBColors.nightBg : BBColors.dayBg).withValues(
          alpha: 0.78,
        ),
        borderRadius: BorderRadius.circular(BBColors.radiusFull),
        border: Border.all(
          color: (isDark ? BBColors.nightDivider : BBColors.dayDivider)
              .withValues(alpha: 0.8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: BBTextResponsive.labelSmall(
              context,
              size: 9,
              color: color,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotDot extends StatelessWidget {
  const _SlotDot({required this.slot, required this.isDark});

  final SceneSlot slot;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final filled = slot.isFilled;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: (isDark ? BBColors.nightBg : BBColors.dayBg).withValues(
          alpha: 0.7,
        ),
        borderRadius: BorderRadius.circular(BBColors.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            filled
                ? Icons.check_circle_rounded
                : Icons.add_circle_outline_rounded,
            size: 10,
            color: filled
                ? BBColors.readable(context, BBColors.accentGreen)
                : BBColors.textMuted(context),
          ),
          const SizedBox(width: 3),
          Text(
            slot.category.label,
            style: BBTextResponsive.labelSmall(
              context,
              size: 9,
              color: filled
                  ? BBColors.textSecondary(context)
                  : BBColors.textMuted(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2D fallback
// ---------------------------------------------------------------------------

class _FlatScene extends StatelessWidget {
  const _FlatScene({required this.slots, this.themeColor});

  final List<SceneSlot> slots;
  final Color? themeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BBColors.padS,
        36,
        BBColors.padS,
        BBColors.padS,
      ),
      child: GridView.count(
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 2.2,
        children: [for (final slot in slots) _FlatTile(slot: slot, themeColor: themeColor)],
      ),
    );
  }
}

class _FlatTile extends StatelessWidget {
  const _FlatTile({required this.slot, this.themeColor});

  final SceneSlot slot;
  final Color? themeColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final image = slot.option?.image ?? slot.component?.images.firstOrNull;
    final tintColor = themeColor ?? slot.tint;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? BBColors.nightSurface : BBColors.daySurface,
        borderRadius: BorderRadius.circular(BBColors.radiusMd),
        border: Border.all(
          color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(BBColors.radiusS),
            child: SizedBox(
              width: 26,
              height: 26,
              child: image != null
                  ? Image.asset(
                      image,
                      fit: BoxFit.cover,
                      cacheWidth: 80,
                      errorBuilder: (_, _, _) => Icon(
                        slot.category.icon,
                        size: 16,
                        color: BBColors.readable(context, tintColor),
                      ),
                    )
                  : Icon(
                      slot.category.icon,
                      size: 16,
                      color: slot.isFilled
                          ? BBColors.readable(context, tintColor)
                          : BBColors.textMuted(context),
                    ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              slot.component?.name ?? slot.category.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: BBTextResponsive.labelSmall(
                context,
                size: 9,
                color: slot.isFilled
                    ? BBColors.textPrimary(context)
                    : BBColors.textMuted(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Renderer
// ---------------------------------------------------------------------------

class _Vec3 {
  const _Vec3(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;

  _Vec3 operator +(_Vec3 other) => _Vec3(x + other.x, y + other.y, z + other.z);
  _Vec3 operator -(_Vec3 other) => _Vec3(x - other.x, y - other.y, z - other.z);
  _Vec3 operator *(double scalar) => _Vec3(x * scalar, y * scalar, z * scalar);

  double dot(_Vec3 other) => x * other.x + y * other.y + z * other.z;

  _Vec3 cross(_Vec3 other) => _Vec3(
    y * other.z - z * other.y,
    z * other.x - x * other.z,
    x * other.y - y * other.x,
  );

  double get length => math.sqrt(x * x + y * y + z * z);

  _Vec3 get normalized {
    final len = length;
    if (len == 0) return this;
    return this * (1 / len);
  }
}

class _Face {
  const _Face(this.points, this.color);

  final List<_Vec3> points;
  final Color color;
}

class _Edge {
  const _Edge(this.a, this.b);

  final _Vec3 a;
  final _Vec3 b;
}

class _ProjectedFace {
  const _ProjectedFace(this.path, this.color, this.depth);

  final Path path;
  final Color color;
  final double depth;
}

class _Camera {
  _Camera({
    required double yaw,
    required double pitch,
    required double distance,
    required Size size,
  }) {
    const target = _Vec3(0, 0.36, 0);
    final cp = math.cos(pitch);
    final sp = math.sin(pitch);
    position =
        target + _Vec3(math.sin(yaw) * cp, sp, math.cos(yaw) * cp) * distance;
    forward = (target - position).normalized;
    right = forward.cross(const _Vec3(0, 1, 0)).normalized;
    up = right.cross(forward).normalized;
    // Fit the desk in both dimensions without cropping tall/narrow viewports.
    focal = math.min(size.width * 1.05, size.height * 1.75);
    center = Offset(size.width / 2, size.height * 0.55);
  }

  late final _Vec3 position;
  late final _Vec3 forward;
  late final _Vec3 right;
  late final _Vec3 up;
  late final double focal;
  late final Offset center;

  Offset? project(_Vec3 point) {
    final relative = point - position;
    final depth = relative.dot(forward);
    if (depth <= 0.08) return null;
    final scale = focal / depth;
    return Offset(
      center.dx + relative.dot(right) * scale,
      center.dy - relative.dot(up) * scale,
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter({
    required this.slots,
    required this.yaw,
    required this.pitch,
    required this.distance,
    required this.isDark,
    this.themeColor,
  });

  final List<SceneSlot> slots;
  final double yaw;
  final double pitch;
  final double distance;
  final bool isDark;
  final Color? themeColor;

  static final _light = const _Vec3(-0.45, 0.82, 0.55).normalized;

  @override
  void paint(Canvas canvas, Size size) {
    final camera = _Camera(
      yaw: yaw,
      pitch: pitch,
      distance: distance,
      size: size,
    );

    _paintBackdrop(canvas, size);

    final faces = _buildScene();
    final projected = <_ProjectedFace>[];

    for (final face in faces) {
      final points = <Offset>[];
      var depth = 0.0;
      var visible = true;
      for (final vertex in face.points) {
        final p = camera.project(vertex);
        if (p == null) {
          visible = false;
          break;
        }
        points.add(p);
        depth += (vertex - camera.position).dot(camera.forward);
      }
      if (!visible || points.length < 3) continue;

      final normal = (face.points[1] - face.points[0]).cross(
        face.points[2] - face.points[0],
      );
      final light = normal.length == 0
          ? 0.65
          : normal.normalized.dot(_light).abs();
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
      projected.add(
        _ProjectedFace(
          path,
          _shade(face.color, 0.58 + 0.42 * light),
          depth / points.length,
        ),
      );
    }

    projected.sort((a, b) => b.depth.compareTo(a.depth));

    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..strokeJoin = StrokeJoin.round
      ..color = isDark
          ? Colors.black.withValues(alpha: 0.35)
          : const Color(0xFF3A342C).withValues(alpha: 0.18);

    for (final face in projected) {
      canvas.drawPath(
        face.path,
        Paint()
          ..style = PaintingStyle.fill
          ..color = face.color,
      );
      canvas.drawPath(face.path, outline);
    }

    _paintPlaceholders(canvas, camera);
    _paintVignette(canvas, size);
  }

  void _paintBackdrop(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final glowCenter = Offset(size.width * 0.5, size.height * 0.42);
    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              BBColors.accentBlue.withValues(alpha: isDark ? 0.20 : 0.12),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: glowCenter,
              radius: size.shortestSide * 0.72,
            ),
          );
    canvas.drawRect(rect, glow);
  }

  void _paintVignette(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            (isDark ? Colors.black : const Color(0xFF7A6A55)).withValues(
              alpha: 0.10,
            ),
          ],
          stops: const [0.62, 1],
        ).createShader(rect),
    );
  }

  void _paintPlaceholders(Canvas canvas, _Camera camera) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round
      ..color = isDark
          ? BBColors.nightTextMuted.withValues(alpha: 0.45)
          : BBColors.dayTextMuted.withValues(alpha: 0.38);

    for (final slot in slots) {
      if (slot.isFilled) continue;
      final box = _placeholderBox(slot.category);
      for (final edge in box) {
        _drawDashed3D(canvas, camera, edge.a, edge.b, paint);
      }
    }
  }

  void _drawDashed3D(
    Canvas canvas,
    _Camera camera,
    _Vec3 a,
    _Vec3 b,
    Paint paint,
  ) {
    const segments = 14;
    for (var i = 0; i < segments; i++) {
      if (i.isOdd) continue;
      final t0 = i / segments;
      final t1 = (i + 1) / segments;
      final p0 = camera.project(a + (b - a) * t0);
      final p1 = camera.project(a + (b - a) * t1);
      if (p0 == null || p1 == null) continue;
      canvas.drawLine(p0, p1, paint);
    }
  }

  Color _shade(Color base, double factor) {
    final hsl = HSLColor.fromColor(base);
    // Preserve hue, nudge saturation down on bright surfaces so whites read
    // as white plastic instead of glowing, and keep a usable contrast range.
    final lightness = (hsl.lightness * factor).clamp(0.045, 0.96);
    final saturation = (hsl.saturation * (isDark ? 0.92 : 0.98)).clamp(
      0.0,
      1.0,
    );
    return hsl.withLightness(lightness).withSaturation(saturation).toColor();
  }

  // -------------------------------------------------------------------------
  // Geometry
  // -------------------------------------------------------------------------

  List<_Face> _buildScene() {
    final faces = <_Face>[];
    final deskTop = isDark ? const Color(0xFF3A342C) : const Color(0xFFDCD3C6);
    final deskEdge = isDark ? const Color(0xFF2A2621) : const Color(0xFFC6BBA9);
    final neutral = isDark ? const Color(0xFF57524A) : const Color(0xFFB8B0A3);

    // Desk slab + front lip.
    _addBox(
      faces,
      const _Vec3(0, -0.07, 0),
      const _Vec3(2.42, 0.09, 1.34),
      deskTop,
    );
    _addBox(
      faces,
      const _Vec3(0, -0.115, 0.66),
      const _Vec3(2.42, 0.02, 0.03),
      deskEdge,
    );
    // Subtle rear riser so the scene has a horizon line.
    _addBox(
      faces,
      const _Vec3(0, 0.02, -0.72),
      const _Vec3(2.42, 0.16, 0.03),
      deskEdge,
    );

    final byCategory = {for (final s in slots) s.category: s};
    
    // Determine color for peripherals - use themeColor if set, otherwise individual slot tints
    Color getPeripheralColor(ComponentCategory category) {
      if (themeColor != null) return themeColor!;
      final slot = byCategory[category];
      return slot?.isFilled == true ? slot!.tint : neutral;
    }

    // Mousepad / accessory sits under the keyboard and mouse.
    final accessory = byCategory[ComponentCategory.accessory];
    final padColor = accessory?.isFilled == true
        ? _mix(getPeripheralColor(ComponentCategory.accessory), neutral, 0.35)
        : _mix(neutral, deskTop, 0.55);
    _addBox(
      faces,
      const _Vec3(0.12, 0.012, 0.34),
      const _Vec3(1.18, 0.014, 0.52),
      padColor,
    );
    _addBox(
      faces,
      const _Vec3(0.12, 0.006, 0.34),
      const _Vec3(1.22, 0.008, 0.56),
      _darken(padColor, 0.2),
    );
    if (accessory?.isFilled == true) {
      // A small cable coil hints that this is the accessory slot.
      _addCylinder(
        faces,
        const _Vec3(-0.38, 0.028, 0.55),
        0.055,
        0.012,
        _darken(padColor, 0.3),
        segments: 12,
      );
    }

    // Monitor.
    final monitorColor = getPeripheralColor(ComponentCategory.monitor);
    _addBox(
      faces,
      const _Vec3(0, 0.025, -0.52),
      const _Vec3(0.52, 0.03, 0.24),
      _darken(neutral, 0.18),
    );
    _addBox(
      faces,
      const _Vec3(0, 0.26, -0.54),
      const _Vec3(0.075, 0.44, 0.07),
      neutral,
    );
    _addBox(
      faces,
      const _Vec3(0, 0.63, -0.52),
      const _Vec3(1.2, 0.64, 0.055),
      _darken(monitorColor, 0.32),
    );
    // Screen surface: dark glass with a tinted reflection band.
    _addBox(
      faces,
      const _Vec3(0, 0.64, -0.488),
      const _Vec3(1.1, 0.55, 0.012),
      _mix(const Color(0xFF101418), monitorColor, 0.12),
    );
    _addBox(
      faces,
      const _Vec3(-0.18, 0.72, -0.48),
      const _Vec3(0.5, 0.16, 0.004),
      _mix(const Color(0xFF1B2A33), monitorColor, 0.28),
    );
    _addBox(
      faces,
      const _Vec3(0.18, 0.52, -0.48),
      const _Vec3(0.62, 0.1, 0.004),
      _mix(const Color(0xFF15222A), monitorColor, 0.22),
    );
    // Brand dot on the chin.
    _addBox(
      faces,
      const _Vec3(0, 0.35, -0.487),
      const _Vec3(0.05, 0.012, 0.006),
      _darken(monitorColor, 0.45),
    );

    // Keyboard.
    final keyboardColor = getPeripheralColor(ComponentCategory.keyboard);
    _addBox(
      faces,
      const _Vec3(0, 0.045, 0.31),
      const _Vec3(0.8, 0.045, 0.27),
      _darken(keyboardColor, 0.22),
    );
    final keyColor = _mix(
      keyboardColor,
      const Color(0xFFF6F2EA),
      isDark ? 0.18 : 0.55,
    );
    for (var row = 0; row < 4; row++) {
      _addBox(
        faces,
        _Vec3(0, 0.073, 0.225 + row * 0.058),
        _Vec3(row == 3 ? 0.34 : 0.7, 0.012, 0.042),
        row == 3 ? _mix(keyColor, keyboardColor, 0.45) : keyColor,
      );
    }
    _addBox(
      faces,
      const _Vec3(-0.29, 0.073, 0.399),
      const _Vec3(0.11, 0.012, 0.042),
      _mix(keyColor, keyboardColor, 0.35),
    );
    _addBox(
      faces,
      const _Vec3(0.29, 0.073, 0.399),
      const _Vec3(0.11, 0.012, 0.042),
      _mix(keyColor, keyboardColor, 0.35),
    );

    // Mouse.
    final mouseColor = getPeripheralColor(ComponentCategory.mouse);
    _addEllipsoid(
      faces,
      const _Vec3(0.66, 0.075, 0.35),
      0.105,
      0.075,
      0.165,
      mouseColor,
    );
    _addBox(
      faces,
      const _Vec3(0.66, 0.128, 0.265),
      const _Vec3(0.035, 0.022, 0.05),
      _darken(mouseColor, 0.4),
    );
    _addBox(
      faces,
      const _Vec3(0.66, 0.06, 0.35),
      const _Vec3(0.19, 0.012, 0.29),
      _darken(mouseColor, 0.28),
    );

    // Headset on a stand.
    final audioColor = getPeripheralColor(ComponentCategory.audio);
    _addBox(
      faces,
      const _Vec3(-0.92, 0.02, 0.02),
      const _Vec3(0.24, 0.03, 0.2),
      _darken(neutral, 0.2),
    );
    _addBox(
      faces,
      const _Vec3(-0.92, 0.27, 0.02),
      const _Vec3(0.035, 0.52, 0.035),
      neutral,
    );
    _addHeadband(faces, const _Vec3(-0.92, 0.56, 0.02), 0.145, audioColor);
    _addCylinder(
      faces,
      const _Vec3(-1.05, 0.45, 0.02),
      0.095,
      0.05,
      _darken(audioColor, 0.18),
      alongX: true,
    );
    _addCylinder(
      faces,
      const _Vec3(-0.79, 0.45, 0.02),
      0.095,
      0.05,
      _darken(audioColor, 0.18),
      alongX: true,
    );
    _addBox(
      faces,
      const _Vec3(-1.12, 0.36, 0.02),
      const _Vec3(0.02, 0.14, 0.02),
      _darken(audioColor, 0.35),
    );

    // Camera on a small tripod.
    final cameraColor = getPeripheralColor(ComponentCategory.camera);
    _addBox(
      faces,
      const _Vec3(0.88, 0.02, -0.3),
      const _Vec3(0.18, 0.025, 0.18),
      _darken(neutral, 0.2),
    );
    _addBox(
      faces,
      const _Vec3(0.88, 0.17, -0.3),
      const _Vec3(0.035, 0.3, 0.035),
      neutral,
    );
    _addBox(
      faces,
      const _Vec3(0.88, 0.36, -0.3),
      const _Vec3(0.23, 0.13, 0.15),
      cameraColor,
    );
    _addCylinder(
      faces,
      const _Vec3(0.88, 0.36, -0.21),
      0.055,
      0.05,
      _darken(cameraColor, 0.3),
      alongZ: true,
    );
    _addCylinder(
      faces,
      const _Vec3(0.88, 0.36, -0.18),
      0.035,
      0.015,
      const Color(0xFF121A22),
      alongZ: true,
    );
    _addBox(
      faces,
      const _Vec3(0.88, 0.44, -0.3),
      const _Vec3(0.03, 0.012, 0.03),
      const Color(0xFFD2453E),
    );

    return faces;
  }

  void _addBox(List<_Face> out, _Vec3 center, _Vec3 size, Color color) {
    final hx = size.x / 2;
    final hy = size.y / 2;
    final hz = size.z / 2;
    final p = [
      _Vec3(center.x - hx, center.y - hy, center.z - hz),
      _Vec3(center.x + hx, center.y - hy, center.z - hz),
      _Vec3(center.x + hx, center.y + hy, center.z - hz),
      _Vec3(center.x - hx, center.y + hy, center.z - hz),
      _Vec3(center.x - hx, center.y - hy, center.z + hz),
      _Vec3(center.x + hx, center.y - hy, center.z + hz),
      _Vec3(center.x + hx, center.y + hy, center.z + hz),
      _Vec3(center.x - hx, center.y + hy, center.z + hz),
    ];
    out
      ..add(_Face([p[0], p[1], p[2], p[3]], color))
      ..add(_Face([p[5], p[4], p[7], p[6]], color))
      ..add(_Face([p[4], p[0], p[3], p[7]], color))
      ..add(_Face([p[1], p[5], p[6], p[2]], color))
      ..add(_Face([p[3], p[2], p[6], p[7]], color))
      ..add(_Face([p[4], p[5], p[1], p[0]], color));
  }

  void _addCylinder(
    List<_Face> out,
    _Vec3 center,
    double radius,
    double height,
    Color color, {
    int segments = 16,
    bool alongX = false,
    bool alongZ = false,
  }) {
    final top = <_Vec3>[];
    final bottom = <_Vec3>[];
    final half = height / 2;
    for (var i = 0; i < segments; i++) {
      final angle = i / segments * math.pi * 2;
      final c = math.cos(angle) * radius;
      final s = math.sin(angle) * radius;
      if (alongX) {
        top.add(_Vec3(center.x + half, center.y + c, center.z + s));
        bottom.add(_Vec3(center.x - half, center.y + c, center.z + s));
      } else if (alongZ) {
        top.add(_Vec3(center.x + c, center.y + s, center.z + half));
        bottom.add(_Vec3(center.x + c, center.y + s, center.z - half));
      } else {
        top.add(_Vec3(center.x + c, center.y + half, center.z + s));
        bottom.add(_Vec3(center.x + c, center.y - half, center.z + s));
      }
    }
    for (var i = 0; i < segments; i++) {
      final next = (i + 1) % segments;
      out.add(_Face([bottom[i], bottom[next], top[next], top[i]], color));
    }
    out
      ..add(_Face(top, _lighten(color, 0.12)))
      ..add(_Face(bottom, _darken(color, 0.18)));
  }

  void _addEllipsoid(
    List<_Face> out,
    _Vec3 center,
    double rx,
    double ry,
    double rz,
    Color color, {
    int segments = 12,
    int rings = 6,
  }) {
    _Vec3 point(int ring, int segment) {
      final phi = ring / rings * math.pi;
      final theta = segment / segments * math.pi * 2;
      return _Vec3(
        center.x + math.sin(phi) * math.cos(theta) * rx,
        center.y + math.cos(phi) * ry,
        center.z + math.sin(phi) * math.sin(theta) * rz,
      );
    }

    for (var ring = 0; ring < rings; ring++) {
      for (var segment = 0; segment < segments; segment++) {
        final a = point(ring, segment);
        final b = point(ring + 1, segment);
        final c = point(ring + 1, segment + 1);
        final d = point(ring, segment + 1);
        if (ring == 0) {
          out.add(_Face([a, c, d], color));
        } else if (ring == rings - 1) {
          out.add(_Face([a, b, d], color));
        } else {
          out.add(_Face([a, b, c, d], color));
        }
      }
    }
  }

  void _addHeadband(List<_Face> out, _Vec3 center, double radius, Color color) {
    const segments = 12;
    for (var i = 0; i < segments; i++) {
      final a0 = math.pi * (i / segments);
      final a1 = math.pi * ((i + 1) / segments);
      final p0 = _Vec3(
        center.x + math.cos(a0) * radius,
        center.y + math.sin(a0) * radius,
        center.z,
      );
      final p1 = _Vec3(
        center.x + math.cos(a1) * radius,
        center.y + math.sin(a1) * radius,
        center.z,
      );
      _addBeam(out, p0, p1, 0.042, color);
    }
  }

  /// A thin square beam between two points, used for the headband arc.
  void _addBeam(
    List<_Face> out,
    _Vec3 a,
    _Vec3 b,
    double thickness,
    Color color,
  ) {
    final direction = (b - a).normalized;
    final side =
        direction.cross(const _Vec3(0, 0, 1)).normalized * (thickness / 2);
    final depth =
        direction.cross(const _Vec3(0, 1, 0)).normalized * (thickness / 2);
    final corners = [
      a - side - depth,
      a + side - depth,
      a + side + depth,
      a - side + depth,
    ];
    final far = [
      b - side - depth,
      b + side - depth,
      b + side + depth,
      b - side + depth,
    ];
    for (var i = 0; i < 4; i++) {
      final next = (i + 1) % 4;
      out.add(_Face([corners[i], corners[next], far[next], far[i]], color));
    }
    out.add(_Face(corners, color));
    out.add(_Face(far, color));
  }

  List<_Edge> _placeholderBox(ComponentCategory category) {
    final (center, size) = switch (category) {
      ComponentCategory.keyboard => (
        const _Vec3(0, 0.05, 0.31),
        const _Vec3(0.82, 0.09, 0.29),
      ),
      ComponentCategory.mouse => (
        const _Vec3(0.66, 0.08, 0.35),
        const _Vec3(0.24, 0.16, 0.34),
      ),
      ComponentCategory.monitor => (
        const _Vec3(0, 0.55, -0.52),
        const _Vec3(1.22, 1.1, 0.22),
      ),
      ComponentCategory.audio => (
        const _Vec3(-0.92, 0.32, 0.02),
        const _Vec3(0.42, 0.64, 0.28),
      ),
      ComponentCategory.camera => (
        const _Vec3(0.88, 0.23, -0.3),
        const _Vec3(0.26, 0.46, 0.22),
      ),
      ComponentCategory.accessory => (
        const _Vec3(0.12, 0.02, 0.34),
        const _Vec3(1.2, 0.03, 0.54),
      ),
    };

    final hx = size.x / 2;
    final hy = size.y / 2;
    final hz = size.z / 2;
    final p = [
      _Vec3(center.x - hx, center.y - hy, center.z - hz),
      _Vec3(center.x + hx, center.y - hy, center.z - hz),
      _Vec3(center.x + hx, center.y + hy, center.z - hz),
      _Vec3(center.x - hx, center.y + hy, center.z - hz),
      _Vec3(center.x - hx, center.y - hy, center.z + hz),
      _Vec3(center.x + hx, center.y - hy, center.z + hz),
      _Vec3(center.x + hx, center.y + hy, center.z + hz),
      _Vec3(center.x - hx, center.y + hy, center.z + hz),
    ];
    const edges = [
      [0, 1],
      [1, 2],
      [2, 3],
      [3, 0],
      [4, 5],
      [5, 6],
      [6, 7],
      [7, 4],
      [0, 4],
      [1, 5],
      [2, 6],
      [3, 7],
    ];
    return [for (final e in edges) _Edge(p[e[0]], p[e[1]])];
  }

  Color _mix(Color a, Color b, double t) => Color.lerp(a, b, t)!;

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) {
    return oldDelegate.yaw != yaw ||
        oldDelegate.pitch != pitch ||
        oldDelegate.distance != distance ||
        oldDelegate.isDark != isDark ||
        oldDelegate.slots != slots ||
        oldDelegate.themeColor != themeColor;
  }
}
