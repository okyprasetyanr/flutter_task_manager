import 'package:flutter/material.dart';
import 'package:task_manager/core/root_scaffold_messenger_key/root_scaffold_message_key.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/shared/style/text_size.dart';

void customRootSnackBar(CollectorMessage data) {
  rootScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(
        data.noconnection ?? data.failed ?? data.error!,
        style: lv1TextStyleWhite,
      ),
      backgroundColor: Colors.red,
    ),
  );
}
