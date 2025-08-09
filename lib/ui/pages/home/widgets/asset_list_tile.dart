import 'package:flutter/material.dart';
import 'package:kriptum/ui/tokens/placeholders.dart';
import 'package:kriptum/ui/widgets/balance_skeleton.dart';

class AssetListTile extends StatelessWidget {
  final String name;
  final String? assetIconUrl;
  final String ticker;
  final String assetBalance;
  final String? networkIconUrl;
  final bool hideBalance;
  final bool loadingBalance;
  final bool errorLoadingBalance;
  final Function()? onTap;
  const AssetListTile({
    super.key,
    this.onTap,
    required this.name,
    this.assetIconUrl,
    required this.ticker,
    required this.assetBalance,
    this.networkIconUrl,
    this.hideBalance = false,
    this.loadingBalance = false,
    this.errorLoadingBalance = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget trailing;
    if (errorLoadingBalance) {
      trailing = Text('Error!');
    } else if (hideBalance) {
      trailing = Text(Placeholders.hiddenBalancePlaceholder);
    } else if (loadingBalance) {
      trailing = BalanceSkeleton();
    } else {
      trailing = Text('$assetBalance $ticker');
    }
    return ListTile(
        onTap: onTap,
        leading: Container(
          constraints: BoxConstraints(maxWidth: 45, maxHeight: 45),
          child: Stack(
            children: [
              Align(child: CircleAvatar()),
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  maxRadius: 8,
                ),
              )
            ],
          ),
        ),
        // leading: Flexible(
        //   child: Stack(
        //     alignment: Alignment.centerLeft,

        //     children: [
        //       // CircleAvatar(),
        //       // Align(

        //       //   alignment: Alignment.topRight,
        //       //   child: SizedBox(
        //       //     width: 10,
        //       //     height: 10,
        //       //     child: Container(color: Colors.amber,),
        //       //   ),
        //       // )
        //     ],
        //   ),
        // ),
        title: Flexible(child: Text(name)),
        trailing: trailing);
  }
}
