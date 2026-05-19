import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aitek/common/widget/custom_app_bar.dart';
import 'package:aitek/feature/profile/logic/profile_controller.dart';
import 'package:aitek/feature/profile/presentation/widgets/profile_information_widget.dart';
import 'package:aitek/util/dimensions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    if(Get.find<ProfileController>().profileModel == null) {
      Get.find<ProfileController>().getProfileInfo();
      Get.find<ProfileController>().getLastFourNumberPhone();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(title: "profile".tr,),
      body: const CustomScrollView(slivers: [

        SliverToBoxAdapter(child: Padding(
          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ProfileInformationWidget(),


            ],
          ),
        ),)
      ],),
    );
  }
}
