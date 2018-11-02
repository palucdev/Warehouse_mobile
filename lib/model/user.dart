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
    && parsedJson.containsKey('expires')
    && parsedJson.containsKey('token')) {
      return User(
        id: parsedJson['user'],
        expires: parsedJson['expires'],
        token: parsedJson['token']
      );
    } else {
      throw new Exception('Malformed user json');
    }
  }
}
