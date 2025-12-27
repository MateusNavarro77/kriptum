import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:kriptum/domain/services/gas_price_service.dart';
import 'package:web3dart/web3dart.dart' as web3;

class GasServiceImpl implements GasPriceService {
  final http.Client _httpClient;
  final Map<String, StreamController<BigInt>> _controllers = {};
  final Map<String, Timer> _timers = {};
  final Map<String, int> _listenerCounts = {};
  GasServiceImpl({required http.Client httpClient}) : _httpClient = httpClient;

  @override
  Future<BigInt> fetchGasPrice({required String rpcUrl}) async {
    final ethClient = web3.Web3Client(rpcUrl, _httpClient);
    final gasPrice = await ethClient.getGasPrice();
    await ethClient.dispose();
    return gasPrice.getInWei;
  }

  @override
  Stream<BigInt> subscribeToGasPriceUpdates({
    required String rpcUrl,
    Duration interval = const Duration(seconds: 10),
  }) {
    final key = rpcUrl;

    if (!_controllers.containsKey(key)) {
      _controllers[key] = StreamController<BigInt>.broadcast(
        onListen: () => _startPolling(rpcUrl, interval, key),
        onCancel: () => _stopPolling(key),
      );
    }

    return _controllers[key]!.stream;
  }

  void _startPolling(String rpcUrl, Duration interval, String key) {
    _listenerCounts[key] = (_listenerCounts[key] ?? 0) + 1;

    if (_listenerCounts[key] == 1) {
      _timers[key] = Timer.periodic(interval, (_) async {
        final price = await fetchGasPrice(rpcUrl: rpcUrl);
        _controllers[key]?.add(price);
      });
    }
  }

  void _stopPolling(String key) {
    if (_listenerCounts.containsKey(key)) {
      _listenerCounts[key] = _listenerCounts[key]! - 1;

      if (_listenerCounts[key] == 0) {
        _timers[key]?.cancel();
        _timers.remove(key);
      }
    }
  }

  @override
  Future<void> dispose() async {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    for (final controller in _controllers.values) {
      await controller.close();
    }
    _timers.clear();
    _controllers.clear();
    _listenerCounts.clear();
  }
}
