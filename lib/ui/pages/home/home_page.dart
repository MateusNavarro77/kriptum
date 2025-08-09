import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/current_account/current_account_cubit.dart';
import 'package:kriptum/blocs/current_network/current_network_cubit.dart';
import 'package:kriptum/blocs/erc20_tokens/erc20_tokens_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/shared/utils/copy_to_clipboard.dart';
import 'package:kriptum/shared/utils/format_address.dart';
import 'package:kriptum/shared/utils/show_snack_bar.dart';
import 'package:kriptum/ui/pages/home/widgets/account_viewer_btn.dart';
import 'package:kriptum/ui/pages/home/widgets/accounts_modal.dart';
import 'package:kriptum/ui/pages/home/widgets/asset_list_tile.dart';
import 'package:kriptum/ui/pages/home/widgets/main_balance_viewer.dart';
import 'package:kriptum/ui/pages/home/widgets/native_token_list_tile.dart';
import 'package:kriptum/ui/pages/import_tokens/import_tokens_page.dart';
import 'package:kriptum/ui/pages/scan_qr_code/scan_qr_code_page.dart';
import 'package:kriptum/ui/tokens/spacings.dart';
import 'package:kriptum/ui/widgets/networks_list.dart';
import 'dart:math' as math;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentAccountCubit>(
          create: (context) => injector.get<CurrentAccountCubit>()..requestCurrentAccount(),
        ),
        BlocProvider<CurrentNetworkCubit>(
          create: (context) => injector.get<CurrentNetworkCubit>()..requestCurrentNetwork(),
        ),
        BlocProvider<Erc20TokensBloc>(
          create: (context) => injector.get<Erc20TokensBloc>()
            ..add(
              Erc20TokensLoadRequested(),
            ),
        )
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leadingWidth: 100,
        leading: BlocBuilder<CurrentNetworkCubit, CurrentNetworkState>(
          builder: (context, state) {
            if (state is CurrentNetworkLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CurrentNetworkLoaded) {
              return TextButton(
                onPressed: () => _buildNetworksListModal(context),
                child: Text(
                  state.network.name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                copyToClipboard(
                  content: context.read<CurrentAccountCubit>().state.account!.address,
                  onCopied: (text) => _onCopyToClipBoard(
                    text,
                    context,
                  ),
                );
              },
              icon: Icon(Icons.copy)),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ScanQrCodePage(),
                ),
              );
            },
            icon: Icon(Icons.qr_code),
          ),
        ],
        title: BlocBuilder<CurrentAccountCubit, CurrentAccountState>(
          builder: (context, state) {
            if (state.account == null) {
              return const CircularProgressIndicator();
            }
            return AccountViewerBtn(
              account: state.account!,
              onPressed: () {
                _showAccountsModal(context);
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacings.horizontalPadding,
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MainBalanceViewer(),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: 'Tokens',
                ),
                Tab(
                  text: 'NFTs',
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  BlocBuilder<Erc20TokensBloc, Erc20TokensState>(
                    builder: (context, state) {
                      final tokens = state.tokens;
                      return ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Transform.rotate(
                                    angle: math.pi / 2,
                                    child: Icon(
                                      Icons.compare_arrows,
                                    )),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ImportTokensPage(),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                          NativeTokenListTile(),
                          ...tokens.map(
                            (e) => AssetListTile(
                              name: e.token.name ?? '',
                              ticker: e.token.symbol,
                              assetBalance: e.balance.toEther(fractionDigitAmount: 4),
                              onTap: () {
                                print('Tapp');
                              },
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  Center(
                    child: Text('Coming soon...'),
                  )
                ],
              ),
            )
            // TabBar(controller: _tabController, tabs: [
            //   Tab(
            //     text: 'Tokens',
            //   ),
            //   Tab(
            //     text: 'NFTs',
            //   ),
            // ]),
            // Expanded(
            //   child: PageView(
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       Center(
            //         child: Text('oi'),
            //       ),
            //       Center(
            //         child: Text('99'),
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  void _showAccountsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return const AccountsModal();
      },
    );
  }

  Future<void> _buildNetworksListModal(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacings.horizontalPadding,
        ),
        child: NetworksList(
          onNetworkChosen: (network) {
            //ScaffoldMessenger.of(context)
            //  ..clearSnackBars()
            //  ..showSnackBar(
            //    SnackBar(
            //      content: Text('Network changed to ${network.name}'),
            //    ),
            //  );
            showSnackBar(
              message: 'Network changed to ${network.name}',
              context: context,
            );
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _onCopyToClipBoard(String text, BuildContext context) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Timer(const Duration(milliseconds: 850), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        });

        return AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 80,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Public address ${formatAddress(text)} copied to clipboard',
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      },
    );
  }
}
