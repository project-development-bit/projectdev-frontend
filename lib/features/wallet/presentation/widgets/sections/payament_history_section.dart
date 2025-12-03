import 'package:cointiply_app/features/wallet/data/models/response/transaction_model.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/transactions_table.dart';
import 'package:flutter/material.dart';

class PayamentHistorySection extends StatelessWidget {
  const PayamentHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TransactionModel> items = [
      TransactionModel(
        id: "1",
        description: "Description1",
        status: "Completed",
        amount: "\$12.50",
        coins: "1500",
        currency: "USD",
        address: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa",
        date: "2025-01-03",
      ),
      TransactionModel(
        id: "2",
        description: "Description2",
        status: "Pending",
        amount: "\$8.00",
        coins: "900",
        currency: "USD",
        address: "3FZbgi29cpjq2GjdwV8eyHuJJnkLtktZc5",
        date: "2025-01-02",
      ),
      TransactionModel(
        id: "3",
        description: "Bonus Reward",
        status: "Completed",
        amount: "\$2.00",
        coins: "300",
        currency: "USD",
        address: "Rewards System",
        date: "2025-01-01",
      ),
      TransactionModel(
        id: "4",
        description: "Deposit",
        status: "Completed",
        amount: "\$50.00",
        coins: "6000",
        currency: "USD",
        address: "Internal Wallet",
        date: "2024-12-29",
      ),
      TransactionModel(
        id: "5",
        description: "Withdrawal",
        status: "Rejected",
        amount: "\$20.00",
        coins: "2400",
        currency: "USD",
        address: "Wallet Rejected",
        date: "2024-12-25",
      ),
    ];

    return TransactionsTable(
      items: items,
    );
  }
}
