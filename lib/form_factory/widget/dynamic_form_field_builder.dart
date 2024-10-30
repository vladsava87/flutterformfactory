import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_form_factory/form_factory/model/field_type_enum.dart';
import 'package:flutter_form_factory/form_factory/model/form_dynamic_field.dart';
import 'package:flutter_form_factory/form_factory/providers/form_factory_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class DynamicFormFieldBuilder {
  final WidgetRef ref;
  final GlobalKey<FormBuilderState> formKey;
  final String jsonFormStructure;
  final String? formTitle;
  final String? sumbitButtonText;
  final Function(String formata)? onFormSubmit;

  DynamicFormFieldBuilder({
    required this.ref,
    required this.formKey,
    required this.jsonFormStructure,
    this.sumbitButtonText,
    this.formTitle,
    this.onFormSubmit,
  });

  Widget renderForm() {
    final formFields = ref.watch(formFactoryProvider(jsonFormStructure));

    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          formTitle != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Text(
                    formTitle!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          for (final field in formFields) buildField(field),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.saveAndValidate()) {
                ref
                    .read(formFactoryProvider(jsonFormStructure).notifier)
                    .submitForm(onFormSubmit);
              } else {
                // ignore: avoid_print
                print('Form validation failed');
              }
            },
            child: sumbitButtonText != null
                ? Text(sumbitButtonText!)
                : const Text("Submit"),
          )
        ],
      ),
    );
  }

  Widget buildField<T>(FormDynamicField field) {
    switch (field.type) {
      case EFieldType.text:
      case EFieldType.email:
      case EFieldType.number:
      case EFieldType.multiline:
      case EFieldType.radio:
        return buildDynamicField(field);
      case EFieldType.dropdown:
        return buildDropdownField(field);
      case EFieldType.date:
        return buildDynamicDateTimeField(field);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildDynamicDateTimeField(FormDynamicField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FormBuilderDateTimePicker(
        name: field.name,
        inputType: InputType.date,
        format: DateFormat("MM/dd/yyyy"),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: field.label,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 73, 80, 85),
            fontSize: 16.0,
          ),
          hintText: field.hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 207, 207, 198),
              width: 1.0,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.black,
                size: 18.0,
              ),
            ),
          ),
        ),
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        initialValue: field.value,
        onChanged: (value) => ref
            .read(formFactoryProvider(jsonFormStructure).notifier)
            .updateFieldValue(field.name, value),
        validator: FormBuilderValidators.compose(field.validators!),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Widget buildDropdownField(FormDynamicField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FormBuilderDropdown<String>(
        name: field.name,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: field.label,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 73, 80, 85),
            fontSize: 16.0,
          ),
          hintText: field.hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 207, 207, 198),
              width: 1.0,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        ),
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        initialValue: field.value,
        items: field.options!.map((option) {
          return DropdownMenuItem<String>(
            value: option['value'],
            child: Text(option['label']),
          );
        }).toList(),
        onChanged: (value) => ref
            .read(formFactoryProvider(jsonFormStructure).notifier)
            .updateFieldValue(field.name, value),
        validator: FormBuilderValidators.compose(field.validators!),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Widget buildDynamicField(FormDynamicField field) {
    switch (field.type) {
      case EFieldType.text:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                formKey.currentState?.fields[field.name]?.validate();
              }
            },
            child: FormBuilderTextField(
              name: field.name,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: field.label,
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 73, 80, 85),
                  fontSize: 16.0,
                ),
                hintText: field.hint,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 207, 207, 198),
                    width: 1.0,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
              ),
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              initialValue: field.value,
              onChanged: (value) => ref
                  .read(formFactoryProvider(jsonFormStructure).notifier)
                  .updateFieldValue(field.name, value),
              validator: FormBuilderValidators.compose(field.validators!),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
        );

      case EFieldType.multiline:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  formKey.currentState?.fields[field.name]?.validate();
                }
              },
              child: FormBuilderTextField(
                name: field.name,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: field.label,
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 73, 80, 85),
                    fontSize: 16.0,
                  ),
                  hintText: field.hint,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 207, 207, 198),
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                ),
                maxLines: field.lines,
                initialValue: field.value?.toString(),
                onChanged: (value) => ref
                    .read(formFactoryProvider(jsonFormStructure).notifier)
                    .updateFieldValue(field.name, value),
                validator: FormBuilderValidators.compose(field.validators!),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              )),
        );

      case EFieldType.radio:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field.label),
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    formKey.currentState?.fields[field.name]?.validate();
                  }
                },
                child: FormBuilderRadioGroup(
                  validator: FormBuilderValidators.compose(field.validators!),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: field.name,
                  decoration: InputDecoration.collapsed(hintText: field.hint),
                  onChanged: (value) => ref
                      .read(formFactoryProvider(jsonFormStructure).notifier)
                      .updateFieldValue(field.name, value),
                  options: field.values!.map((value) {
                    return FormBuilderFieldOption<String>(value: value);
                  }).toList(),
                ),
              ),
            ],
          ),
        );

      case EFieldType.email:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  formKey.currentState?.fields[field.name]?.validate();
                }
              },
              child: FormBuilderTextField(
                name: field.name,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: field.label,
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 73, 80, 85),
                    fontSize: 16.0,
                  ),
                  hintText: field.hint,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 207, 207, 198),
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                ),
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                initialValue: field.value?.toString(),
                onChanged: (value) => ref
                    .read(formFactoryProvider(jsonFormStructure).notifier)
                    .updateFieldValue(field.name, value),
                validator: FormBuilderValidators.compose(field.validators!),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              )),
        );

      case EFieldType.number:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  formKey.currentState?.fields[field.name]?.validate();
                }
              },
              child: FormBuilderTextField(
                name: field.name,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: field.label,
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 73, 80, 85),
                    fontSize: 16.0,
                  ),
                  hintText: field.hint,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  prefixText: field.format,
                  prefixStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 207, 207, 198),
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                ),
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                initialValue: field.value?.toString(),
                onChanged: (value) => ref
                    .read(formFactoryProvider(jsonFormStructure).notifier)
                    .updateFieldValue(field.name, value),
                validator: FormBuilderValidators.compose(field.validators!),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              )),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
