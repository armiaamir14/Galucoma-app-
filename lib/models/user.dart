class User {
  String firstName;
  String lastName;
  String email;
  String password;
  String id;
  String status;
  int credits;

  User({this.firstName, this.lastName, this.email, this.password, this.id, this.status});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstname'];
    lastName = json['lastname'];
    email = json['email'];
    password = json['password'];
    id = json['id'];
    status = json['status'];
    credits = json['credits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firstName;
    data['lastname'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['id'] = this.id;
    data['status'] = this.status;
    data['credits'] = this.credits;
    return data;
  }
}
