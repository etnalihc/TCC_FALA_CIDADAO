// ignore_for_file: non_constant_identifier_names

class PrefecModel {
  final int prefecID;
  final String prefecName;
  final String prefecEmail;
  final String prefecCity;
  final String prefecState;
  final String prefecPassword;
  final String prefecCode;

  PrefecModel(this.prefecID, this.prefecName, this.prefecEmail, this.prefecCity,
      this.prefecState, this.prefecPassword, this.prefecCode);
  @override
  String toString() {
    return 'dados:{prefecID:$prefecID, prefecCode:$prefecCode, prefecName:$prefecName, prefecEmail:$prefecEmail, prefecCity:$prefecCity, prefecState:$prefecState, prefecPassword:$prefecPassword},';
  }

  PrefecModel.fromJson(Map<String, dynamic> json)
      : prefecID = json['prefecID'],
        prefecName = json['prefecName'],
        prefecEmail = json['prefecEmail'],
        prefecCity = json['prefecCity'],
        prefecState = json['prefecState'],
        prefecPassword = json['prefecPassword'],
        prefecCode = json['prefecCode'];

  Map<String, dynamic> toJson() => {
        'prefecID': prefecID,
        'prefecName': prefecName,
        'prefecEmail': prefecEmail,
        'prefecCity': prefecCity,
        'prefecState': prefecState,
        'prefecPassword': prefecPassword,
        'prefecCode' : prefecCode,
      };
}