import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({required this.text, this.trimLines = 3});
  final String text;
  final int trimLines;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style;
    final style = base.merge(const TextStyle(color: Colors.white70, height: 1.35));
    final dir = Directionality.of(context);
    final textAlign = TextAlign.start;
    final locale = Localizations.maybeLocaleOf(context);
    final scaler = TextScaler.linear(MediaQuery.textScaleFactorOf(context));

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: widget.trimLines,
          textDirection: dir,
          textAlign: textAlign,
          ellipsis: '…',
          locale: locale,
          textScaler: scaler,
        )..layout(maxWidth: constraints.maxWidth);

        final canExpand = painter.didExceedMaxLines;

        final text = Text(
          widget.text,
          maxLines: _expanded ? null : widget.trimLines,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          textAlign: textAlign,
          style: style,
          softWrap: true,
        );

        if (!canExpand) return text;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text,
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: const Text(
                'Read more',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}


