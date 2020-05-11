import 'package:flutter/foundation.dart';
import 'package:flutter_demo/sql_demo/sql.helper.dart';

class Note {
  final int id;
  final String title;
  final String discription;
  final String createdAt;
  final String updatedAt;

  Note({
    this.id,
    @required this.title,
    this.discription,
    @required this.createdAt,
    @required this.updatedAt,
  })  : assert(title != null),
        assert(createdAt != null),
        assert(updatedAt != null);

  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      SQLHelper.columnId: id,
      SQLHelper.columnTitle: title,
      SQLHelper.columnDiscription: discription,
      SQLHelper.columnCreatedAt: createdAt,
      SQLHelper.columnUpdatedAt: updatedAt,
    };
  }
}
