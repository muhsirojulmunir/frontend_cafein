import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

class InstagramCaption extends HookWidget {
  final String username;
  final String caption;
  final int maxLines;

  const InstagramCaption({
    super.key,
    required this.username,
    required this.caption,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          children: [
            TextSpan(
              text: '$username ',
              style: TextStyleApp.bodyTextSmallBold.copyWith(
                color: ColorApp.black,
                fontSize: 15.sp,
              ),
            ),
            TextSpan(
              text: ' $caption',
              style: TextStyleApp.bodyTextSmall.copyWith(color: ColorApp.black),
            ),
          ],
        );

        final tp = TextPainter(
          text: span,
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        final needsReadMore = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              maxLines: isExpanded.value ? null : maxLines,
              overflow: isExpanded.value
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              text: span,
            ),
            if (needsReadMore)
              GestureDetector(
                onTap: () => isExpanded.value = !isExpanded.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    isExpanded.value ? 'lebih sedikit' : 'selengkapnya',
                    style: TextStyleApp.bodyTextSmall.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
