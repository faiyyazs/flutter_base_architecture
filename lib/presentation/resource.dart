import 'resource_state.dart';

class Resource<T> {
  ResourceState state;

  T data = null;
  String message = null;

  Resource();

  Resource.load({this.state = ResourceState.LOADING});

  Resource.success(
      {this.state = ResourceState.SUCCESS,
      this.data = null,
      this.message = null});

  Resource.error({this.state = ResourceState.ERROR, this.message = null});
}
