// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jex_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JExModel _$JExModelFromJson(Map<String, dynamic> json) {
  return JExModel(
    days: json['dias'] as List<dynamic>,
    formatedStart: DateTime.parse(json['inicioFormatado'] as String),
    formatedEnd: DateTime.parse(json['fimFormatado'] as String),
  );
}

Map<String, dynamic> _$JExModelToJson(JExModel instance) => <String, dynamic>{
      'dias': instance.days,
      'inicioFormatado': instance.formatedStart.toIso8601String(),
      'fimFormatado': instance.formatedEnd.toIso8601String(),
    };
