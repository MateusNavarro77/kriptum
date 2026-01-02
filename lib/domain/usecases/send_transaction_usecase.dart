import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/exceptions/invalid_current_account_state_exception.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/repositories/password_repository.dart';
import 'package:kriptum/domain/services/gas_price_service.dart';
import 'package:kriptum/domain/services/transaction_service.dart';

class SendTransactionUsecase {
  static const int _regularTransactionMaxGas = 21000;
  final AccountsRepository _accountsRepository;
  final PasswordRepository _passwordRepository;
  final NetworksRepository _networksRepository;
  final TransactionService _transactionService;
  final GasPriceService _gasPriceService;
  SendTransactionUsecase(
    this._accountsRepository,
    this._passwordRepository,
    this._networksRepository,
    this._gasPriceService,
    this._transactionService,
  );

  Future<TransactionOutput> execute(SendTransactionUsecaseParams params) async {
    final account = await _accountsRepository.getCurrentAccount();
    if (account == null) {
      throw InvalidCurrentAccountStateException('Account is null');
    }
    final currentNetwork = await _networksRepository.getCurrentNetwork();
    final encryptionPassword = _passwordRepository.getPassword();
    final gasPriceToUse = params.gasPrice ??
        await _gasPriceService.fetchGasPrice(
          rpcUrl: currentNetwork.rpcUrl,
        );
    final txHash = await _transactionService.sendTransaction(
      encryptedJsonAccount: account.encryptedJsonWallet,
      password: encryptionPassword,
      to: params.to,
      amountInWei: params.amount,
      rpcUrl: currentNetwork.rpcUrl,
      gasPrice: gasPriceToUse,
      maxGas: _regularTransactionMaxGas,
    );
    String? transactionUrl;
    if (currentNetwork.blockExplorerUrl != null) {
      //====TEMPORARY SOLUTION====
      String txPath = 'tx';
      if (currentNetwork.id == 4002) {
        txPath = 'transactions';
      }
      //==========================
      transactionUrl = '${currentNetwork.blockExplorerUrl}/$txPath/$txHash';
    }
    final txOutput = TransactionOutput(
      transactionHash: txHash,
      transactionUrlInBlockExplorer: transactionUrl,
    );
    return txOutput;
  }
}

class SendTransactionUsecaseParams {
  final String to;
  final BigInt amount;
  final BigInt? gasPrice;

  SendTransactionUsecaseParams({
    required this.to,
    required this.amount,
    this.gasPrice,
  });
}

class TransactionOutput {
  final String transactionHash;
  final String? transactionUrlInBlockExplorer;

  TransactionOutput({
    required this.transactionHash,
    this.transactionUrlInBlockExplorer,
  });
}
