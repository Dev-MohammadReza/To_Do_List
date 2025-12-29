import 'package:flutter/cupertino.dart';

import 'package:untitled33/data/source/source.dart';

class Repository<T> extends ChangeNotifier implements DataSource<T> {
  final DataSource<T> localDatasource;

  Repository({required this.localDatasource});
  @override
  Future<T> createOrUpdate(T data) async {
    final T rezult = await localDatasource.createOrUpdate(data);
    notifyListeners();
    return rezult;
  }

  @override
  Future<void> delete(data) async {
    localDatasource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    await localDatasource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async {
    localDatasource.deleteById(id);
    notifyListeners();
  }

  @override
  Future<T> findById(id) {
    return localDatasource.findById(id);
  }

  @override
  Future<List<T>> getAll() {
    return localDatasource.getAll();
  }
}
