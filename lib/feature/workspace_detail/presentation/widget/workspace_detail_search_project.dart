import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';

class WorkspaceDetailSearchProject extends StatefulWidget {
  const WorkspaceDetailSearchProject({super.key});

  @override
  State<WorkspaceDetailSearchProject> createState() =>
      _WorkspaceDetailSearchProjectState();
}

class _WorkspaceDetailSearchProjectState
    extends State<WorkspaceDetailSearchProject> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceDetailBloc, WorkspaceDetailState>(
      listenWhen: (previous, current) =>
          previous is WorkspaceDetailStateLoaded &&
          current is WorkspaceDetailStateLoaded &&
          previous.selectedType != current.selectedType,
      listener: (context, state) => searchController.clear(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CustomTextField(
          controller: searchController,
          label: "Search",
          prefix: Icon(Icons.search, color: AppPropertyColor.black),
          onChanged: (value) => context.read<WorkspaceDetailBloc>().add(
            WorkspaceDetailEventSearchProject(search: value),
          ),
        ),
      ),
    );
  }
}
