import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fortune_wheel_provider.dart';
import '../../domain/entities/fortune_wheel_reward.dart';

/// Example widget showing how to use the fortune wheel provider
///
/// This demonstrates loading and displaying fortune wheel rewards
class FortuneWheelExample extends ConsumerStatefulWidget {
  const FortuneWheelExample({super.key});

  @override
  ConsumerState<FortuneWheelExample> createState() =>
      _FortuneWheelExampleState();
}

class _FortuneWheelExampleState extends ConsumerState<FortuneWheelExample> {
  @override
  void initState() {
    super.initState();
    
    // Fetch rewards when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fortuneWheelProvider.notifier).fetchFortuneWheelRewards(
            onSuccess: () {
              debugPrint('🎡 Rewards loaded successfully');
            },
            onError: (message) {
              debugPrint('🎡 Error loading rewards: $message');
              // Show error to user
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            },
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fortuneWheelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fortune Wheel Rewards'),
      ),
      body: switch (state) {
        FortuneWheelInitial() => const Center(
            child: Text('Press button to load rewards'),
          ),
        FortuneWheelLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        FortuneWheelLoaded(:final rewards) => _buildRewardsList(rewards),
        FortuneWheelError(:final message, :final isNetworkError) =>
          _buildErrorState(message, isNetworkError),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(fortuneWheelProvider.notifier).fetchFortuneWheelRewards();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildRewardsList(List<FortuneWheelReward> rewards) {
    return ListView.builder(
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final reward = rewards[index];
        return ListTile(
          leading: reward.iconUrl.isNotEmpty
              ? Image.network(
                  reward.iconUrl,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                )
              : const Icon(Icons.card_giftcard),
          title: Text(reward.label),
          subtitle: Text(
            'Type: ${reward.rewardType}\n'
            'Coins: ${reward.rewardCoins.toStringAsFixed(2)}\n'
            'USD: \$${reward.rewardUsd.toStringAsFixed(2)}',
          ),
          trailing: Text('Index: ${reward.wheelIndex}'),
        );
      },
    );
  }

  Widget _buildErrorState(String message, bool isNetworkError) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isNetworkError ? Icons.wifi_off : Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(fortuneWheelProvider.notifier).fetchFortuneWheelRewards();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
