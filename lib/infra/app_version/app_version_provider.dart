abstract interface class AppVersionProvider {
  Future<AppVersion> getAppVersion();
}

class AppVersion {
  final String version;
  final String buildNumber;

  const AppVersion({
    required this.version,
    required this.buildNumber,
  });
}
