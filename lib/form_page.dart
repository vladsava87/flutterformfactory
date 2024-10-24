import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_form_factory/data/form_data.dart';
import 'package:flutter_form_factory/form_factory/widget/dynamic_form_field_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FormPage extends StatefulHookConsumerWidget {
  const FormPage({super.key, required this.title});
  final String title;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormPageState();
}

class _FormPageState extends ConsumerState<FormPage> {
  late GlobalKey<FormBuilderState> formKey;
  late String jsonFormStructure;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormBuilderState>();
    jsonFormStructure = FormData.jsonForm;
  }

  @override
  Widget build(BuildContext context) {
    final formFieldBuilder = DynamicFormFieldBuilder(
      ref: ref,
      formKey: formKey,
      jsonFormStructure: jsonFormStructure,
      sumbitButtonText: "Submit form",
      formTitle: "Employee form",
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                formFieldBuilder.renderForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
