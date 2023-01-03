class TodoList {
  final int? postId;
  final String title;
  final String description;
  final String? datestamp;


  TodoList({this.postId, required this.title, required this.description, this.datestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': postId,
      'title': title,
      'description': description,
      'date': datestamp,
    };
  }

}