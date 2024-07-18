import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/circular_loading.dart';
import 'package:healthycart_pharmacy/core/custom/no_data/no_data_widget.dart';
import 'package:healthycart_pharmacy/features/pharmacy_profile/application/profile_provider.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminPayment extends StatefulWidget {
  const AdminPayment({super.key});

  @override
  State<AdminPayment> createState() => _AdminPaymentState();
}

class _AdminPaymentState extends State<AdminPayment> {
  final scrollController = ScrollController();
  @override
  void initState() {
    final transProvider = context.read<ProfileProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        transProvider
          ..clearTransactionData()
          ..getAdminTransactions();
      },
    );
    transProvider.transactionInit(
        scrollController: scrollController,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    return Scaffold(
        body: CustomScrollView(
      controller: scrollController,
      slivers: [
        if (provider.fetchLoading == true &&
            provider.adminTransactionList.isEmpty)
          const SliverFillRemaining(
            child: Center(
              child: LoadingIndicater(),
            ),
          )
        else if (provider.adminTransactionList.isEmpty)
          const SliverFillRemaining(
            child: NoDataImageWidget(text: 'No Transactions Found!'),
          )
        else
          SliverPadding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 32),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) => const Gap(5),
              itemCount: provider.adminTransactionList.length,
              itemBuilder: (context, index) {
                final transaction = provider.adminTransactionList[index];
                final formattedDate = DateFormat('dd/MM/yyyy')
                    .format(transaction.dateAndTime!.toDate());

                return Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all()),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('Admin',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(fontSize: 12)),
                          ),
                          Text(
                            formattedDate,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: BColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '₹${transaction.transferAmount}',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(fontSize: 12),
                                    ),
                                    Text(
                                      transaction.transctionType == 'send'
                                          ? 'Send'
                                          : 'Received',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                              color:
                                                  transaction.transctionType ==
                                                          'send'
                                                      ? BColors.red
                                                      : BColors.green,
                                              fontSize: 12),
                                    ),
                                  ],
                                ),
                                if (transaction.transctionType == 'send')
                                  const Gap(10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        SliverToBoxAdapter(
            child: (provider.fetchLoading == true &&
                    provider.adminTransactionList.isNotEmpty)
                ? const Center(child: LoadingIndicater())
                : const Gap(0)),
      ],
    ));
  }
}