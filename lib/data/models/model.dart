abstract class Model {
  static const int idForCreating = 0;
  // late int _id = -1;
  // late int _id;
  // int id;
  Model();
  // Model.protected();
  // Model(Map<String, dynamic> map);
  Model.fromMap(Map<String, dynamic>? map);
  // Model.parameters(Map<String, dynamic>? map);

  int get id;
  // int get id => _id;

  Map<String, dynamic> toMap();
}