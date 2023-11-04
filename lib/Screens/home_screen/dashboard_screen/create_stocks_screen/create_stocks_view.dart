import 'package:flutter/material.dart';
import 'package:ftc_stocks/Utils/app_formatter.dart';

class CreateStocksView extends StatefulWidget {
  const CreateStocksView({super.key});

  @override
  State<CreateStocksView> createState() => _CreateStocksViewState();
}

class _CreateStocksViewState extends State<CreateStocksView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(GetArgs(context).arguments);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
