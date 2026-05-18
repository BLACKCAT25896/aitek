import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/feature/home/presentation/widgets/empty_state.dart';
import 'package:mighty_school/feature/home/presentation/widgets/signal_card_widget.dart';
import 'package:mighty_school/feature/profile/logic/profile_controller.dart';

class SignalListWidget extends StatelessWidget {
  const SignalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller) {
        final signals = controller.tradingSignalItems;


        if (signals?.isEmpty == true) {
          return const EmptyState();
        }

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: signals?.length??0,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) => SignalCard(
            signal: signals![index],
            index: index,
          ),
        );
      },
    );
  }
}

