abstract class Model {
  static const int idForCreating = 0;

  Model();

  Model.fromMap(Map<String, dynamic>? map);

  int get id;

  Map<String, dynamic> toMap();
}
