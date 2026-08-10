import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ScreenContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const ScreenContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF07100B), AppPalette.black],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.onTap});

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: AppPalette.panel,
        border: Border.all(color: AppPalette.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: card,
    );
  }
}

class GlowHeadlineCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final List<Widget> children;
  const GlowHeadlineCard({super.key, required this.title, required this.subtitle, this.trailing, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF163623), Color(0xFF0B1410), Color(0xFF08100C)],
        ),
        border: Border.all(color: const Color(0xFF235A3A)),
        boxShadow: const [
          BoxShadow(color: Color(0x331BC56A), blurRadius: 30, spreadRadius: 0, offset: Offset(0, 10)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppPalette.muted)),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            if (children.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...children,
            ],
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? caption;
  final Widget? trailing;
  const SectionTitle({super.key, required this.title, this.caption, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              if (caption != null) ...[
                const SizedBox(height: 4),
                Text(caption!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppPalette.muted)),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class MetricPill extends StatelessWidget {
  final String label;
  final String value;
  const MetricPill({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppPalette.panelAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppPalette.muted)),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final Color? color;
  const StatusBadge(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? AppPalette.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: badgeColor.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(color: badgeColor, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class LabelValueRow extends StatelessWidget {
  final String label;
  final String value;
  const LabelValueRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppPalette.muted))),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class ScoreBar extends StatelessWidget {
  final double value;
  final String label;
  const ScoreBar({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final progress = (value / 100).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label)),
            Text(value.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(minHeight: 10, value: progress),
        ),
      ],
    );
  }
}

class DotRank extends StatelessWidget {
  final int rank;
  const DotRank({super.key, required this.rank});

  @override
  Widget build(BuildContext context) => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppPalette.greenSoft,
          border: Border.all(color: AppPalette.green.withOpacity(.35)),
        ),
        alignment: Alignment.center,
        child: Text('$rank', style: const TextStyle(fontWeight: FontWeight.w800)),
      );
}

Color signalColor(String text) {
  switch (text) {
    case 'Breakout':
      return AppPalette.green;
    case 'Momentum':
      return AppPalette.neon;
    case 'Early':
      return AppPalette.warning;
    case 'Watch':
      return AppPalette.muted;
    case 'Risk':
      return AppPalette.danger;
    default:
      return AppPalette.green;
  }
}
