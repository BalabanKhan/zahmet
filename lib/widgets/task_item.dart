import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/trip_provider.dart';
import '../utils/theme_utils.dart';
import '../l10n/app_texts.dart';

import '../screens/permission_screen.dart';
import '../screens/camera_prove_screen.dart';
import '../screens/endgame_screen.dart';
import '../screens/toxic_positivity_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class TaskItem extends ConsumerStatefulWidget {
  final TaskModel task;
  final int index;

  const TaskItem({super.key, required this.task, required this.index});

  @override
  ConsumerState<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> with SingleTickerProviderStateMixin {
  late AnimationController _resetController;
  double _dragExtent = 0.0;
  String? _currentLeftLabel;
  String? _currentRightLabel;
  final double _threshold = 120.0;
  bool _isCompleting = false;
  String _completingText = '';

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {
          _dragExtent = _dragExtent * (1.0 - _resetController.value);
        });
      });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    _resetController.stop();
    setState(() {
      _currentLeftLabel = AppTexts.swipePostpone;
      _currentRightLabel = AppTexts.swipeComplete;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.delta.dx;
    });
  }

  void _onDragEnd(DragEndDetails details) async {
    if (_dragExtent > _threshold) {
      // Swipe Right -> Complete task
      final taskNotifier = ref.read(taskProvider.notifier);
      final lower = widget.task.text.toLowerCase();
      
      final bool needsCameraCheck = AppTexts.cameraKeywords.any((k) => lower.contains(k)) || 
                                   (math.Random().nextDouble() < 0.10); // 10% optional random check

      if (needsCameraCheck) {
        final status = await Permission.camera.status;
        if (!status.isGranted && mounted) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PermissionScreen(
              permission: Permission.camera,
              threatMessage: AppTexts.cameraThreat,
              onGranted: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => CameraProveScreen(taskId: widget.task.id),
                ));
              },
            ),
          ));
        } else if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CameraProveScreen(taskId: widget.task.id),
          ));
        }
        _resetDrag();
      } else {
        setState(() {
          _isCompleting = true;
          _completingText = AppTexts.waitComplete;
        });
        _resetDrag();
        
        await Future.delayed(const Duration(milliseconds: 1500));
        if (!mounted) return;

        final message = await taskNotifier.completeTask(widget.task.id);
        if (!mounted) return;

        setState(() {
          _isCompleting = false;
        });

        if (message == 'ENDGAME_SIGNAL') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const EndgameScreen()));
          return;
        }
        if (message == 'EGG_TOXIC_POSITIVITY') {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ToxicPositivityScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(seconds: 1),
          ));
          return;
        }
        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message, style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)),
              backgroundColor: Colors.black87,
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          final showUndo = math.Random().nextDouble() < 0.05;
          final useDisbelief = math.Random().nextDouble() < 0.10;
          final infoText = useDisbelief ? AppTexts.disbelief : AppTexts.complete;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(infoText, style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)),
              backgroundColor: Colors.black87,
              duration: const Duration(seconds: 4),
              action: showUndo
                ? SnackBarAction(
                    label: AppTexts.undoAction,
                    textColor: Colors.white,
                    onPressed: () {
                      taskNotifier.undoCompleteTask(widget.task.id);
                    },
                  )
                : null,
            ),
          );
        }
      }
    } else if (_dragExtent < -_threshold) {
      // Swipe Left -> Postpone task
      HapticFeedback.heavyImpact();
      final message = await ref.read(taskProvider.notifier).postponeTask(widget.task.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message ?? AppTexts.postpone, style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)),
            backgroundColor: Colors.black87,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      _resetDrag();
    } else {
      _resetDrag();
    }
  }

  void _resetDrag() {
    _resetController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final tripState = ref.watch(tripProvider.notifier).tripState;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              final ctrl = TextEditingController(text: widget.task.text);
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.black,
                  title: Text(AppTexts.edit, style: GoogleFonts.inter(color: Colors.white)),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: ctrl,
                      maxLines: null,
                      minLines: 3,
                      style: GoogleFonts.inter(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(AppTexts.cancel, style: GoogleFonts.inter(color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        if (ctrl.text.trim() != widget.task.text && ctrl.text.trim().isNotEmpty) {
                          final msg = await ref.read(taskProvider.notifier).updateTask(widget.task.id, ctrl.text.trim());
                          if (msg != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg, style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)), backgroundColor: Colors.black87));
                          }
                        }
                      },
                      child: Text(AppTexts.save, style: GoogleFonts.inter(color: Colors.white)),
                    ),
                  ],
                )
              );
            },
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
            behavior: HitTestBehavior.opaque,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Swipe Background (Behind)
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isSwipeRight = _dragExtent > 0;
                      final progress = (_dragExtent.abs() / _threshold).clamp(0.0, 1.0);
                      
                      return Stack(
                        alignment: isSwipeRight ? Alignment.centerLeft : Alignment.centerRight,
                        children: [
                          if (isSwipeRight && _currentRightLabel != null)
                            Opacity(
                              opacity: progress,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  _currentRightLabel!,
                                  style: ThemeUtils.getTaskTextStyle(tripState).copyWith(color: Colors.grey, fontSize: 13),
                                ),
                              ),
                            )
                          else if (!isSwipeRight && _currentLeftLabel != null)
                            Opacity(
                              opacity: progress,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Text(
                                  _currentLeftLabel!,
                                  style: ThemeUtils.getTaskTextStyle(tripState).copyWith(color: Colors.grey, fontSize: 13),
                                ),
                              ),
                            ),
                        ],
                      );
                    }
                  ),
                ),
                
                // Swipe Foreground (Translating horizontally)
                Transform.translate(
                  offset: Offset(_dragExtent, 0),
                  child: Container(
                    color: const Color(0xFFF5F5F5), // Match main screen BG
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Builder(
                        builder: (context) {
                          if (_isCompleting) {
                            return Row(
                              children: [
                                const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: Colors.black45,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _completingText,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            );
                          }

                          double baseFontSize = 16.0;
                          double fontSize = baseFontSize;
                          if (widget.task.snoozeCount >= 3) {
                            fontSize = baseFontSize * math.pow(1.1, widget.task.snoozeCount - 2);
                          }
                          
                          final lineProgress = _dragExtent > 0 
                              ? (_dragExtent / _threshold).clamp(0.0, 1.0) 
                              : 0.0;
                          final isAlreadyLineThrough = widget.task.isPostponed;
                          
                          // Task Decay styling
                          final snoozeCount = widget.task.snoozeCount;
                          final double decayOpacity = (1.0 - (snoozeCount * 0.15)).clamp(0.4, 1.0);
                          final TextStyle baseStyle = ThemeUtils.getTaskTextStyle(tripState, fontSize: fontSize);
                          
                          return Opacity(
                            opacity: decayOpacity,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Text(
                                  widget.task.text,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: baseStyle.copyWith(
                                    fontStyle: snoozeCount > 0 ? FontStyle.italic : FontStyle.normal,
                                    decoration: isAlreadyLineThrough ? TextDecoration.lineThrough : null,
                                    decorationColor: isAlreadyLineThrough ? Colors.black26 : null,
                                    decorationThickness: isAlreadyLineThrough ? 2.0 : null,
                                  ),
                                ),
                                // Growing line-through over text as we swipe right
                                if (lineProgress > 0 && !isAlreadyLineThrough)
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FractionallySizedBox(
                                        widthFactor: lineProgress,
                                        child: Container(
                                          height: 2,
                                          color: Colors.black, // match square icon black tone exactly
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Custom Drag Handle Icon (2 horizontal stacked lines)
        ReorderableDragStartListener(
          index: widget.index,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 16.0, bottom: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 1.5, color: Colors.black26),
                const SizedBox(height: 3),
                Container(width: 12, height: 1.5, color: Colors.black26),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
