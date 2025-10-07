import 'package:flutter/material.dart';
import 'package:cointiply_app/core/localization/localization_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainTabPage extends ConsumerStatefulWidget {
  const MainTabPage({super.key});

  @override
  ConsumerState<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends ConsumerState<MainTabPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate('app_title')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.home_max_outlined),
              text: context.translate('home'),
            ),
            Tab(
              icon: const Icon(Icons.settings_outlined),
              text: context.translate('setting'),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: const [SizedBox(), SizedBox()],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 48.0), // moves FAB upward
        child: FloatingActionButton(
          onPressed: _toggleSearch,
          tooltip: context.translate('search'),
          child: const Icon(Icons.search),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      extendBody: true, // allows FAB to float over content
    );
  }
}
