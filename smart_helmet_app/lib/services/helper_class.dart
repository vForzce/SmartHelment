class HelperClass {
  late String email;
  late String username;
  late String device;

  HelperClass({
    required this.username,
    required this.email,
    required this.device,
  });

  HelperClass.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        username = json['username'],
        device = json['device'];

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'device': device,
    };
  }
}
