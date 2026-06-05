import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../l10n/app_texts.dart';

class CameraProveScreen extends ConsumerStatefulWidget {
  final int taskId;
  const CameraProveScreen({super.key, required this.taskId});

  @override
  ConsumerState<CameraProveScreen> createState() => _CameraProveScreenState();
}

class _CameraProveScreenState extends ConsumerState<CameraProveScreen> {
  CameraController? _controller;
  bool _isAnalyzing = false;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _fakeAnalysisAndFinish();
        return;
      }
      _controller = CameraController(cameras.first, ResolutionPreset.medium);
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      _fakeAnalysisAndFinish();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _takePicture() async {
    if (_isAnalyzing || _controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      await _controller!.takePicture();
      await Future.delayed(const Duration(seconds: 2));
      _fakeAnalysisAndFinish();
    } catch (e) {
      _fakeAnalysisAndFinish();
    }
  }

  void _fakeAnalysisAndFinish() {
    if (!mounted) return;
    ref.read(taskProvider.notifier).completeTask(widget.taskId);
    Navigator.of(context).pop(); 
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppTexts.cameraDisappointment,
          style: GoogleFonts.inter(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 12),
        ),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isAnalyzing)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.black, strokeWidth: 1),
                      const SizedBox(height: 16),
                      Text(
                        AppTexts.cameraAnalyzing,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w100),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppTexts.cameraAiDisbelief,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w100, fontSize: 10, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              )
            else if (_isCameraInitialized)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                  ),
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: SizedBox(
                          width: _controller!.value.previewSize?.height,
                          height: _controller!.value.previewSize?.width,
                          child: CameraPreview(_controller!),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 1))),
            
            if (!_isAnalyzing)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Text(
                      AppTexts.cameraProveButton,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
