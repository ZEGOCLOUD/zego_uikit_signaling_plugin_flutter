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
