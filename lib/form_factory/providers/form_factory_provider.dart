import 'package:flutter_form_factory/form_factory/helpers/form_field_parser.dart';
import 'package:flutter_form_factory/form_factory/model/form_dynamic_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DynamicFormStateNotifier extends StateNotifier<List<FormDynamicField>> {
  DynamicFormStateNotifier(super.fields);

  void updateFieldValue(String fieldName, dynamic newValue) {
    state = [
      for (final field in state)
        if (field.name == fieldName)
          FormDynamicField(
            name: field.name,
            label: field.label,
            type: field.type,
            format: field.format,
            hint: field.hint,
            values: field.values,
            lines: field.lines,
            value: newValue,
            validators: field.validators,
            options: field.options,
          )
        else
          field,
    ];
  }

  void submitForm() {
    final formData = {
      for (final field in state) field.name: field.value,
    };
    // ignore: avoid_print
    print('Form Submitted with Data: $formData');
  }
}

final formFactoryProvider = StateNotifierProvider.family<
    DynamicFormStateNotifier, List<FormDynamicField>, String>(
  (ref, jsonFormStructure) {
    return DynamicFormStateNotifier(
        FormFieldParser.parseJsonFormFields(jsonFormStructure));
  },
);
