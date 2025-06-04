abstract class BaseModel {
  String get tableName;
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool isDeleted =false ;

  BaseModel({ required this.id, this.createdAt, this.updatedAt, this.isDeleted = false});

  Map<String, dynamic> toJson();

}
