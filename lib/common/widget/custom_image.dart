import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../util/images.dart';

class CustomImage extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double radius;
  final String placeholder;
  final String? svg;
  final bool? forCircleImage;
  final bool isLoading;
  final bool showLoader;
  final bool showTapToImageView;
  final bool localAsset;
  final Color? localAssetColor;
  const CustomImage({
    super.key,
    this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder = Images.placeholder,
    this.radius = 0,
    this.svg,
    this.forCircleImage,
    this.isLoading = false,
    this.showLoader = true, this.showTapToImageView = false,  this.localAsset  = false, this.localAssetColor,
  });

  @override
  Widget build(BuildContext context) {
    return localAsset? ClipRRect(borderRadius: BorderRadius.circular(radius),
        child: Image.asset(image!, fit: BoxFit.cover, height: height, width: width, color: localAssetColor,)):
      svg != null ?
    SvgPicture.asset(svg!, height: height, width: width, fit: fit,) :
    ClipRRect(borderRadius: BorderRadius.circular(radius),
      child: forCircleImage == true ?
      ClipRRect(borderRadius: BorderRadius.circular(height ?? 0.toDouble()),
        child:image!=null?
        CachedNetworkImage(imageUrl: image!, height: height, width: width, fit: fit,
            placeholder: (context, url) => Stack(children: [
              Image.asset(placeholder, height: height, width:width, fit: BoxFit.cover),
              const Align(alignment: Alignment.center, child: Center(child: CircularProgressIndicator(color: Colors.white,)))]),
            errorWidget: (context, url, error) => Image.asset(placeholder, height: height, width: width, fit: BoxFit.cover)):
        Image.asset(placeholder, height: height, width: Get.width, fit: BoxFit.cover)) :
      image!=null?
      CachedNetworkImage(imageUrl: image!, height: height, width: width, fit: fit,
        placeholder: (context, url) => Stack(children: [
          Image.asset(placeholder, height: height, width: width, fit: BoxFit.cover),
          if(isLoading)
            const Align(alignment: Alignment.center, child: Center(child: CircularProgressIndicator()))]),
        errorWidget: (context, url, error) => Image.asset(placeholder, height: height, width: width, fit: BoxFit.cover),

      ) : Image.asset(placeholder, height: height, width: width, fit: BoxFit.cover) ,
    );
  }
}
