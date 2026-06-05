import '../l10n/app_texts.dart';

class NlpResult {
  final String processedText;
  final String? whisperMessage;
  final String? snackBarMessage;
  final bool shouldBlock;
  final bool isEndgame;

  NlpResult({
    required this.processedText,
    this.whisperMessage,
    this.snackBarMessage,
    this.shouldBlock = false,
    this.isEndgame = false,
  });
}

class NlpService {
  static String analyzeAndReact(String text) {
    // Eski basit analiz yöntemi, geriye dönük uyumluluk veya TripProvider için kalabilir
    final lower = text.toLowerCase();
    
    if (AppTexts.nlpDietKeywords.any((k) => lower.contains(k))) {
      return "$text (${AppTexts.nlpDietReaction})";
    }
    
    if (AppTexts.nlpSportKeywords.any((k) => lower.contains(k))) {
      return "$text (${AppTexts.nlpSportReaction})";
    }
    
    if (AppTexts.nlpStudyKeywords.any((k) => lower.contains(k))) {
      return "$text (${AppTexts.nlpStudyReaction})";
    }

    if (AppTexts.nlpExKeywords.any((k) => lower.contains(k))) {
      return "$text (${AppTexts.nlpExReaction})";
    }

    return "$text (${AppTexts.nlpDefaultReaction})";
  }

