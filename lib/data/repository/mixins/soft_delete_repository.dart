mixin SoftDeleteRepository {
  static const columnDeletedAt = 'deleted_at';

  get onCreateRow {
    return '''
      $columnDeletedAt INTEGER
    ''';
  }

  static onWhereNotDeleted({ String alias = '' }) {
    if (alias != '') {
      alias += '.';
    }

    return '$alias$columnDeletedAt IS NULL';
  }

  static onWhereDeleted({ String alias = '' }) {
    if (alias != '') {
      alias += '.';
    }

    return '$alias$columnDeletedAt IS NOT NULL';
  }
}