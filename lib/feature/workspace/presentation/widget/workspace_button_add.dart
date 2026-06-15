import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_botshet_content.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';

class WorkspaceButtonAdd extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> keyForm;
  const WorkspaceButtonAdd({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.keyForm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FloatingActionButton(
        backgroundColor: AppPropertyColor.primary,
        elevation: 3,
        child: const Icon(Icons.add_rounded, color: AppPropertyColor.white),
        onPressed: () {
          final bloc = context.read<WorkspaceBloc>();
          return customBottomSheet(
            context: context,
            resetItemForm: () {
              nameController.clear();
              descriptionController.clear();
            },
            content: (scrollController) {
              return BlocProvider.value(
                value: bloc,
                child: WorkspaceBotshetContent(
                  nameController: nameController,
                  descriptionController: descriptionController,
                  keyForm: keyForm,
                  scrollController: scrollController,
                  update: false,
                  onPressed: ({required description, required name}) =>
                      context.read<WorkspaceBloc>().add(
                        WorkspaceEventCreateWorkspace(
                          name: name,
                          description: description,
                        ),
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
