import 'package:flutter/material.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/infra/app_version/app_version_provider.dart';

class AppVersionTextWidget extends StatefulWidget {
  const AppVersionTextWidget({super.key});

  @override
  State<AppVersionTextWidget> createState() => _AppVersionTextWidgetState();
}

class _AppVersionTextWidgetState extends State<AppVersionTextWidget> {
  AppVersion? _appVersion;
  String get readableVersion {
    if (_appVersion == null) return '';
    return 'v${_appVersion?.version}+${_appVersion?.buildNumber}';
  }

  @override
  void initState() {
    _loadAppVersion();
    super.initState();
  }

  Future<void> _loadAppVersion() async {
    final data = await injector.get<AppVersionProvider>().getAppVersion();
    if (mounted) {
      setState(() {
        _appVersion = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      readableVersion,
      style: Theme.of(
        context,
      ).textTheme.labelSmall?.copyWith(color: Theme.of(context).hintColor),
    );
  }
}
