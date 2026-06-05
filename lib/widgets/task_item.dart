import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/trip_provider.dart';
import '../utils/theme_utils.dart';
import '../l10n/app_texts.dart';

import '../screens/permission_screen.dart';
import '../screens/camera_prove_screen.dart';
import '../screens/endgame_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class TaskItem extends ConsumerWidget {
  final TaskModel task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(tripProvider.notifier).tripState;

    return GestureDetector(
      onTap: () {
        final ctrl = TextEditingController(text: task.text);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.black,
            title: Text("düzenle", style: GoogleFonts.roboto(color: Colors.white)),
            content: TextField(
              controller: ctrl,
              style: GoogleFonts.roboto(color: Colors.white),
              decoration: const InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24))),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("iptal", style: GoogleFonts.roboto(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  if (ctrl.text.trim() != task.text && ctrl.text.trim().isNotEmpty) {
                    final msg = await ref.read(taskProvider.notifier).updateTask(task.id, ctrl.text.trim());
                    if (msg != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg, style: GoogleFonts.roboto(fontWeight: FontWeight.w300, color: const Color(0xFFBDBDBD), fontSize: 12)), backgroundColor: Colors.black87));
                    }
                  }
                },
                child: Text("kaydet", style: GoogleFonts.roboto(color: Colors.white)),
              ),
            ],
          )
        );
      },
      child: Dismissible(
        key: Key(task.id.toString()),
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: Text(AppTexts.postpone, style: ThemeUtils.getTaskTextStyle(tripState).copyWith(color: Colors.grey)),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: Text(AppTexts.complete, style: ThemeUtils.getTaskTextStyle(tripState).copyWith(color: Colors.grey)),
        ),
        confirmDismiss: (direction) async {
          if (tripState == TripState.normal) {
            HapticFeedback.lightImpact();
          }

          if (direction == DismissDirection.startToEnd) {
            // Postpone
            final message = await ref.read(taskProvider.notifier).postponeTask(task.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message ?? AppTexts.postpone, style: GoogleFonts.roboto(fontWeight: FontWeight.w300, color: const Color(0xFFBDBDBD), fontSize: 12)), backgroundColor: Colors.black87, duration: const Duration(seconds: 2)));
            }
            return false; // Snap back and cross out
          } else {
            // Complete
            final lower = task.text.toLowerCase();
            if (AppTexts.cameraKeywords.any((k) => lower.contains(k))) {
              final status = await Permission.camera.status;
              if (!status.isGranted && context.mounted) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PermissionScreen(
                    permission: Permission.camera,
                    threatMessage: AppTexts.cameraThreat,
                    onGranted: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => CameraProveScreen(taskId: task.id),
                      ));
                    },
                  ),
                ));
              } else if (context.mounted) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => CameraProveScreen(taskId: task.id),
                ));
              }
              return false; // Snap back, camera screen will handle completion
            } else {
              return true; // Dismiss the widget and trigger onDismissed
            }
          }
        },
        onDismissed: (direction) async {
          if (direction == DismissDirection.endToStart) {
            final message = await ref.read(taskProvider.notifier).completeTask(task.id);
            if (!context.mounted) return;
            if (message == 'ENDGAME_SIGNAL') {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const EndgameScreen()));
              return;
            }
            if (message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message, style: GoogleFonts.roboto(fontWeight: FontWeight.w300, color: const Color(0xFFBDBDBD), fontSize: 12)),
                  backgroundColor: Colors.black87,
                  duration: const Duration(seconds: 4),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppTexts.complete, style: GoogleFonts.roboto(fontWeight: FontWeight.w300, color: const Color(0xFFBDBDBD), fontSize: 12)),
                  backgroundColor: Colors.black87,
                  duration: const Duration(seconds: 4),
                  action: SnackBarAction(
                    label: AppTexts.undoAction,
                    textColor: Colors.white,
                    onPressed: () {
                      ref.read(taskProvider.notifier).undoCompleteTask(task.id);
                    },
                  ),
                ),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            task.text,
            style: ThemeUtils.getTaskTextStyle(tripState).copyWith(
              decoration: task.isPostponed ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }
}
