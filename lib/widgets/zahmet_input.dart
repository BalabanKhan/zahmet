import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:battery_plus/battery_plus.dart';

import '../providers/task_provider.dart';
import '../providers/trip_provider.dart';
import '../l10n/app_texts.dart';
import '../screens/endgame_screen.dart';

class ZahmetInputWidget extends ConsumerStatefulWidget {
  final Function(String) onWhisperMessage;

  const ZahmetInputWidget({super.key, required this.onWhisperMessage});

  @override
  ConsumerState<ZahmetInputWidget> createState() => _ZahmetInputWidgetState();
}

class _ZahmetInputWidgetState extends ConsumerState<ZahmetInputWidget> {
  final TextEditingController _controller = TextEditingController();
  int _backspaceCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit(String text) async {
    if (text.isEmpty) return;

    final battery = Battery();
    final level = await battery.batteryLevel;
    if (level < 5) {
      FocusScope.of(context).unfocus();
      _controller.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppTexts.kekstraBattery, style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)), backgroundColor: Colors.black87)
        );
      }
      return;
    }

    final response = await ref.read(taskProvider.notifier).addTask(text);
    
    if (response.isEndgame) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const EndgameScreen()));
      return;
    }

    if (response.whisperMessage != null) {
      FocusScope.of(context).unfocus();
      widget.onWhisperMessage(response.whisperMessage!);
    }

    if (response.snackBarMessage != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.snackBarMessage!, style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)), backgroundColor: Colors.black87));
    }

    _controller.clear();
    _backspaceCount = 0;
  }

  void _onTextChanged(String text) {
    if (text.length >= 60) {
      FocusScope.of(context).unfocus();
      _controller.text = text.substring(0, 59);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppTexts.kekstraCharLimit, style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)), backgroundColor: Colors.black87));
      }
      return;
    }

    _backspaceCount++;
    if (_backspaceCount > 15) {
      ref.read(tripProvider.notifier).increaseScore(5);
      _backspaceCount = 0;
      FocusScope.of(context).unfocus();
      _controller.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppTexts.kekstraBackspace, style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12)), backgroundColor: Colors.black87, duration: const Duration(seconds: 4)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: TextField(
        controller: _controller,
        onSubmitted: _handleSubmit,
        onChanged: _onTextChanged,
        style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        decoration: InputDecoration(
          hintText: AppTexts.hintText,
          hintStyle: GoogleFonts.roboto(color: const Color(0xFF9E9E9E), fontWeight: FontWeight.w500),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
