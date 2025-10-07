import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
class TodoModel with _$TodoModel {
  const factory TodoModel({
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'finished') required bool finished,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
}
