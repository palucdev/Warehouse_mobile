class User {
  String id;
  String expires;
  String token;
  num role;

  User({
    this.id,
    this.expires,
    this.token,
    this.role
  });

  factory User.fromJson(Map<String, dynamic> parsedJson){
    if (parsedJson.containsKey('user')
    && parsedJson.containsKey('expires_in')
    && parsedJson.containsKey('access_token')
    && parsedJson.containsKey('role')) {
      return User(
        id: parsedJson['user'],
        expires: parsedJson['expires_in'],
        token: parsedJson['access_token'],
        role: parsedJson['role']
      );
    } else {
      throw new Exception('Malformed user json');
    }
  }
}
