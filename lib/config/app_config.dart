 class AppConfig {
  /// Base API URL (main backend)
  static const String baseUrl = "https://api.instronova.in/v1";

  /// Base file URL (e.g., images / media loading)
  static const String mediaBaseUrl = "https://cdn.instronova.in/";

  /// WebSocket connection (अगर future में realtime चाहिए)
  static const String socketUrl = "wss://api.instronova.in/ws";

  /// Current environment
  static const String environment = "production";
}
