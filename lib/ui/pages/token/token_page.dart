import 'package:flutter/material.dart';
import 'package:kriptum/ui/pages/home/widgets/native_token_list_tile.dart';
import 'package:kriptum/ui/pages/receive/receive_page.dart';
import 'package:kriptum/ui/pages/token/widgets/action_button.dart';
import 'package:kriptum/ui/tokens/spacings.dart';

class TokenPage extends StatelessWidget {
  const TokenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'USDT',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Ethereum Mainnet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacings.horizontalPadding),
        child: ListView(
          children: [
            SizedBox(
              height: 250,
              child: Placeholder(),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionButton(
                  label: 'Send',
                  onPressed: () {},
                  icon: Icons.arrow_outward,
                ),
                SizedBox(width: 32),
                ActionButton(
                  label: 'Receive',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const ReceivePage(onlyReceive: true);
                        },
                      ),
                    );
                  },
                  icon: Icons.qr_code,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Your balance',style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),),
            NativeTokenListTile()
          ],
        ),
      ),
    );
  }
}
