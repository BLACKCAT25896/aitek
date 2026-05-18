import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/util/dimensions.dart';
import 'package:mighty_school/util/styles.dart';

class ImageOrGalleryPicker extends StatelessWidget {
  final Function()? cameraClick;
  final Function()? galleryClick;
  const ImageOrGalleryPicker({super.key, this.cameraClick, this.galleryClick});

  @override
  Widget build(BuildContext context) {
    return Container(height: 120,
      decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: const BorderRadius.vertical(top:  Radius.circular(20))),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Row(
        children: [
          Expanded(
            child: InkWell(onTap: cameraClick,
              child: Column(children: [
                Icon(Icons.camera_alt_outlined, size: 50, color: Theme.of(context).highlightColor,),
                Text("camera".tr, style: textRegular,)
              ],),
            ),
          ),

          Expanded(
            child: InkWell(onTap: galleryClick,
              child: Column(children: [
                Icon(Icons.image_outlined, size: 50, color: Theme.of(context).highlightColor,),
                Text("gallery".tr, style: textRegular,)
              ],),
            ),
          ),
        ],
      ),
    ),);
  }
}
