enum CrudMenuItems {
  create('insert'),
  read('get'),
  edit('update'),
  delete('softDelete');

  final String methodName;

  const CrudMenuItems(this.methodName);
}