import 'enum.dart';

class ResourceState extends Enum<int> {
  const ResourceState(int val) : super(val);
  static const ResourceState LOADING = const ResourceState(0);
  static const ResourceState SUCCESS = const ResourceState(1);
  static const ResourceState ERROR = const ResourceState(2);
}
