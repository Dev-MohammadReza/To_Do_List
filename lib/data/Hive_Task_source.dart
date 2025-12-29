import 'package:hive_flutter/adapters.dart';
import 'package:untitled33/data/dart.dart';
import 'package:untitled33/data/source/source.dart';

class HiveTaskDataSource implements DataSource<Task> {
  final Box<Task> box;

  HiveTaskDataSource({required this.box});

  @override
  Future<Task> createOrUpdate(Task data) async {
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(Task data) {
    return data.delete();
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) {
    return box.delete(id);
  }

  @override
  Future<Task> findById(id) async {
    return box.values.firstWhere((test) => test.id == id);
  }

  @override
  Future<List<Task>> getAll() async {
    return box.values.toList();
  }
}