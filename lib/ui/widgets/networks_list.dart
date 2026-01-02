import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/current_network/current_network_cubit.dart';
import 'package:kriptum/blocs/networks_list/networks_list_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/ui/widgets/network_list_tile.dart';

class NetworksList extends StatelessWidget {
  final void Function(Network network)? onNetworkChosen;
  const NetworksList({super.key, this.onNetworkChosen});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentNetworkCubit>(
          create: (context) => injector.get<CurrentNetworkCubit>()..requestCurrentNetwork(),
        ),
        BlocProvider<NetworksListBloc>(
          create: (context) => injector.get<NetworksListBloc>()..add(NetworksListRequested()),
        ),
      ],
      child: _NetworksList(
        onNetworkChosen: onNetworkChosen,
      ),
    );
  }
}

class _NetworksList extends StatefulWidget {
  final void Function(Network network)? onNetworkChosen;
  const _NetworksList({this.onNetworkChosen});

  @override
  State<_NetworksList> createState() => _NetworksListState();
}

class _NetworksListState extends State<_NetworksList> {
  final TextEditingController _filterTextEditingController = TextEditingController();
  @override
  void initState() {
    _filterTextEditingController.addListener(_filterTextListener);
    super.initState();
  }

  @override
  void dispose() {
    _filterTextEditingController.dispose();
    super.dispose();
  }

  void _filterTextListener() {
    context.read<NetworksListBloc>().add(
          NetworksListFiltered(
            filter: _filterTextEditingController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _filterTextEditingController,
            decoration: const InputDecoration(
              labelText: 'Search',
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          Expanded(
            child: BlocBuilder<NetworksListBloc, NetworksListState>(
              builder: (context, state) {
                if (state.status == NetworksListStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == NetworksListStatus.error) {
                  return Center(
                    child: Text(state.errorMessage ?? 'Unknown error'),
                  );
                }
                final networks = state.filteredNetworks;
                return BlocConsumer<CurrentNetworkCubit, CurrentNetworkState>(
                  listener: (context, state) {
                    if (widget.onNetworkChosen == null) return;
                    widget.onNetworkChosen!((state as CurrentNetworkLoaded).network);
                  },
                  listenWhen: (previous, current) {
                    if (current is CurrentNetworkLoaded) {
                      return current.isChangingNetwork;
                    }
                    return false;
                  },
                  builder: (context, currNetworksState) {
                    bool loaded = currNetworksState is CurrentNetworkLoaded;
                    if (!loaded) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final currentNetwork = currNetworksState.network;
                    return ListView.builder(
                      itemCount: networks.length,
                      itemBuilder: (context, index) {
                        final network = networks[index];
                        return NetworkListTile(
                          selected: currentNetwork.id == network.id,
                          network: network,
                          onNetworkTap: (network) {
                            context.read<CurrentNetworkCubit>().changeCurrentNetwork(network);
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          FilledButton(
            onPressed: () {},
            child:  Text(AppLocalizations.of(context)!.addNetwork),
          )
        ],
      ),
    );
  }
}
