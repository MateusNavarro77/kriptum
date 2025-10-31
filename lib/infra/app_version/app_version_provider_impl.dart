import 'package:kriptum/infra/app_version/app_version_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionProviderImpl implements AppVersionProvider {
  @override
  Future<AppVersion> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appVersion = AppVersion(
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
    return appVersion;
  }
}
