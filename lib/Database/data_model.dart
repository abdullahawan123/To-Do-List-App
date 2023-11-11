

class DataModel {
  final int? id ;
  final String title ;
  final String description ;
  final String status ;

  DataModel({this.id, required this.title, this.description= 'Empty', this.status = 'Pending'});

  DataModel.fromMap(Map<String, dynamic> res,):
  id = res['id'],
  title = res['title'],
  description = res['description'],
  status = res['status'] ;

  Map<String, Object?> toMap(){
    return {
      'id' : id ,
      'title' : title ,
      'description' : description ,
      'status' : status
    };
  }
}