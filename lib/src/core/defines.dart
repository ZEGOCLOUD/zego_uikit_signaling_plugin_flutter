class ZegoPluginResult {
  /// An error code.
  final String code;

  /// A human-readable error message
  final String message;

  /// result
  final dynamic result;

  ZegoPluginResult(this.code, this.message, this.result);

  ZegoPluginResult.empty({this.code = "", this.message = "", this.result = ""});
}

class ZegoNotificationConfig {
  bool notifyWhenAppIsInTheBackgroundOrQuit;
  String resourceID;
  String title;
  String message;

  ZegoNotificationConfig({
    this.notifyWhenAppIsInTheBackgroundOrQuit = true,
    this.resourceID = "",
    this.title = "",
    this.message = "",
  });

  @override
  String toString() {
    return "title:$title, message:$message, resource id:$resourceID, notify:$notifyWhenAppIsInTheBackgroundOrQuit";
  }
}
