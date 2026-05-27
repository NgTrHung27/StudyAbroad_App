import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CirleAvatarImage extends StatefulWidget {
  final String? avatarImgUrl;
  final String avatarImgPath;
  final double width;
  final double height;

  const CirleAvatarImage({
    super.key,
    required this.avatarImgPath,
    this.width = 50.0,
    this.height = 50.0,
    this.avatarImgUrl,
  });
  @override
  State<CirleAvatarImage> createState() => _CirleAvatarImageState();
}

class _CirleAvatarImageState extends State<CirleAvatarImage> {
  @override
  Widget build(BuildContext context) {
    final isSvg = widget.avatarImgUrl?.toLowerCase().endsWith('.svg') ?? false;

    if (isSvg) {
      return Container(
        height: widget.height,
        width: widget.width,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: SvgPicture.network(
          widget.avatarImgUrl!,
          fit: BoxFit.cover,
          placeholderBuilder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(10.0),
            child: const CircularProgressIndicator(),
          ),
          errorBuilder: (context, error, stackTrace) => Image.asset(
            widget.avatarImgPath,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final ImageProvider<Object> imageWidget = widget.avatarImgUrl != null
        ? CachedNetworkImageProvider(widget.avatarImgUrl!)
            as ImageProvider<Object>
        : AssetImage(widget.avatarImgPath) as ImageProvider<Object>;
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: imageWidget,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
