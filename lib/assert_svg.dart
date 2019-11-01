/// Copyright (C), 2018-2019, York
/// FileName: assert_svg.dart
/// Author: York
/// Date: 2019-11-01 11:39
/// Description: AssertSvg is a svgImageProvider for imageWidget
/// License: The AssertSvg was copied and modified from [flutter_svg_provider](https://github.com/yang-f/flutter_svg_provider), Apache License 2.0 Copyright (C) 2018-2019 yang-f

library r_dart_library;

import 'dart:async';
import 'dart:ui' as ui show Codec, Image, Picture, ImageByteFormat;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

class AssertSvg extends ImageProvider<AssertSvg> {
  final String asset;
  final double width;
  final double height;

  const AssertSvg(this.asset, {this.width = 100, this.height = 100})
      : assert(asset != null),
        assert(width != null),
        assert(height != null);

  @override
  Future<AssertSvg> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AssertSvg>(this);
  }

  @override
  ImageStreamCompleter load(AssertSvg key) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: 1.0,
    );
  }

  Future<ui.Codec> _loadAsync(AssertSvg key) async {
    assert(key == this);

    var rawSvg = await rootBundle.loadString(asset);
    final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
    final scale = window.devicePixelRatio;
    final ui.Picture picture = svgRoot.toPicture(
      size: Size(
        width.toDouble() * scale,
        height.toDouble() * scale,
      ),
      clipToViewBox: false,
    );
    var imageW = (width * scale).toInt();
    var imageH = (height * scale).toInt();
    final ui.Image image = await picture.toImage(imageW, imageH);
    var imageData = await image.toByteData(format: ui.ImageByteFormat.png);

    return PaintingBinding.instance.instantiateImageCodec(imageData.buffer.asUint8List());
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final AssertSvg typedOther = other;
    return asset == typedOther.asset && width == typedOther.width && height == typedOther.height;
  }

  @override
  int get hashCode => hashValues(asset.hashCode, width, height, 1.0);

  @override
  String toString() => '$runtimeType(${describeIdentity(asset)}, scale: 1.0)';
}