  static NlpResult analyzeTaskSubmission(String rawText, DateTime now) {
    if (rawText.trim().toLowerCase() == 'zahmet endgame' || rawText.trim().toLowerCase() == 'epilogue') {
      return NlpResult(processedText: rawText, isEndgame: true);
    }

    String finalTxt = rawText.trim();
    final lower = finalTxt.toLowerCase();

    // 1. Emoji Check (Can change finalTxt)
    final emojiRegex = RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
    String? emojiMsg;
    if (emojiRegex.hasMatch(finalTxt)) {
      finalTxt = finalTxt.replaceAll(emojiRegex, '').trim();
      emojiMsg = AppTexts.kekstraEmojiBan;
      if (finalTxt.isEmpty) {
        return NlpResult(processedText: '', snackBarMessage: emojiMsg, shouldBlock: true);
      }
    }

    // 2. Caps Lock Check (Changes finalTxt to lower if screaming)
    String? capsMsg;
    if (finalTxt == finalTxt.toUpperCase() && finalTxt.contains(RegExp('[A-ZÇĞİÖŞÜa-zA-Z]'))) {
      finalTxt = finalTxt.toLowerCase();
      capsMsg = AppTexts.kekstraCaps;
    }

    // 3. Blocking Checks (Tasks that are refused)
    if (lower.contains('chatgpt') || lower.contains('siri') || lower.contains('yapay zeka') || lower.contains('gemini')) {
      return NlpResult(processedText: finalTxt, snackBarMessage: AppTexts.kekstraAiComplex, shouldBlock: true);
    }

    if (lower.contains('bıktım') || lower.contains('yoruldum') || lower.contains('yapamıyorum') || lower.contains('tükendim')) {
      return NlpResult(processedText: finalTxt, snackBarMessage: AppTexts.kekstraTherapy, shouldBlock: true);
    }

    if (lower == 'su iç' || lower == 'nefes al' || lower == 'uyan') {
      return NlpResult(processedText: finalTxt, snackBarMessage: AppTexts.kekstraBasicLife, shouldBlock: true);
    }

    if (lower.contains('hayatını düzene sok') || lower.contains('zengin ol') || lower.contains('yazılım öğren') || lower.contains('plan yap')) {
      return NlpResult(processedText: finalTxt, snackBarMessage: AppTexts.kekstraMacroGoal, shouldBlock: true);
    }

    // 4. Whisper Messages (Full screen dark overlay messages)
    if (lower.contains('annemi ara') || lower.contains('doğum günü') || lower.contains('kutla')) {
      return NlpResult(processedText: finalTxt, whisperMessage: AppTexts.kekstraSocialNeglect, snackBarMessage: emojiMsg ?? capsMsg);
    }

    if (lower.contains('udemy') || lower.contains('kursa başla') || lower.contains('yazılım öğren') || lower.contains('python') || lower.contains('dil öğren')) {
      return NlpResult(processedText: finalTxt, whisperMessage: AppTexts.kekstraDigitalGraveyard, snackBarMessage: emojiMsg ?? capsMsg);
    }

    if (lower.contains('hayatını düzelt') || lower.contains('daha iyi biri ol') || lower.contains('mutlu ol') || lower.contains('sadeleş')) {
      return NlpResult(processedText: finalTxt, whisperMessage: AppTexts.kekstraExistential, shouldBlock: true); // Blocked this conceptually in home_screen
    }

    if (lower.contains('eski sevgili') || lower.contains('numarayı sil') || lower.contains('stalk yapma') || lower.contains('mesaj atma')) {
      return NlpResult(processedText: finalTxt, whisperMessage: AppTexts.kekstraToxicExV2, shouldBlock: true); // Blocked in home_screen
    }

    if (lower.contains('dopamin detoksu') || lower.contains('sosyal medya diyeti') || lower.contains('ekrandan uzaklaş')) {
      return NlpResult(processedText: finalTxt, whisperMessage: AppTexts.kekstraDopamineDetox, shouldBlock: true); // Blocked
    }

    if (lower.contains('iade et') || lower.contains('trendyol') || lower.contains('kargoyu ver') || lower.contains('kredi kartı') || lower.contains('asgari ödeme')) {
      return NlpResult(processedText: finalTxt, whisperMessage: AppTexts.kekstraCargoFinanceV2, snackBarMessage: emojiMsg ?? capsMsg);
    }

    if (lower.contains('podcast dinle') || lower.contains('belgesel') || lower.contains('50 sayfa oku') || lower.contains('makale')) {
      return NlpResult(processedText: finalTxt, whisperMessage: AppTexts.kekstraIntellectualV2, snackBarMessage: emojiMsg ?? capsMsg);
    }

    if (lower.contains('bavul hazırla') || lower.contains('bilet al') || lower.contains('tatile çık')) {
      return NlpResult(processedText: finalTxt, whisperMessage: AppTexts.kekstraVacationPride, snackBarMessage: emojiMsg ?? capsMsg);
    }

    if (lower.contains('bulaşık') || lower.contains('çamaşır') || lower.contains('süpürge') || lower.contains('toz al')) {
      return NlpResult(processedText: finalTxt, whisperMessage: AppTexts.kekstraHouseSlave, snackBarMessage: emojiMsg ?? capsMsg);
    }

    // 5. SnackBar Rules (Time & Keyword based)
    String? finalSnackBar = emojiMsg ?? capsMsg;

    if (now.hour >= 2 && now.hour < 5) {
      finalSnackBar = finalSnackBar ?? AppTexts.kekstraNight;
    }

    if (lower.contains('mail at') || lower.contains('tez yaz') || lower.contains('sunum') || lower.contains('vize') || lower.contains('rapor')) {
      finalSnackBar = finalSnackBar ?? AppTexts.kekstraCorporate;
    }

    if (lower.contains('eski sevgili') || lower.contains('mesaj atma') || lower.contains('stalk') || lower.contains('ara')) {
      finalSnackBar = finalSnackBar ?? AppTexts.kekstraToxicEx;
    }

    if (lower.contains('fatura') || lower.contains('kredi kartı') || lower.contains('vergi') || lower.contains('kira')) {
      finalSnackBar = finalSnackBar ?? AppTexts.kekstraFinance;
    }

    if (lower.contains('kitap oku') || lower.contains('podcast') || lower.contains('makale') || lower.contains('50 sayfa')) {
      finalSnackBar = finalSnackBar ?? AppTexts.kekstraIntellectual;
    }

    if (now.weekday == DateTime.sunday && now.hour >= 20 && (lower.contains('spor') || lower.contains('diyet') || lower.contains('koşu') || lower.contains('gym') || lower.contains('detoks'))) {
      finalSnackBar = finalSnackBar ?? AppTexts.kekstraGym;
    }

    if ((now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) && now.hour >= 22) {
      if (lower.contains('çalış') || lower.contains('ders') || lower.contains('sunum') || lower.contains('kod')) {
        finalSnackBar = finalSnackBar ?? AppTexts.kekstraWeekend;
      }
    }

    return NlpResult(
      processedText: finalTxt,
      snackBarMessage: finalSnackBar,
    );
  }
}
