class LocationModel {
  final String lInfo;
  final int id;
  final String photo;
  final String info;
  final String type;
  final String status;

  LocationModel(
    this.id,
    this.lInfo,
    this.photo,
    this.info,
    this.type,
    this.status,
  );
  @override
  String toString() {
    return 'dados:{id:$id, Localização:$lInfo, photo:$photo}, info:$info, type:$type, status:$status ';
  }

  LocationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lInfo = json['location'],
        photo = json['photo'],
        info = json['info'],
        type = json['type'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'location': lInfo,
        'photo': photo,
        'info': info,
        'type': type,
        'status': status,
      };
}