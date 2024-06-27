class UserToken {
  String token;
  String refreshToken;

  UserToken({
    required this.token,
    required this.refreshToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'refreshToken': refreshToken,
    };
  }

  factory UserToken.fromMap(Map<String, dynamic> map) {
    return UserToken(
      token: map['token'] as String,
      refreshToken: map['refreshToken'] as String,
    );
  }

  UserToken copyWith({
    String? token,
    String? refreshToken,
  }) {
    return UserToken(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
