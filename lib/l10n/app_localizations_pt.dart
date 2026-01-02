// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get loading => 'Carregando...';

  @override
  String get walletSetup => 'Configuração da carteira';

  @override
  String get importOrCreateWallet => 'Importe uma carteira existente ou crie uma nova';

  @override
  String get importUsingSecretPhrase => 'Importar usando Frase de Recuperação Secreta';

  @override
  String get createNewWallet => 'Criar uma nova carteira';

  @override
  String get welcomeBack => 'Bem-vindo de volta!';

  @override
  String get password => 'Senha';

  @override
  String get unlock => 'DESBLOQUEAR';

  @override
  String get walletWontUnlock =>
      'A carteira não desbloqueia? Você pode APAGAR sua carteira atual e configurar uma nova';

  @override
  String get resetWallet => 'Redefinir Carteira';

  @override
  String get createPassword => 'Criar senha';

  @override
  String get passwordUnlockDeviceOnly => 'Esta senha desbloqueará sua carteira Kriptum apenas neste dispositivo';

  @override
  String get newPassword => 'Nova Senha';

  @override
  String get confirmPassword => 'Confirmar Senha';

  @override
  String get mustBeAtLeast8Chars => 'Deve ter pelo menos 8 caracteres';

  @override
  String get createWallet => 'Criar Carteira';

  @override
  String get secureYourWallet => 'Proteja sua carteira';

  @override
  String get secureYourWalletsPhrase => 'Proteja a sua ';

  @override
  String get secretRecoveryPhrase => 'Frase de Recuperação Secreta';

  @override
  String get whyIsItImportant => 'Por que isso é importante?';

  @override
  String get textExplainingWhyImportant => 'Texto explicando por que isso é importante';

  @override
  String get start => 'Começar';

  @override
  String get whatIsSecretRecoveryPhrase => 'O que é uma \'Frase de Recuperação Secreta\'';

  @override
  String get secretPhraseExplanation1 =>
      'Uma Frase de Recuperação Secreta é um conjunto de doze palavras que contém todas as informações sobre sua carteira, incluindo seus fundos. É como um código secreto usado para acessar toda a sua carteira.';

  @override
  String get secretPhraseExplanation2 =>
      'Você deve manter sua Frase de Recuperação Secreta em segredo e segura. Se alguém obtiver sua Frase de Recuperação Secreta, ganhará controle sobre suas contas.';

  @override
  String get secretPhraseExplanation3 =>
      'Salve-a em um lugar onde apenas você possa acessar. Se você a perder, não poderá recuperá-la.';

  @override
  String get protectYourWallet => 'Proteja sua carteira';

  @override
  String get protectWalletDescription =>
      'Não corra o risco de perder seus fundos. Proteja sua carteira salvando sua Frase de Recuperação Secreta em um lugar de sua confiança.\nÉ a única maneira de recuperar sua carteira se você for bloqueado no aplicativo ou adquirir um novo dispositivo.';

  @override
  String get writeDownSecretPhrase => 'Anote sua Frase de Recuperação Secreta';

  @override
  String get writeDownDescription =>
      'Esta é a sua Frase de Recuperação Secreta. Anote-a no papel e guarde-a em um local seguro. Você será solicitado a digitar novamente esta frase (em ordem) na próxima etapa.';

  @override
  String get saving => 'Salvando...';

  @override
  String get iBackedUpMyKeys => 'Eu fiz o backup das minhas chaves';

  @override
  String get unknownStep => 'Etapa desconhecida';

  @override
  String get importFromSecretPhrase => 'Importar da Frase de Recuperação Secreta';

  @override
  String get enterSecretPhrase => 'Digite sua Frase de Recuperação Secreta';

  @override
  String get newPasswordHint => 'Nova Senha';

  @override
  String get confirmPasswordHint => 'Confirmar Senha';

  @override
  String get mustBeAtLeast8Characters => 'Deve ter pelo menos 8 caracteres';

  @override
  String get import => 'IMPORTAR';

  @override
  String get passwordsDontMatch => 'As senhas não coincidem';

  @override
  String get send => 'Enviar';

  @override
  String get sendCryptoToAccount => 'Enviar cripto para qualquer conta';

  @override
  String get receive => 'Receber';

  @override
  String get receiveCrypto => 'Receber cripto';

  @override
  String get transactions => 'Transações';

  @override
  String get swap => 'Trocar';

  @override
  String get nfts => 'NFTs';

  @override
  String get tokens => 'Tokens';

  @override
  String get comingSoon => 'Em breve...';

  @override
  String get network => 'Rede';

  @override
  String get scanQrCode => 'Escanear código QR';

  @override
  String get yourQrCode => 'Seu código QR';

  @override
  String get addressCopiedToClipboard => 'Endereço copiado para a área de transferência';

  @override
  String get copyAddress => 'Copiar endereço';

  @override
  String get settings => 'Configurações';

  @override
  String get general => 'Geral';

  @override
  String get generalSettingsDescription => 'Configurações gerais como temas...';

  @override
  String get networks => 'Redes';

  @override
  String get networksDescription => 'Adicionar e editar redes RPC personalizadas';

  @override
  String get contacts => 'Contatos';

  @override
  String get contactsDescription => 'Adicione, edite, remova e gerencie seus contatos';

  @override
  String get lockWallet => 'Bloquear Carteira';

  @override
  String get darkTheme => 'Tema Escuro';

  @override
  String get noContacts => 'Nenhum Contato';

  @override
  String get addContact => 'Adicionar contato';

  @override
  String get name => 'Nome';

  @override
  String get cannotBeEmpty => 'Não pode estar vazio';

  @override
  String get address => 'Endereço';

  @override
  String get editContact => 'Editar Contato';

  @override
  String get delete => 'Excluir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get areYouSureEraseWallet => 'Tem certeza de que deseja apagar sua carteira?';

  @override
  String get eraseWalletWarning1 =>
      'Sua carteira atual, contas e ativos serão removidos permanentemente deste aplicativo. Esta ação não pode ser desfeita.';

  @override
  String get eraseWalletWarning2 =>
      'Você SÓ pode recuperar esta carteira com sua Frase de Recuperação Secreta, que deve ser sua responsabilidade.';

  @override
  String get iUnderstandContinue => 'Eu entendo, continuar';

  @override
  String get sendTo => 'Enviar para';

  @override
  String get from => 'De: ';

  @override
  String get to => 'Para: ';

  @override
  String get cantSendToYourself => 'Não é possível enviar para você mesmo';

  @override
  String get myAccounts => 'Minhas contas';

  @override
  String get recents => 'Recentes';

  @override
  String get next => 'Próximo';

  @override
  String get amount => 'Valor';

  @override
  String get back => 'Voltar';

  @override
  String get useMax => 'USAR MÁX';

  @override
  String get balance => 'Saldo';

  @override
  String get confirm => 'Confirmar';

  @override
  String get gasPrice => 'Preço do Gás: ';

  @override
  String get networkFee => 'Taxa de rede';

  @override
  String get estimatedTotal => 'Total Estimado: ';

  @override
  String get rejectTransaction => 'Rejeitar Transação';

  @override
  String get confirmTransaction => 'Confirmar Transação';

  @override
  String get transactionSent => 'Transação enviada';

  @override
  String get viewOnBlockExplorer => 'Ver no explorador de blocos';

  @override
  String get close => 'Fechar';

  @override
  String get importTokens => 'Importar tokens';

  @override
  String get tokenContractAddress => 'Endereço do contrato do token';

  @override
  String get tokenName => 'Nome do token';

  @override
  String get tokenNameHint => 'ex: MeuToken';

  @override
  String get tokenSymbol => 'Símbolo do token';

  @override
  String get tokenSymbolHint => 'ex: MYT';

  @override
  String get tokenDecimals => 'Decimais do token';

  @override
  String get tokenDecimalsHint => 'ex: 18';

  @override
  String get importingToken => 'Importando token...';

  @override
  String get importToken => 'Importar token';

  @override
  String get importAccount => 'Importar conta';

  @override
  String get importedAccountsNotRecoverable =>
      'As contas importadas podem ser visualizadas em sua carteira, mas não podem ser recuperadas com sua Frase de Recuperação Secreta Kriptum.';

  @override
  String get learnMoreImportedAccounts => 'Saiba mais sobre contas importadas aqui.';

  @override
  String get pastePrivateKeyString => 'Cole sua string de chave privada';

  @override
  String networkChangedTo(String networkName) {
    return 'Rede alterada para $networkName.';
  }

  @override
  String get addContactPage_title => 'Adicionar contato';

  @override
  String get addContactPage_name => 'Nome';

  @override
  String get addContactPage_address => 'Endereço';

  @override
  String get addContactPage_addContactBtnText => 'Adicionar contato';

  @override
  String get publicAddressTextFieldHintText => 'Endereço público (0x)';

  @override
  String get save => 'Salvar';

  @override
  String get accounts => 'Contas';

  @override
  String get addOrImportAccount => 'Adicionar ou importar conta';

  @override
  String get addAccount => 'Adicionar conta';

  @override
  String get addNewAccount => 'Adicionar nova conta';

  @override
  String sentAmount(String ticker) {
    return 'Valor enviado';
  }

  @override
  String viewOnBlockExplorerPlaceholder(String blockExplorerName) {
    return 'Acompanhar em $blockExplorerName';
  }

  @override
  String get transactionHash => 'Hash da transação';

  @override
  String get date => 'Data';

  @override
  String get confirmed => 'Confirmado';

  @override
  String get status => 'Status';

  @override
  String get addNetwork => 'Adicionar rede';

  @override
  String get yourAccounts => 'Suas Contas';
}
