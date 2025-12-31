import 'package:flutter/material.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/ui/pages/home/home_page.dart';
import 'package:kriptum/ui/pages/receive/receive_page.dart';
import 'package:kriptum/ui/pages/send_native/send_native_wrapper_page.dart';
import 'package:kriptum/ui/pages/settings/settings_page.dart';

class HomeWrapperPage extends StatefulWidget {
  const HomeWrapperPage({super.key});

  @override
  State<HomeWrapperPage> createState() => _HomeWrapperPageState();
}

class _HomeWrapperPageState extends State<HomeWrapperPage> {
  int _selectedIndex = 0;
  Future<void> _onItemTapped(int index, BuildContext context) async {
    if (index == 2) {
      await showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SendNativeWrapperPage(),
                    ),
                  );
                },
                child: ListTile(
                  leading: const Icon(Icons.arrow_outward_rounded),
                  title: Text(AppLocalizations.of(context)!.send),
                  subtitle: Text(AppLocalizations.of(context)!.sendCryptoToAccount),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ReceivePage(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  leading: const Icon(Icons.call_received_rounded),
                  title: Text(AppLocalizations.of(context)!.receive),
                  subtitle: Text(AppLocalizations.of(context)!.receiveCrypto),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  final Map pages = {
    0: const HomePage(),
    1: Center(child: Text('Transactions')),
    2: Center(child: Text('Swap')),
    3: Center(child: Text('NFTs')),
    4: const SettingsPage(),
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) => _onItemTapped(value, context),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.wallet),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.compare_arrows),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.screen_search_desktop_sharp),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }
}
