// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/badge.png
  AssetGenImage get badge => const AssetGenImage('assets/images/badge.png');

  /// File path: assets/images/bg_home.png
  AssetGenImage get bgHome => const AssetGenImage('assets/images/bg_home.png');

  /// File path: assets/images/ic_cafein.png
  AssetGenImage get icCafein =>
      const AssetGenImage('assets/images/ic_cafein.png');

  /// File path: assets/images/img_contoh_share.png
  AssetGenImage get imgContohShare =>
      const AssetGenImage('assets/images/img_contoh_share.png');

  /// File path: assets/images/img_empty.png
  AssetGenImage get imgEmpty =>
      const AssetGenImage('assets/images/img_empty.png');

  /// File path: assets/images/img_logo_cafein.png
  AssetGenImage get imgLogoCafein =>
      const AssetGenImage('assets/images/img_logo_cafein.png');

  /// File path: assets/images/img_logo_cafein_login.png
  AssetGenImage get imgLogoCafeinLogin =>
      const AssetGenImage('assets/images/img_logo_cafein_login.png');

  /// File path: assets/images/img_logo_cafein_splash.png
  AssetGenImage get imgLogoCafeinSplash =>
      const AssetGenImage('assets/images/img_logo_cafein_splash.png');

  /// File path: assets/images/img_logoberandacafein.png
  AssetGenImage get imgLogoberandacafein =>
      const AssetGenImage('assets/images/img_logoberandacafein.png');

  /// File path: assets/images/img_media.png
  AssetGenImage get imgMedia =>
      const AssetGenImage('assets/images/img_media.png');

  /// File path: assets/images/img_ob_collab.png
  AssetGenImage get imgObCollab =>
      const AssetGenImage('assets/images/img_ob_collab.png');

  /// File path: assets/images/img_ob_hub.png
  AssetGenImage get imgObHub =>
      const AssetGenImage('assets/images/img_ob_hub.png');

  /// File path: assets/images/img_ob_info.png
  AssetGenImage get imgObInfo =>
      const AssetGenImage('assets/images/img_ob_info.png');

  /// File path: assets/images/img_pelatihan.png
  AssetGenImage get imgPelatihan =>
      const AssetGenImage('assets/images/img_pelatihan.png');

  /// File path: assets/images/img_podcast.png
  AssetGenImage get imgPodcast =>
      const AssetGenImage('assets/images/img_podcast.png');

  /// File path: assets/images/img_powershare.png
  AssetGenImage get imgPowershare =>
      const AssetGenImage('assets/images/img_powershare.png');

  /// File path: assets/images/img_regulasi.png
  AssetGenImage get imgRegulasi =>
      const AssetGenImage('assets/images/img_regulasi.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    badge,
    bgHome,
    icCafein,
    imgContohShare,
    imgEmpty,
    imgLogoCafein,
    imgLogoCafeinLogin,
    imgLogoCafeinSplash,
    imgLogoberandacafein,
    imgMedia,
    imgObCollab,
    imgObHub,
    imgObInfo,
    imgPelatihan,
    imgPodcast,
    imgPowershare,
    imgRegulasi,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
