import 'package:flutter/widgets.dart';
import 'package:flutter_form_factory/form_factory/model/field_type_enum.dart';

class FormDynamicField<T> {
  final String name;
  final String label;
  final EFieldType type;
  final String? hint;
  final String? format;
  final int? lines;
  final List<String>? values;
  final T? value;
  final List<FormFieldValidator<dynamic>> validators;
  final List<Map<String, dynamic>>? options;

  FormDynamicField({
    required this.name,
    required this.label,
    required this.type,
    this.hint,
    this.format,
    this.value,
    this.lines,
    this.values,
    this.validators = const [],
    this.options,
  });
}
