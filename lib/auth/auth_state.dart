/// Lightweight representation of the current auth state.
/// This can be expanded over time and used by widgets or other layers
/// without exposing the full provider.
class AuthState {
  final bool isLoading;
  final bool isMfaRequired;
  final bool isMfaVerifying;
  final String? authToken;

  const AuthState({
    required this.isLoading,
    required this.isMfaRequired,
    required this.isMfaVerifying,
    required this.authToken,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isMfaRequired,
    bool? isMfaVerifying,
    String? authToken,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isMfaRequired: isMfaRequired ?? this.isMfaRequired,
      isMfaVerifying: isMfaVerifying ?? this.isMfaVerifying,
      authToken: authToken ?? this.authToken,
    );
  }
}
