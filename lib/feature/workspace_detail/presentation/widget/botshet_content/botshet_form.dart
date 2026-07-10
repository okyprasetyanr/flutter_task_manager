import 'package:flutter/material.dart';
import 'package:task_manager/feature/shared_component/widget/drop_down/widget_drop_down.dart';
import 'package:task_manager/feature/workspace_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';

class BotshetForm extends StatelessWidget {
  final TextEditingController nameController;
  final GlobalKey<FormState> keyForm;
  final ModelProjectMerge? data;
  final ValueNotifier<EnumProjectStatus> projectStatus;
  final ValueNotifier<EnumProjectType> projectType;
  const BotshetForm({
    super.key,
    required this.nameController,
    required this.keyForm,
    this.data,
    required this.projectStatus,
    required this.projectType,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: keyForm,
      child: Column(
        children: [
          CustomTextField(
            label: "Name",
            controller: nameController,
            enable: data == null,
            validator: (value) =>
                value!.isEmpty ? "Project Name required!" : null,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<EnumProjectType>(
                  valueListenable: projectType,
                  builder: (context, value, child) =>
                      WidgetDropDown<EnumProjectType>(
                        extension: (extension) => extension.text,
                        initialValue: value,
                        filters: EnumProjectType.values,
                        text: "Type",
                        selectedValue: (selectedEnum) =>
                            projectType.value = selectedEnum,
                      ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ValueListenableBuilder<EnumProjectStatus>(
                  valueListenable: projectStatus,
                  builder: (context, value, child) =>
                      WidgetDropDown<EnumProjectStatus>(
                        extension: (extension) => extension.text,
                        initialValue: value,
                        filters: EnumProjectStatus.values,
                        text: "Status",
                        selectedValue: (selectedEnum) =>
                            projectStatus.value = selectedEnum,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
