// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loading => 'Loading...';

  @override
  String get walletSetup => 'Wallet setup';

  @override
  String get importOrCreateWallet => 'Import an existing wallet or create a new one';

  @override
  String get importUsingSecretPhrase => 'Import using Secret Recovery Phrase';

  @override
  String get createNewWallet => 'Create a new wallet';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get password => 'Password';

  @override
  String get unlock => 'UNLOCK';

  @override
  String get walletWontUnlock => 'Wallet won\' unlock? You can ERASE your current wallet and setup a new one';

  @override
  String get resetWallet => 'Reset Wallet';

  @override
  String get createPassword => 'Create password';

  @override
  String get passwordUnlockDeviceOnly => 'This password will unlock your Kriptum wallet only on this device';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get mustBeAtLeast8Chars => 'Must be at leaset 8 characters';

  @override
  String get createWallet => 'Create Wallet';

  @override
  String get secureYourWallet => 'Secure your wallet';

  @override
  String get secureYourWalletsPhrase => 'Secure your wallet\'s ';

  @override
  String get secretRecoveryPhrase => 'Secret Recovery Phrase';

  @override
  String get whyIsItImportant => 'Why is it important?';

  @override
  String get textExplainingWhyImportant => 'Text Explaining why its important';

  @override
  String get start => 'Start';

  @override
  String get whatIsSecretRecoveryPhrase => 'What is a \'Secret Recovery Phrase\'';

  @override
  String get secretPhraseExplanation1 =>
      'A Secret Recovery Phrase is a set of twelve words that contains all the information about your wallet, including your funds. It\'s like a secret code used to access your entire wallet.';

  @override
  String get secretPhraseExplanation2 =>
      'You must keep your Secret Recovery Phrase secret and safe. If someone gets Your Secret Recovery Phrase,they\'ll gain control over your accounts. ';

  @override
  String get secretPhraseExplanation3 =>
      'Save it in a place where only you can access it. If you lose it, you cannot recover it.';

  @override
  String get protectYourWallet => 'Protect your wallet';

  @override
  String get protectWalletDescription =>
      'Don\'t risk losing your funds. Protect your wallet by saving your Secret Recovery Phrase in a place you trust.\nIt\'s the only way to recover your wallet if you get locked out of the app or get a new device.';

  @override
  String get writeDownSecretPhrase => 'Write down your Secret Recovery Phrase';

  @override
  String get writeDownDescription =>
      'This is your Secret Recovery Phrase. Write it down on paper and keep it in a safe place. You will be asked to re-enter this phrase (in order) on the next step.';

  @override
  String get saving => 'Saving...';

  @override
  String get iBackedUpMyKeys => 'I backed up my keys';

  @override
  String get unknownStep => 'Unknown step';

  @override
  String get importFromSecretPhrase => 'Import from Secret Recovery Phrase';

  @override
  String get enterSecretPhrase => 'Enter your Secret Recovery Phrase';

  @override
  String get newPasswordHint => 'New Password';

  @override
  String get confirmPasswordHint => 'Confirm Password';

  @override
  String get mustBeAtLeast8Characters => 'Must be at least 8 characters';

  @override
  String get import => 'IMPORT';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get send => 'Send';

  @override
  String get sendCryptoToAccount => 'Send crypto to any account';

  @override
  String get receive => 'Receive';

  @override
  String get receiveCrypto => 'Receive crypto';

  @override
  String get transactions => 'Transactions';

  @override
  String get swap => 'Swap';

  @override
  String get nfts => 'NFTs';

  @override
  String get tokens => 'Tokens';

  @override
  String get comingSoon => 'Coming soon...';

  @override
  String get network => 'Network';

  @override
  String get scanQrCode => 'Scan QR code';

  @override
  String get yourQrCode => 'Your QR code';

  @override
  String get addressCopiedToClipboard => 'Address copied to clipboard';

  @override
  String get copyAddress => 'Copy address';

  @override
  String get settings => 'Settings';

  @override
  String get general => 'General';

  @override
  String get generalSettingsDescription => 'General settings like theming...';

  @override
  String get networks => 'Networks';

  @override
  String get networksDescription => 'Add and edit custom RPC networks';

  @override
  String get contacts => 'Contacts';

  @override
  String get contactsDescription => 'Add, edit, remove and manage your contacts';

  @override
  String get lockWallet => 'Lock Wallet';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get noContacts => 'No Contacts';

  @override
  String get addContact => 'Add contact';

  @override
  String get name => 'Name';

  @override
  String get cannotBeEmpty => 'Cannot be empty';

  @override
  String get address => 'Address';

  @override
  String get editContact => 'Edit Contact';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get areYouSureEraseWallet => 'Are you sure you want to erase your wallet?';

  @override
  String get eraseWalletWarning1 =>
      'Your current wallet,accounts and assets will be removed from this app permanently. This action cannot be undone.';

  @override
  String get eraseWalletWarning2 =>
      'You can ONLY recover this wallet with your Secret Recovery Phrase which must be your responsability.';

  @override
  String get iUnderstandContinue => 'I understand, continue';

  @override
  String get sendTo => 'Send to';

  @override
  String get from => 'From: ';

  @override
  String get to => 'To: ';

  @override
  String get cantSendToYourself => 'Can\'t send to yourself';

  @override
  String get myAccounts => 'My accounts';

  @override
  String get recents => 'Recents';

  @override
  String get next => 'Next';

  @override
  String get amount => 'Amount';

  @override
  String get back => 'Back';

  @override
  String get useMax => 'USE MAX';

  @override
  String get balance => 'Balance';

  @override
  String get confirm => 'Confirm';

  @override
  String get gasPrice => 'Gas Price: ';

  @override
  String get networkFee => 'Network fee';

  @override
  String get estimatedTotal => 'Estimated Total: ';

  @override
  String get rejectTransaction => 'Reject Transaction';

  @override
  String get confirmTransaction => 'Confirm Transaction';

  @override
  String get transactionSent => 'Transaction sent';

  @override
  String get viewOnBlockExplorer => 'View on block explorer';

  @override
  String get close => 'Close';

  @override
  String get importTokens => 'Import tokens';

  @override
  String get tokenContractAddress => 'Token contract address';

  @override
  String get tokenName => 'Token name';

  @override
  String get tokenNameHint => 'e.g. MyToken';

  @override
  String get tokenSymbol => 'Token symbol';

  @override
  String get tokenSymbolHint => 'e.g. MYT';

  @override
  String get tokenDecimals => 'Token decimals';

  @override
  String get tokenDecimalsHint => 'e.g. 18';

  @override
  String get importingToken => 'Importing token...';

  @override
  String get importToken => 'Import token';

  @override
  String get importAccount => 'Import account';

  @override
  String get importedAccountsNotRecoverable =>
      'Imported accounts are viewable in your wallet but are not recoverable with your Kriptum Secret Recovery Phrase.';

  @override
  String get learnMoreImportedAccounts => 'Learn more about imported accounts here.';

  @override
  String get pastePrivateKeyString => 'Paste your private key string';

  @override
  String networkChangedTo(String networkName) {
    return 'Network changed to $networkName.';
  }
}
