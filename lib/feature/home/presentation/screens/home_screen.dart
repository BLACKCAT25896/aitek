import 'package:flutter/material.dart';
import 'package:mighty_school/common/widget/custom_app_bar.dart';
import 'package:mighty_school/feature/home/presentation/widgets/signal_filter_widget.dart';
import 'package:mighty_school/feature/home/presentation/widgets/trading_signal_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "Aitek Ltd.",),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Column(
          children: [
            SignalFilterWidget(),
            SignalListWidget(),
          ],

        ))
      ]),
    );
  }
}
