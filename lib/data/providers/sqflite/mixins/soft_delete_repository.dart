mixin SoftDeleteRepository {
  static const columnDeletedAt = 'deleted_at';

  get rowCreateSoftDeleteColumn {
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