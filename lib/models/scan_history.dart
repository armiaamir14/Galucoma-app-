class ScanHistory {
  String id;
  String patientId;
  String eye;
  int result;
  String notes;
  String imageLink;

  ScanHistory({this.id, this.patientId, this.eye, this.result, this.notes, this.imageLink});

  ScanHistory.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    patientId = json['_patientId']['_id'];
    eye = json['eye'];
    result = json['result'];
    notes = json['notes'];
    imageLink = json['Imagelink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['_patientId'] = this.patientId;
    data['eye'] = this.eye;
    data['result'] = this.result;
    data['notes'] = this.notes;
    data['Imagelink'] = this.imageLink;
    return data;
  }
}
