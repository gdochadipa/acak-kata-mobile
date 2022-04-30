class UserModel {
  String? id;
  String? name;
  String? email;
  String? username;
  String? avatar;
  String? userCode;
  String? token;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.username,
      this.avatar,
      this.userCode,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    avatar = json['profile_photo_url'];
    token = json['token'];
    userCode = json['user_code'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'username': username,
      'avatar': avatar,
      'token': token,
      'user_code': userCode
    };
  }
}

class UninitializedUserModel extends UserModel {}
