import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('pt')];

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Wallet setup page title
  ///
  /// In en, this message translates to:
  /// **'Wallet setup'**
  String get walletSetup;

  /// Wallet setup description
  ///
  /// In en, this message translates to:
  /// **'Import an existing wallet or create a new one'**
  String get importOrCreateWallet;

  /// Button to import wallet
  ///
  /// In en, this message translates to:
  /// **'Import using Secret Recovery Phrase'**
  String get importUsingSecretPhrase;

  /// Button to create new wallet
  ///
  /// In en, this message translates to:
  /// **'Create a new wallet'**
  String get createNewWallet;

  /// Unlock wallet greeting
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Button to unlock wallet
  ///
  /// In en, this message translates to:
  /// **'UNLOCK'**
  String get unlock;

  /// Reset wallet hint text
  ///
  /// In en, this message translates to:
  /// **'Wallet won\' unlock? You can ERASE your current wallet and setup a new one'**
  String get walletWontUnlock;

  /// Button to reset wallet
  ///
  /// In en, this message translates to:
  /// **'Reset Wallet'**
  String get resetWallet;

  /// Create password step title
  ///
  /// In en, this message translates to:
  /// **'Create password'**
  String get createPassword;

  /// Password creation description
  ///
  /// In en, this message translates to:
  /// **'This password will unlock your Kriptum wallet only on this device'**
  String get passwordUnlockDeviceOnly;

  /// New password field label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Password helper text
  ///
  /// In en, this message translates to:
  /// **'Must be at leaset 8 characters'**
  String get mustBeAtLeast8Chars;

  /// Button to create wallet
  ///
  /// In en, this message translates to:
  /// **'Create Wallet'**
  String get createWallet;

  /// Secure wallet step title
  ///
  /// In en, this message translates to:
  /// **'Secure your wallet'**
  String get secureYourWallet;

  /// Secure wallet description part 1
  ///
  /// In en, this message translates to:
  /// **'Secure your wallet\'s '**
  String get secureYourWalletsPhrase;

  /// Secret Recovery Phrase link text
  ///
  /// In en, this message translates to:
  /// **'Secret Recovery Phrase'**
  String get secretRecoveryPhrase;

  /// Why important button text
  ///
  /// In en, this message translates to:
  /// **'Why is it important?'**
  String get whyIsItImportant;

  /// Placeholder explanation text
  ///
  /// In en, this message translates to:
  /// **'Text Explaining why its important'**
  String get textExplainingWhyImportant;

  /// Start button
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Secret Recovery Phrase dialog title
  ///
  /// In en, this message translates to:
  /// **'What is a \'Secret Recovery Phrase\''**
  String get whatIsSecretRecoveryPhrase;

  /// Secret phrase explanation paragraph 1
  ///
  /// In en, this message translates to:
  /// **'A Secret Recovery Phrase is a set of twelve words that contains all the information about your wallet, including your funds. It\'s like a secret code used to access your entire wallet.'**
  String get secretPhraseExplanation1;

  /// Secret phrase explanation paragraph 2
  ///
  /// In en, this message translates to:
  /// **'You must keep your Secret Recovery Phrase secret and safe. If someone gets Your Secret Recovery Phrase,they\'ll gain control over your accounts. '**
  String get secretPhraseExplanation2;

  /// Secret phrase explanation paragraph 3
  ///
  /// In en, this message translates to:
  /// **'Save it in a place where only you can access it. If you lose it, you cannot recover it.'**
  String get secretPhraseExplanation3;

  /// Protect wallet dialog title
  ///
  /// In en, this message translates to:
  /// **'Protect your wallet'**
  String get protectYourWallet;

  /// Protect wallet dialog description
  ///
  /// In en, this message translates to:
  /// **'Don\'t risk losing your funds. Protect your wallet by saving your Secret Recovery Phrase in a place you trust.\nIt\'s the only way to recover your wallet if you get locked out of the app or get a new device.'**
  String get protectWalletDescription;

  /// Write secret phrase step title
  ///
  /// In en, this message translates to:
  /// **'Write down your Secret Recovery Phrase'**
  String get writeDownSecretPhrase;

  /// Write down secret phrase description
  ///
  /// In en, this message translates to:
  /// **'This is your Secret Recovery Phrase. Write it down on paper and keep it in a safe place. You will be asked to re-enter this phrase (in order) on the next step.'**
  String get writeDownDescription;

  /// Saving in progress text
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Confirm backup button
  ///
  /// In en, this message translates to:
  /// **'I backed up my keys'**
  String get iBackedUpMyKeys;

  /// Error text for unknown step
  ///
  /// In en, this message translates to:
  /// **'Unknown step'**
  String get unknownStep;

  /// Import wallet page title
  ///
  /// In en, this message translates to:
  /// **'Import from Secret Recovery Phrase'**
  String get importFromSecretPhrase;

  /// Secret phrase field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your Secret Recovery Phrase'**
  String get enterSecretPhrase;

  /// New password field hint
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordHint;

  /// Confirm password field hint
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordHint;

  /// Password requirements helper text
  ///
  /// In en, this message translates to:
  /// **'Must be at least 8 characters'**
  String get mustBeAtLeast8Characters;

  /// Import button text
  ///
  /// In en, this message translates to:
  /// **'IMPORT'**
  String get import;

  /// Password mismatch error
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsDontMatch;

  /// Send action label
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Send action description
  ///
  /// In en, this message translates to:
  /// **'Send crypto to any account'**
  String get sendCryptoToAccount;

  /// Receive action label
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receive;

  /// Receive action description
  ///
  /// In en, this message translates to:
  /// **'Receive crypto'**
  String get receiveCrypto;

  /// Transactions tab label
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// Swap tab label
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get swap;

  /// NFTs tab label
  ///
  /// In en, this message translates to:
  /// **'NFTs'**
  String get nfts;

  /// Tokens tab label
  ///
  /// In en, this message translates to:
  /// **'Tokens'**
  String get tokens;

  /// Coming soon placeholder
  ///
  /// In en, this message translates to:
  /// **'Coming soon...'**
  String get comingSoon;

  /// Network label
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// Scan QR code button
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get scanQrCode;

  /// Your QR code button
  ///
  /// In en, this message translates to:
  /// **'Your QR code'**
  String get yourQrCode;

  /// Address copied snackbar message
  ///
  /// In en, this message translates to:
  /// **'Address copied to clipboard'**
  String get addressCopiedToClipboard;

  /// Copy address button
  ///
  /// In en, this message translates to:
  /// **'Copy address'**
  String get copyAddress;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// General settings title
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// General settings description
  ///
  /// In en, this message translates to:
  /// **'General settings like theming...'**
  String get generalSettingsDescription;

  /// Networks settings title
  ///
  /// In en, this message translates to:
  /// **'Networks'**
  String get networks;

  /// Networks settings description
  ///
  /// In en, this message translates to:
  /// **'Add and edit custom RPC networks'**
  String get networksDescription;

  /// Contacts page title
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// Contacts settings description
  ///
  /// In en, this message translates to:
  /// **'Add, edit, remove and manage your contacts'**
  String get contactsDescription;

  /// Lock wallet button
  ///
  /// In en, this message translates to:
  /// **'Lock Wallet'**
  String get lockWallet;

  /// Dark theme setting label
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// Empty contacts message
  ///
  /// In en, this message translates to:
  /// **'No Contacts'**
  String get noContacts;

  /// Add contact button
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get addContact;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Empty field validation error
  ///
  /// In en, this message translates to:
  /// **'Cannot be empty'**
  String get cannotBeEmpty;

  /// Address field label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Edit contact page title
  ///
  /// In en, this message translates to:
  /// **'Edit Contact'**
  String get editContact;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Erase wallet confirmation title
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to erase your wallet?'**
  String get areYouSureEraseWallet;

  /// Erase wallet warning paragraph 1
  ///
  /// In en, this message translates to:
  /// **'Your current wallet,accounts and assets will be removed from this app permanently. This action cannot be undone.'**
  String get eraseWalletWarning1;

  /// Erase wallet warning paragraph 2
  ///
  /// In en, this message translates to:
  /// **'You can ONLY recover this wallet with your Secret Recovery Phrase which must be your responsability.'**
  String get eraseWalletWarning2;

  /// Confirm erase button
  ///
  /// In en, this message translates to:
  /// **'I understand, continue'**
  String get iUnderstandContinue;

  /// Send to page title
  ///
  /// In en, this message translates to:
  /// **'Send to'**
  String get sendTo;

  /// From label
  ///
  /// In en, this message translates to:
  /// **'From: '**
  String get from;

  /// To label
  ///
  /// In en, this message translates to:
  /// **'To: '**
  String get to;

  /// Send to self validation error
  ///
  /// In en, this message translates to:
  /// **'Can\'t send to yourself'**
  String get cantSendToYourself;

  /// My accounts section header
  ///
  /// In en, this message translates to:
  /// **'My accounts'**
  String get myAccounts;

  /// Recents section header
  ///
  /// In en, this message translates to:
  /// **'Recents'**
  String get recents;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Amount page title
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Use max button
  ///
  /// In en, this message translates to:
  /// **'USE MAX'**
  String get useMax;

  /// Balance label prefix
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Confirm page title
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Gas price label
  ///
  /// In en, this message translates to:
  /// **'Gas Price: '**
  String get gasPrice;

  /// Network fee label
  ///
  /// In en, this message translates to:
  /// **'Network fee'**
  String get networkFee;

  /// Estimated total label
  ///
  /// In en, this message translates to:
  /// **'Estimated Total: '**
  String get estimatedTotal;

  /// Reject transaction button
  ///
  /// In en, this message translates to:
  /// **'Reject Transaction'**
  String get rejectTransaction;

  /// Confirm transaction button
  ///
  /// In en, this message translates to:
  /// **'Confirm Transaction'**
  String get confirmTransaction;

  /// Transaction sent dialog title
  ///
  /// In en, this message translates to:
  /// **'Transaction sent'**
  String get transactionSent;

  /// View on explorer button
  ///
  /// In en, this message translates to:
  /// **'View on block explorer'**
  String get viewOnBlockExplorer;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Import tokens page title
  ///
  /// In en, this message translates to:
  /// **'Import tokens'**
  String get importTokens;

  /// Token contract address field label
  ///
  /// In en, this message translates to:
  /// **'Token contract address'**
  String get tokenContractAddress;

  /// Token name field label
  ///
  /// In en, this message translates to:
  /// **'Token name'**
  String get tokenName;

  /// Token name field hint
  ///
  /// In en, this message translates to:
  /// **'e.g. MyToken'**
  String get tokenNameHint;

  /// Token symbol field label
  ///
  /// In en, this message translates to:
  /// **'Token symbol'**
  String get tokenSymbol;

  /// Token symbol field hint
  ///
  /// In en, this message translates to:
  /// **'e.g. MYT'**
  String get tokenSymbolHint;

  /// Token decimals field label
  ///
  /// In en, this message translates to:
  /// **'Token decimals'**
  String get tokenDecimals;

  /// Token decimals field hint
  ///
  /// In en, this message translates to:
  /// **'e.g. 18'**
  String get tokenDecimalsHint;

  /// Importing token progress text
  ///
  /// In en, this message translates to:
  /// **'Importing token...'**
  String get importingToken;

  /// Import token button
  ///
  /// In en, this message translates to:
  /// **'Import token'**
  String get importToken;

  /// Import account page title
  ///
  /// In en, this message translates to:
  /// **'Import account'**
  String get importAccount;

  /// Imported accounts warning
  ///
  /// In en, this message translates to:
  /// **'Imported accounts are viewable in your wallet but are not recoverable with your Kriptum Secret Recovery Phrase.'**
  String get importedAccountsNotRecoverable;

  /// Learn more link text
  ///
  /// In en, this message translates to:
  /// **'Learn more about imported accounts here.'**
  String get learnMoreImportedAccounts;

  /// Private key instruction
  ///
  /// In en, this message translates to:
  /// **'Paste your private key string'**
  String get pastePrivateKeyString;

  /// Network changed snackbar message
  ///
  /// In en, this message translates to:
  /// **'Network changed to {networkName}.'**
  String networkChangedTo(String networkName);

  /// Add contact page title
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContactPage_title;

  /// Add contact page name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get addContactPage_name;

  /// Add contact page address field label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addContactPage_address;

  /// Add contact page add contact button text
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get addContactPage_addContactBtnText;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError('AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
