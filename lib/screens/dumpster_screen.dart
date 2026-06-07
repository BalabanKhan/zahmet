import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';
import '../providers/task_provider.dart';
import '../l10n/app_texts.dart';
import '../widgets/back_triangle.dart';

class DumpsterScreen extends ConsumerStatefulWidget {
  const DumpsterScreen({super.key});

  @override
  ConsumerState<DumpsterScreen> createState() => _DumpsterScreenState();
}

class _DumpsterScreenState extends ConsumerState<DumpsterScreen> with SingleTickerProviderStateMixin {
  List<TaskModel> _completedTasks = [];
  bool _isLoading = true;
  
  // UX Torture State
  bool _isGatePhase = true;
  double _gateProgress = 0.0;
  Timer? _gateTimer;
  late String _gateText;

  @override
  void initState() {
    super.initState();
    _gateText = AppTexts.randomDumpsterGateText;
    _startGateTimer();
    _loadCompletedTasks();
  }

  void _startGateTimer() {
    _gateProgress = 0.0;
    _gateTimer?.cancel();
    _gateTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        // 5 seconds = 5000ms. 50ms interval -> 100 ticks.
        _gateProgress += 0.01;
        if (_gateProgress >= 1.0) {
          _gateProgress = 1.0;
          _isGatePhase = false;
          timer.cancel();
        }
      });
    });
  }

  void _onPanDown(DragDownDetails details) {
    if (_isGatePhase) {
      // User touched the screen! Reset timer.
      _startGateTimer();
    }
  }

  Future<void> _loadCompletedTasks() async {
    List<TaskModel> tasks;
    if (kIsWeb) {
      tasks = DatabaseService.webMockTasks.where((t) => t.isDeleted && t.completedAt != null).toList();
      tasks.sort((a, b) => b.completedAt!.compareTo(a.completedAt!));
    } else {
      tasks = await DatabaseService.isar!.taskModels.where()
          .filter()
          .isDeletedEqualTo(true)
          .completedAtIsNotNull()
          .findAll();
      tasks.sort((a, b) => b.completedAt!.compareTo(a.completedAt!));
    }

    if (mounted) {
      setState(() {
        _completedTasks = tasks;
        _isLoading = false;
      });
    }
  }

  Future<void> _onTaskTap(TaskModel task) async {
    // Show confirmation dialog
    final bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          content: Text(
            AppTexts.dumpsterRevivePrompt,
            style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppTexts.no, style: GoogleFonts.inter(color: Colors.black54)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppTexts.yes, style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Pick random prefix
      final prefix = AppTexts.dumpsterPrefixes[Random().nextInt(AppTexts.dumpsterPrefixes.length)];
      final newName = "$prefix${task.text.replaceAll(RegExp(r'^\[.*?\]\s*'), '')}"; // Replace old prefixes if any
      
      await ref.read(taskProvider.notifier).undoCompleteTask(task.id, newText: newName);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppTexts.randomDumpsterReviveText,
              style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12),
            ),
            backgroundColor: Colors.black87,
            duration: const Duration(seconds: 4),
          ),
        );
        _loadCompletedTasks();
      }
    }
  }

  @override
  void dispose() {
    _gateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isGatePhase) {
      return GestureDetector(
        onPanDown: _onPanDown,
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppTexts.dumpsterGateWarning,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _gateText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 48),
                  LinearProgressIndicator(
                    value: _gateProgress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                    minHeight: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // List Phase
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 12, right: 24),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 12, bottom: 12, right: 24),
                      child: const BackTriangle(color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    AppTexts.dumpsterTitle,
                    style: GoogleFonts.inter(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.black))
                  : _completedTasks.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Text(
                              AppTexts.dumpsterEmpty,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          itemCount: _completedTasks.length,
                          itemBuilder: (context, index) {
                            final task = _completedTasks[index];
                            final compDate = task.completedAt!;
                            final dateStr = "${compDate.day.toString().padLeft(2, '0')}/${compDate.month.toString().padLeft(2, '0')}";
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: GestureDetector(
                                onTap: () => _onTaskTap(task),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.black12),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        dateStr,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        task.text,
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: Colors.black45,
                                          decoration: TextDecoration.lineThrough,
                                          decorationColor: Colors.black26,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
