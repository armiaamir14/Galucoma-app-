class Patient {
  String id;
  String doctorId;
  String firstName;
  String lastName;
  int age;
  String gender;

  Patient({this.id, this.doctorId, this.firstName, this.lastName, this.age, this.gender});

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    doctorId = json['_doctorId'];
    firstName = json['fname'];
    lastName = json['lname'];
    age = json['age'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['_doctorId'] = this.doctorId;
    data['fname'] = this.firstName;
    data['lname'] = this.lastName;
    data['age'] = this.age;
    data['gender'] = this.gender;
    return data;
  }
}
