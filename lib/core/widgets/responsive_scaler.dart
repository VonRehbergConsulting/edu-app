import 'dart:math';

import 'package:flutter/material.dart';

/// Skaliert die fürs Tablet gestaltete Oberfläche auf kleineren Geräten
/// gleichmäßig herunter, damit alles ohne viel Scrollen sichtbar bleibt.
///
/// Die App wird auf einer festen „Design-Fläche" (kleines Tablet, Querformat)
/// gelayoutet und sichtbar so weit verkleinert, dass sie aufs echte Display
/// passt – mit **gleicher Seitenverhältnis-Skalierung** (keine Verzerrung).
/// Geräte, die mindestens die Design-Größe haben (Tablets), bleiben unverändert
/// (Faktor 1). Verhältnismäßig kleine Phones im Querformat werden verkleinert.
class ResponsiveScaler extends StatelessWidget {
  const ResponsiveScaler({super.key, required this.child});

  final Widget child;

  /// Referenz-Fläche im Querformat, für die die Screens gestaltet sind.
  static const _designWidth = 880.0;
  static const _designHeight = 500.0;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    if (size.isEmpty) return child;

    // Nur herunterskalieren (nie hoch): Faktor, damit beide Achsen passen.
    final scale = min(
      1.0,
      min(size.width / _designWidth, size.height / _designHeight),
    );
    if (scale > 0.999) return child;

    // Logische Fläche = echte Größe / scale → identisches Seitenverhältnis,
    // daher skaliert BoxFit.fill exakt uniform (keine Verzerrung, kein Rand).
    final canvas = size / scale;
    return MediaQuery(
      data: mq.copyWith(size: canvas),
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox.fromSize(
          size: canvas,
          child: child,
        ),
      ),
    );
  }
}
