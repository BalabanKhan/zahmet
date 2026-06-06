import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../providers/task_provider.dart';
import '../providers/trip_provider.dart';
import '../widgets/task_item.dart';
import '../widgets/zahmet_input.dart';
import '../services/notification_service.dart';
import 'apology_screen.dart';
import 'dumpster_screen.dart';
import 'record_screen.dart';
import '../l10n/app_texts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  
  bool _isScreenshotDetected = false;
  bool _isShaking = false;
  StreamSubscription? _accelerometerSubscription;
  ScreenCaptureEvent? screenListener;
  DateTime? _pausedTime;
  
  final ScrollController _scrollController = ScrollController();
  bool _scrollLocked = false;
  int _scrollAnxietyCount = 0;

  bool _cargoAlertShown = false;
  
  String? _whisperMessage;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationService.initialize().then((_) {
      NotificationService.scheduleDailyReminder();
    });

    _checkLastOpened();

    if (!kIsWeb) {
      screenListener = ScreenCaptureEvent();
      screenListener!.addScreenShotListener((filePath) {
        setState(() => _isScreenshotDetected = true);
      });
      screenListener!.watch();
    }

    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      final gX = event.x.abs();
      final gY = event.y.abs();
      if (gX > 15 || gY > 15) {
        if (!_isShaking) {
          if (!mounted) return;
          setState(() => _isShaking = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppTexts.kekstraShake, style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)), backgroundColor: Colors.black87)
          );
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => _isShaking = false);
          });
        }
      }
    });

    _scrollController.addListener(() {
      if (_scrollLocked) return;
      _scrollAnxietyCount++;
      if (_scrollAnxietyCount > 30) {
        setState(() => _scrollLocked = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppTexts.kekstraAnxietyScroll, style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)), backgroundColor: Colors.black87)
        );
      }

      // KART 5: Büyük Ödül (%0.1)
      if (Random().nextDouble() < 0.001) {
        showDialog(
          context: context,
          builder: (ctx) => Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                Navigator.of(ctx).pop();
                showDialog(
                  context: context,
                  builder: (ctx2) => Dialog(
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Text(".", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 48, color: Colors.black)),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amberAccent, width: 4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.card_giftcard, size: 64, color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      AppTexts.eggGiftBoxLabel,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  Future<void> _checkLastOpened() async {
    final lastOpenedStr = await _storage.read(key: 'lastOpenedAt');
    if (lastOpenedStr != null) {
      final lastOpened = DateTime.parse(lastOpenedStr);
      if (DateTime.now().difference(lastOpened).inDays >= 3) {
        Future.delayed(const Duration(seconds: 2), () {
          if (ref.read(taskProvider).isNotEmpty && mounted) {
            setState(() => _whisperMessage = AppTexts.kekstraBadgeHoarder);
          }
        });
      }
    }
    await _storage.write(key: 'lastOpenedAt', value: DateTime.now().toIso8601String());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _accelerometerSubscription?.cancel();
    _scrollController.dispose();
    if (!kIsWeb) {
      screenListener?.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      _pausedTime = DateTime.now();
      
      final tasks = ref.read(taskProvider);
      if (tasks.isNotEmpty) {
        NotificationService.showNotification(
          id: 0,
          title: AppTexts.notifTitle,
          body: AppTexts.notifBody,
        );
      }
    } else if (state == AppLifecycleState.resumed) {
      // KART 4: Şarj Vampiri (%0.5)
      if (Random().nextDouble() < 0.005) {
        HapticFeedback.heavyImpact();
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              backgroundColor: Colors.black,
              content: Text(
                AppTexts.eggBatteryVampire,
                style: GoogleFonts.firaCode(color: Colors.redAccent, fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(AppTexts.isTr ? "tamam" : "ok", style: GoogleFonts.inter(color: Colors.white54)),
                )
              ],
            ),
          );
        }
      }

      if (_pausedTime != null) {
        final diff = DateTime.now().difference(_pausedTime!);
        if (diff.inSeconds > 15) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(AppTexts.kekstraAppSwitch, style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)), backgroundColor: Colors.black87)
           );
        }
      }

      final clipboardData = await Clipboard.getData('text/plain');
      if (clipboardData != null && clipboardData.text != null && clipboardData.text!.isNotEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppTexts.kekstraPaste,
              style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12),
            ),
            backgroundColor: Colors.black87,
            duration: const Duration(seconds: 3),
          ),
        );
        await Clipboard.setData(const ClipboardData(text: ''));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);

    if (tasks.isEmpty && _scrollLocked) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
         setState(() {
           _scrollLocked = false;
           _scrollAnxietyCount = 0;
         });
       });
    }

    if (!_cargoAlertShown && tasks.isNotEmpty) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
         for (var t in tasks) {
            final diff = DateTime.now().difference(t.createdAt).inDays;
            final lower = t.text.toLowerCase();
            if (diff >= 3 && (lower.contains('kargo') || lower.contains('iade') || lower.contains('trendyol'))) {
               if (mounted) {
                 setState(() => _cargoAlertShown = true);
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppTexts.kekstraCargo, style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)), backgroundColor: Colors.black87, duration: const Duration(seconds: 5)));
               }
               break;
            }
         }
       });
    }

    final isOrphan = tasks.length == 1 && DateTime.now().difference(tasks[0].createdAt).inDays >= 2;

    Widget mainUI = Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 12, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DumpsterScreen()));
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(top: 12, bottom: 12, right: 24),
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.rectangle),
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecordScreen()));
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24),
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isOrphan)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    AppTexts.kekstraOrphan,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: Colors.black45, fontSize: 16, height: 1.5),
                  ),
                ),
              Expanded(
                child: tasks.isEmpty
                    ? RefreshIndicator(
                        color: Colors.black,
                        backgroundColor: Colors.white,
                        onRefresh: () async {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppTexts.kekstraPullRefresh, style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)), backgroundColor: Colors.black87));
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(AppTexts.emptyTasks, textAlign: TextAlign.center, style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), height: 1.5)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ReorderableListView.builder(
                        scrollController: _scrollController,
                        physics: _scrollLocked ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        itemCount: tasks.length,
                        onReorder: (oldIndex, newIndex) async {
                           final msg = await ref.read(taskProvider.notifier).reorderTasks(oldIndex, newIndex);
                           if (mounted) {
                             final finalMsg = msg ?? AppTexts.dragSarcasm;
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: Text(
                                   finalMsg,
                                   style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12),
                                 ),
                                 backgroundColor: Colors.black87,
                               ),
                             );
                           }
                        },
                        buildDefaultDragHandles: false,
                        itemBuilder: (context, index) {
                          return ReorderableDelayedDragStartListener(
                            key: ValueKey(tasks[index].id),
                            index: index,
                            child: Transform.scale(
                              scale: isOrphan ? 1.15 : 1.0,
                              child: TaskItem(task: tasks[index], index: index)
                            ),
                          );
                        },
                      ),
              ),
              ZahmetInputWidget(
                onWhisperMessage: (msg) {
                  if (mounted) {
                    setState(() => _whisperMessage = msg);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (_isScreenshotDetected) {
      return Stack(
        children: [
          mainUI,
          Container(
            color: Colors.black,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(32),
            child: Material(
              color: Colors.transparent,
              child: Text(AppTexts.kekstraScreenshot, textAlign: TextAlign.center, style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 18)),
            ),
          ),
        ],
      );
    }

    if (_isShaking) {
      mainUI = Transform.translate(
        offset: Offset(Random().nextDouble()*10-5, Random().nextDouble()*10-5),
        child: mainUI,
      );
    }

    if (_whisperMessage != null) {
      return Stack(
        children: [
          mainUI,
          GestureDetector(
            onTap: () {
               setState(() => _whisperMessage = null);
            },
            child: Container(
              color: const Color(0xFFF5F5F5).withOpacity(0.97),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(40),
              child: Material(
                color: Colors.transparent,
                child: Text(
                  _whisperMessage!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 18, height: 1.5),
                ),
              ),
            ),
          )
        ],
      );
    }

    return mainUI;
  }
}
