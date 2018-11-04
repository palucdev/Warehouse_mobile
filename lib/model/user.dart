class User {
  String id;
  String expires;
  String token;

  User({
    this.id,
    this.expires,
    this.token
  });

  factory User.fromJson(Map<String, dynamic> parsedJson){
    if (parsedJson.containsKey('user')
    && parsedJson.containsKey('expires_in')
    && parsedJson.containsKey('access_token')) {
      return User(
        id: parsedJson['user'],
        expires: parsedJson['expires_in'],
        token: parsedJson['access_token']
      );
    } else {
      throw new Exception('Malformed user json');
    }
  }
}
