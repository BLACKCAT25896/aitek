import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aitek/feature/profile/domain/model/profile_model.dart';
import 'package:aitek/feature/profile/logic/profile_controller.dart';
import 'package:aitek/feature/profile/presentation/widgets/logout_widget.dart';
import 'package:aitek/feature/profile/presentation/widgets/profile_build_card_widget.dart';
import 'package:aitek/util/dimensions.dart';

class ProfileInformationWidget extends StatefulWidget {
  const ProfileInformationWidget({super.key});

  @override
  State<ProfileInformationWidget> createState() =>
      _ProfileInformationWidgetState();
}

class _ProfileInformationWidgetState extends State<ProfileInformationWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _animController;
  Animation<double>? _fadeAnim;
  Animation<Offset>? _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this,
      duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animController!, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08),
      end: Offset.zero).animate(
        CurvedAnimation(parent: _animController!, curve: Curves.easeOut));
    _animController!.forward();
  }

  @override
  void dispose() {
    _animController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
        final ProfileModel? p = profileController.profileModel;

        final String accountType = (p?.type == 1) ? 'Live' : 'Demo';
        final Color accentColor = (p?.type == 1) ? const Color(0xFF00C896) : const Color(0xFF5B8DEF);


        if (_fadeAnim == null || _slideAnim == null) {
          return ProfileBuildCardWidget(p: p, accountType: accountType, accentColor: accentColor);
        }

        return FadeTransition(opacity: _fadeAnim!,
          child: SlideTransition(position: _slideAnim!,
            child: Column(spacing: Dimensions.paddingSizeDefault,
              children: [
                ProfileBuildCardWidget(p: p, accountType: accountType, accentColor: accentColor),
                LogoutButton(accentColor: accentColor),
              ],
            )),
        );
      },
    );
  }


}









