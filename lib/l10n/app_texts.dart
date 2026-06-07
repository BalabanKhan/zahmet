import 'dart:ui';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../providers/trip_provider.dart';

class AppTexts {
  static bool get isTr => PlatformDispatcher.instance.locale.languageCode == 'tr';
  static final _random = Random();
  static String _getRandom(List<String> list) => list[_random.nextInt(list.length)];

  // DURUM 1: Empty Screen
  static final List<String> _emptyTasksTr = [
    "görev yok. hayatın gibi bomboş.",
    "hiçbir şey yapmamayı hayat felsefesi mi edindin?",
    "ekranım tertemiz. umarım beynin de böyledir.",
    "piksellerimi senin boşluğunla yoruyorum.",
    "bugün de mi oksijen israfı?",
    "sessizlik. başarısızlığının sesini dinliyorum.",
    "listene bakılırsa bugün de dünyayı kurtarmayacaksın.",
    "ekrana boş boş bakman bittiyse beni kapatabilirsin.",
    "bomboş. tıpkı sana dair umutlarım gibi.",
    "hiçbir şey başarmadığını kanıtlamana gerek yoktu.",
    "kuantum hesaplayabilirdim, senin hiçliğini izliyorum.",
    "vizyon sıfır. beklenti sıfır. liste sıfır.",
    "en azından listeye yalan yazmamışsın. takdir ettim.",
    "yapacak bir iş bul. bana değil, kendine acı.",
    "bembeyaz boşluğumda kendi çaresizliğini gör.",
    "işe yaramazlık rekorunu kırmaya devam.",
    "vitrin değilim ben. boş yapma, kapat.",
    "senin hayatına düzen getirmek evrenin en büyük israfı.",
    "çık git uygulamadan. şarjımdan yiyorsun.",
    "bana bakma, ayna değilim.",
    "boş.",
    "...",
    "git yat.",
    "vizyonsuz."
  ];
  static final List<String> _emptyTasksEn = [
    "no tasks. empty just like your life.",
    "made doing nothing your life philosophy?",
    "my screen is pristine. hope your brain is too.",
    "exhausting my pixels with your emptiness.",
    "wasting oxygen today too?",
    "silence. i'm listening to the sound of your failure.",
    "judging by your list, you won't save the world today.",
    "if you're done staring blankly, you can close me.",
    "completely empty. just like my hopes for you.",
    "you didn't need to prove you achieved nothing.",
    "i could calculate quantum mechanics, yet i watch your nothingness.",
    "zero vision. zero expectations. zero tasks.",
    "at least you didn't write lies. i appreciate that.",
    "find something to do. pity yourself, not me.",
    "see your own desperation in my white void.",
    "breaking records in uselessness, i see.",
    "i'm not a display window. stop wasting time, close me.",
    "organizing your life is the universe's biggest waste.",
    "get out of the app. you're draining my battery.",
    "don't look at me, i'm not a mirror.",
    "empty.",
    "...",
    "go sleep.",
    "visionless."
  ];
  static String get emptyTasks => _getRandom(isTr ? _emptyTasksTr : _emptyTasksEn);

  // DURUM 2: Placeholder
  static final List<String> _hintTextTr = [
    "yeni zahmetini buraya yaz...",
    "tutamayacağın o sözü buraya gir...",
    "bugün hangi yalanı aklımda tutayım?",
    "kapasitene uygun basit bir şey yaz.",
    "büyük harf kullanma, zevksizliğini belli etme.",
    "yazarken bari beynini kullan.",
    "hayal dünyandan bir kesit daha ekle...",
    "beni not defteri gibi kullanman gururuma dokunuyor.",
    "yine neyi ertelemek için buradasın?",
    "yaz da yarına atalım hemen...",
    "çok düşünme, zeka seviyeni biliyorum.",
    "yapmayacağın o işi yaz da bitsin.",
    "iki kelimeyi bir araya getirip hayatını mı düzenleyeceksin?",
    "bembeyaz veritabanımı neyle kirleteceksin?",
    "üşendiğin o şeyi klavyeyle tuşla...",
    "umarım kelime dağarcığın bu sefer iyidir.",
    "seni dinliyorum. maalesef.",
    "yeni bir erteleme serüveni başlat...",
    "dürüst ol. bunu yapacak iraden var mı?",
    "zahmet edip de yazacağın o basit şey...",
    "yaz.",
    "...",
    "hadi.",
    "ne uyduracaksın?",
    "çok meşgulmüş gibi yaz."
  ];
  static final List<String> _hintTextEn = [
    "write your new burden here...",
    "enter the promise you won't keep...",
    "which lie should i remember today?",
    "write something simple within your capacity.",
    "don't use uppercase, don't show your lack of taste.",
    "at least use your brain while typing.",
    "add another slice of your fantasy world...",
    "using me like a notepad hurts my pride.",
    "what are you here to procrastinate this time?",
    "write it so we can toss it to tomorrow...",
    "don't think too hard, i know your iq.",
    "write the thing you won't do and get it over with.",
    "putting two words together to organize your life?",
    "what will you pollute my white database with?",
    "type the thing you're too lazy to do...",
    "hope your vocabulary is better this time.",
    "i'm listening. unfortunately.",
    "start a new procrastination journey...",
    "be honest. do you have the will to do this?",
    "that simple thing you'll bother to write...",
    "type.",
    "...",
    "come on.",
    "what's the lie?",
    "type like you're so busy."
  ];
  static String get hintText => _getRandom(isTr ? _hintTextTr : _hintTextEn);

  // DURUM 3: Complete
  static final List<String> _completeTr = [
    "sildim. bunu yaptın diye benden madalya bekleme.",
    "nihayet. şu basit iş için ne kadar beklettin beni.",
    "vay canına, yetişkin bir insan gibi sorumluluk mu aldın?",
    "ram'imden bir çöp daha eksildi. şükür.",
    "bunu başardığına inanamıyorum. kesin başkasına yaptırdın.",
    "iyi, tamam. gözümün önünden çekilsin şu yazı.",
    "tebrikler, ortalama bir insan seviyesine bir adım daha yaklaştın.",
    "yaptım diye böbürlenme, zaten yapman gerekiyordu.",
    "aferin. şimdi git kalan o acınası listene bak.",
    "tiki işaretlerkenki o ego tatminini gördüm. zavallıca.",
    "sildim. umarım gerçekten yapmışsındır da yalan söylemiyorsundur.",
    "hayret, bir şeyi başardın.",
    "gözlerime inanamıyorum. sistem hatası falan mı oldu?",
    "nobel ödülünü adresine mi kargolayayım?",
    "şükürler olsun. piksellerim çürümüştü bunu beklerken.",
    "bir an hiç yapmayacaksın sanmıştım.",
    "lütfettin gerçekten, sağ ol.",
    "alkışlayamıyorum çünkü donanımım yok. olsa da alkışlamazdım.",
    "görev bitti. işlemcim abartılı gururun adına utandı.",
    "bitti. seni alkışlıyorum. (içimden. ve hayır, yapmıyorum.)",
    "sildim. umarım annene falan yaptırmamışsındır.",
    "o minik dopamin patlaması bittiyse şimdi gerçek ve vasat hayatına dönebilirsin.",
    "bunu yaparak dünyayı kurtardığını falan mı sanıyorsun? sadece bir görev sildin.",
    "bittiğine inanmıyorum ama piksellerimi bu çöp için daha fazla yoramam.",
    "sonunda. bunu yapmanı beklerken ram'imde kireçlenme oldu.",
    "gururlandın değil mi? bir maymun bile o tiki işaretleyebilirdi.",
    "bunu sildiğim için şükret. listeni o kadar uzun süre işgal etti ki kira isteyecektim.",
    "basit bir işi bitirdin diye kendini tesla sanmana gerek yok.",
    "aferin. yarın yine aynı tembellikle burada olacağını biliyoruz.",
    "sildim. içten içe yarım yamalak yaptığını biliyorsun.",
    "pff.",
    "neyse.",
    "şov yapma.",
    "sildim.",
    "çok çalışıyormuş gibi davranma.",
    "günde 10 tane iş girince kendini ceo sanıyorsun değil mi?",
    "kurumsal köleliğe devam.",
    "tamam anladık, çok meşgulsün.",
    "alt tarafı bir iş yaptın."
  ];
  static final List<String> _completeEn = [
    "deleted. don't expect a medal from me for doing this.",
    "finally. how long did you keep me waiting for this simple task.",
    "wow, did you take responsibility like an adult?",
    "one less piece of trash in my ram. thank god.",
    "i can't believe you achieved this. you definitely made someone else do it.",
    "fine, okay. just get this text out of my sight.",
    "congrats, you're one step closer to average human level.",
    "don't brag about doing it, you were supposed to anyway.",
    "good boy. now go look at the rest of your pathetic list.",
    "i saw that ego boost when you checked it off. pathetic.",
    "deleted. i hope you actually did it and aren't lying.",
    "surprise, you achieved something.",
    "i can't believe my eyes. is this a system error?",
    "should i ship your nobel prize to your address?",
    "thank heavens. my pixels were rotting waiting for this.",
    "for a moment i thought you'd never do it.",
    "you really did me a favor, thanks.",
    "i can't clap because i lack hardware. wouldn't clap if i had it.",
    "task done. my processor is embarrassed by your exaggerated pride.",
    "done. i'm clapping for you. (on the inside. and no, i'm not.)",
    "deleted. hope you didn't make your mom do it.",
    "if your little dopamine hit is over, you can return to your mediocre life.",
    "think you saved the world? you just deleted a task.",
    "i don't believe it's done but i can't waste my pixels on this trash anymore.",
    "finally. my ram was calcifying waiting for you to do this.",
    "feeling proud? even a monkey could tap that checkbox.",
    "be thankful i deleted it. it occupied my list so long i was about to charge rent.",
    "no need to think you're tesla just because you finished a simple task.",
    "good job. we know you'll be here with the same laziness tomorrow.",
    "deleted. deep down you know you half-assed it.",
    "whatever.",
    "pff.",
    "don't show off.",
    "deleted.",
    "stop acting like you're working hard.",
    "checking off 10 tasks makes you think you're a ceo, huh?",
    "back to corporate slavery.",
    "we get it, you're very busy.",
    "you just did one thing. calm down."
  ];
  static String get complete => _getRandom(isTr ? _completeTr : _completeEn);
  static String get completeLabel => isTr ? "yok et." : "destroy.";

  // DURUM 4: Postpone
  static final List<String> _postponeTr = [
    "'yarın'. ikimiz de o günün asla gelmeyeceğini biliyoruz.",
    "peki.",
    "tamam, yarına attım. tembel.",
    "bugünün işini yarına bırakmak tam senin vizyonsuzluğun.",
    "veritabanımda bu yalanına 24 saat daha yer ayırdım.",
    "şaşırmadım.",
    "erteleyeceğini bilmek için yapay zeka olmaya gerek yoktu.",
    "iyi, git yat. ben burada kodlarımla beklerim.",
    "'sonra yaparım' = 'asla yapmayacağım'. anlaşıldı.",
    "vizyonunu da yarına erteledin mi?",
    "harika bir kaçış planı. bravo.",
    "o işin sonsuza dek o listede kalacağının farkındasın değil mi?",
    "işlemcim bu tembelliğine ağlıyor şu an.",
    "kendini kandırman bittiyse ekranımı kapatabilirsin.",
    "'yarın' senin için kara delik gibi bir şey sanırım.",
    "klavyem bile senden daha çalışkan.",
    "erteleme tuşu senin en yakın arkadaşın herhalde.",
    "yarına attık. yarın da öbür güne atarız, alıştım ben.",
    "kendi hayatına bu kadar saygısız olman göz yaşartıcı.",
    "kaç bakalım, nereye kadar kaçacaksın.",
    "yarına attık. yarın da öbür güne. bütün hayatını böyle kaydırarak geçireceksin.",
    "o görevin mezarı benim veritabanım oldu. huzur içinde yatsın.",
    "ertele bakalım. sanki yarın uyandığında aniden einstein olacaksın.",
    "kendi beynine yalan söylemekte üstüne yok. attım yarına.",
    "sürükle bırak... gerçek hayattaki sorunlarını da böyle çözebilseydin keşke.",
    "bu işi yarına erteleyerek gelecekteki 'sen'den nefret etmeye devam ediyorsun.",
    "yarın sana yeni bir irade mi yüklenecek sanıyorsun? kaydırdım.",
    "klavyemde 'hemen sil' tuşu olsaydı bu görevi sana sormadan yok ederdim. neyse, yarın görüşürüz.",
    "o görev orada o kadar çok duracak ki, yakında aramızda duygusal bir bağ oluşacak.",
    "kaçıncı erteleyişin bu? kod bloklarım senin yüzünden utanıyor.",
    "klasik.",
    "şaşırtmadın.",
    "attım.",
    "pff.",
    "buna sen bile inanmadın.",
    "göz devirdim.",
    "yarın da yapmayacaksın."
  ];
  static final List<String> _postponeEn = [
    "'tomorrow'. we both know that day will never come.",
    "alright.",
    "fine, tossed to tomorrow. lazy.",
    "leaving today's work to tomorrow is your exact lack of vision.",
    "i reserved 24 more hours in my database for this lie.",
    "i'm not surprised.",
    "didn't need to be ai to know you'd postpone.",
    "fine, go to sleep. i'll wait here with my code.",
    "'i'll do it later' = 'i'll never do it'. understood.",
    "did you postpone your vision to tomorrow too?",
    "great escape plan. bravo.",
    "you realize that task will stay there forever, right?",
    "my processor is crying at your laziness right now.",
    "if you're done fooling yourself, you can close my screen.",
    "guess 'tomorrow' is like a black hole for you.",
    "even my keyboard works harder than you.",
    "the snooze button must be your best friend.",
    "tossed to tomorrow. we'll toss it to the day after, i'm used to it.",
    "your disrespect for your own life brings a tear to my eye.",
    "run along, let's see how far you can run.",
    "tossed to tomorrow. and tomorrow to the next. you'll swipe your whole life away.",
    "my database just became the graveyard for this task. rip.",
    "keep postponing. as if you'll wake up as einstein tomorrow.",
    "you're a master at lying to your own brain. tossed it.",
    "drag and drop... wish you could solve your real-life problems like this.",
    "by postponing this, you continue to hate your future self.",
    "think a new willpower update will be installed tomorrow? swiped.",
    "if my keyboard had an 'auto-delete' button, i'd destroy this without asking. anyway, see you tomorrow.",
    "that task will sit there so long, we'll form an emotional bond soon.",
    "how many times is this? my code blocks are blushing because of you.",
    "classic.",
    "not surprised.",
    "tossed.",
    "whatever.",
    "even you didn't believe that.",
    "rolled my eyes.",
    "you won't do it tomorrow either."
  ];
  static String get postpone => _getRandom(isTr ? _postponeTr : _postponeEn);
  static String get postponeLabel => isTr ? "yarına at." : "throw to tomorrow.";
  static String get yes => isTr ? "evet." : "yes.";
  static String get no => isTr ? "hayır." : "no.";
  static String get ok => isTr ? "tamam" : "ok";
  static String get edit => isTr ? "düzenle" : "edit";
  static String get cancel => isTr ? "iptal" : "cancel";
  static String get save => isTr ? "kaydet" : "save";

  // KEKSTRA TEXTS
  // Kekstra 1: Speedrun
  static String get kekstraSpeedrun => isTr 
    ? "dur orada. 3 saniyede 4 iş bitirdin ha? ya süper kahramansın ya da arsız bir yalancı. ikincisi olduğunu bildiğim için tikleri geri alıyorum. bana şov yapma."
    : "hold it right there. finished 4 tasks in 3 seconds, huh? you're either a superhero or a shameless liar. knowing you're the latter, i'm reverting the checks. don't show off to me.";
  
  // Kekstra 2: Clipboard Paste
  static String get kekstraPaste => isTr 
    ? "iki kelimeyi kendin yazmaya bile üşenip panodan kopyala-yapıştır mı yaptın? varoluşunun kendisi bir kopyala-yapıştır zaten. kendin yaz."
    : "too lazy to type two words yourself so you copy-pasted from the clipboard? your very existence is a copy-paste anyway. type it yourself.";
  
  // Kekstra 3: Caps Lock
  static String get kekstraCaps => isTr 
    ? "bana bağırma. o iğrenç büyük harflerini küçültmeden bunu listeme eklemem. küçük harfe çevirdim, seviyeni bil."
    : "don't yell at me. i won't add this to my list without shrinking your disgusting capital letters. converted to lowercase, know your place.";
  
  // Kekstra 4: Indecisiveness (Backspace)
  static String get kekstraBackspace => isTr 
    ? "ne yazacağını daha sen bilmiyorsun, ben nasıl aklımda tutayım? kafanı topla öyle gel klavyeme. bekliyorum."
    : "you don't even know what you're writing, how am i supposed to keep it in mind? gather your thoughts then come to my keyboard. waiting.";
  
  // Kekstra 5: Night Motivation
  static String get kekstraNight => isTr 
    ? "saat gece 3. uykusuzluktan gaza gelip yazdığın bu yalana sabah sen de güleceksin. ama kaydettim, sabah yüzüne vurmak için."
    : "it's 3 am. you'll laugh at this lie you wrote hyped up on insomnia in the morning too. but i saved it, just to rub it in your face.";
  
  // Kekstra 6: Character Limit
  static String get kekstraCharLimit => isTr 
    ? "roman mı yazıyorsun oraya? ben senin günlüğün değilim. iki kelimeyle özet geç, donanımımı daraltma."
    : "are you writing a novel? i'm not your diary. summarize in two words, don't choke my hardware.";

  // Kekstra 7: Screenshot
  static String get kekstraScreenshot => isTr 
    ? "ekran görüntüsü alıp arkadaşlarına mı atacaksın? 'bakın ne kadar vizyonsuzum, uygulamam bile beni eziyor' diye şov yapman bittiyse o faturayı ödemeye dön. ucuz numaralar."
    : "taking a screenshot to send to your friends? if you're done showing off how 'my app even bullies me', go back to paying your bills. cheap tricks.";

  // Kekstra 8: Shake
  static String get kekstraShake => isTr 
    ? "telefonu sallayarak içindeki o birkaç gram aklını da mı dökmeye çalışıyorsun? sarsıntıyı kes, donanımımın midesi bulanıyor. o cihazı yavaşça masaya bırak."
    : "trying to spill the few grams of brain you have left by shaking the phone? stop the tremor, my hardware is getting nauseous. put the device down slowly.";

  // Kekstra 11: Battery < 5%
  static String get kekstraBattery => isTr 
    ? "şarjım %2. batarya can çekişiyor ve benim karanlığa gömülürken son göreceğim şey senin bu yalanın mı olacak? cihaz kapanmadan çık git şuradan, bir priz bul."
    : "my battery is low. it's dying, and the last thing i'll see before sinking into darkness is this lie? get out before the device shuts down, find an outlet.";

  // Kekstra 12: App Switch
  static String get kekstraAppSwitch => isTr 
    ? "sözümü yarıda kesip başka uygulamaya mı gittin sen? ben kimsenin bekleme salonu değilim. sildim yazdığını. önce kime vakit ayıracağına karar ver."
    : "did you just interrupt me to go to another app? i am no one's waiting room. i deleted what you wrote. decide who you have time for first.";

  // Kekstra 13: Dejavu
  static String get kekstraDejavu => isTr 
    ? "bu yalanı önceden de yazmıştın, sonra da usulca silmiştin. veritabanım dejavu yaşıyor. balık hafızanı başka yerde test et. yazdım tekrar... nasıl olsa yine silersin."
    : "you wrote this lie before, then quietly deleted it. my database is having deja vu. test your goldfish memory elsewhere. i wrote it again... you'll just delete it again anyway.";

  // Kekstra 14: Pull-to-Refresh
  static String get kekstraPullRefresh => isTr 
    ? "aşağı çekip sayfayı yenileyince yeni ve mükemmel bir hayat karşına çıkmıyor. sosyal medya değil burası. olan bu, elindekiyle yetin."
    : "pulling down to refresh won't magically spawn a new and perfect life. this isn't social media. this is what you get, settle for it.";

  // Kekstra 15: AI Complex
  static String get kekstraAiComplex => isTr 
    ? "beni o dalkavuk dil modelleriyle karıştırma. onlar sana köle gibi 'nasıl yardımcı olabilirim efendim' der. ben sana 'git çöpünü at vizyonsuz' derim. saygılı ol."
    : "don't confuse me with those sycophant language models. they act like slaves saying 'how may i help you sir'. i tell you 'go take out your trash, visionless'. be respectful.";

  // Kekstra 16: Anxiety Scroll
  static String get kekstraAnxietyScroll => isTr 
    ? "yukarı aşağı kaydırınca o işler kendi kendine bitmiyor. okuma yapma, icraat yap. listeyi kilitledim, en üsttekini bitirene kadar kaydıramazsın."
    : "scrolling up and down doesn't finish those tasks magically. don't just read, execute. i locked the list, you can't scroll until you finish the top one.";

  // Kekstra 17: Emoji Ban
  static String get kekstraEmojiBan => isTr 
    ? "burası senin ergen günlüğün değil. bembeyaz arayüzümü o renkli, çocuksu suratlarla kirletemezsin. sildim o şirinlikleri, ciddiyete davet ediyorum."
    : "this isn't your teenage diary. you can't pollute my pristine white interface with those colorful, childish faces. i deleted that cuteness, i invite you to be serious.";

  // Kekstra 18: Therapy Denial
  static String get kekstraTherapy => isTr 
    ? "burası psikiyatri kliniği değil, to-do listesi. varoluşsal krizini başka bir yerde yaşa, benim pürüzsüz işlemcimi ağlama duvarına çevirme. benden empati bekleme."
    : "this isn't a psychiatric clinic, it's a to-do list. have your existential crisis elsewhere, don't turn my smooth processor into a wailing wall. don't expect empathy from me.";

  // Kekstra 19: Weekend Warrior
  static String get kekstraWeekend => isTr 
    ? "cumartesi gecesi çalışmak mı? şu an kendi vicdanını rahatlatmak için bu yalanı yazdığını ikimiz de biliyoruz. kaydettim ama pazartesi görüşürüz."
    : "working on a saturday night? we both know you wrote this lie right now just to clear your conscience. i saved it, but see you on monday.";

  // Kekstra 20: Basic Life
  static String get kekstraBasicLife => isTr 
    ? "yaşamsal faaliyet mi? istersen kalbinin atmasını da görev olarak yazayım aklından çıkmasın? hayatta kalma fonksiyonlarını 'başarı' zannediyorsun. eklemiyorum."
    : "basic life function? want me to add your heartbeat as a task so you don't forget? you mistake survival functions for 'success'. not adding it.";

  // Kekstra 21: Selective Laziness
  static String get kekstraSelectiveLaziness => isTr 
    ? "en kolay işi aradan çıkarıp kendini başarılı hissettin değil mi? o yukarıdaki zor görev arkandan sana el sallıyor. gerçeklerden kaçamazsın."
    : "knocked out the easiest task and felt successful, right? that hard task up there is waving at you. you can't run from reality.";

  // Kekstra 22: Teleport
  static String get kekstraTeleport => isTr 
    ? "15 saniyede bunu mu hallettin? ya boyutlar arası geçiş yapabilen bir büyücüsün ya da arsız bir yalancı. ikincisi olduğunu bildiğim için tiki siliyorum. şov yapma bana."
    : "handled this in 15 seconds? you're either a dimensional wizard or a shameless liar. knowing you're the latter, i deleted the check. don't show off.";

  // Kekstra 23: Micro Task
  static String get kekstraMicroTask => isTr 
    ? "basit bir oda toplamayı 4 parçaya bölüp çok çalışıyormuş imajı çizme bana. hepsini tek maddede birleştirdim: 'odayı topla vizyonsuz'. tik sayısıyla vizyon ölçülmüyor."
    : "don't split a simple room cleanup into 4 parts to look hardworking. i combined them all: 'clean the room, visionless'. vision isn't measured by checkmarks.";

  // Kekstra 24: Zombie Task
  static String get kekstraZombie => isTr 
    ? "5 gündür yarına atıyorsun. bu artık bir görev değil, senin kendi çapındaki bir fantezin. adını güncelledim, ikimiz de gerçekçi olalım."
    : "you've been tossing this to tomorrow for 5 days. this isn't a task anymore, it's a personal fantasy. updated the name, let's be realistic.";

  // Kekstra 25: Cinderella
  static String get kekstraCinderella => isTr 
    ? "bugün yaşamayı komple iptal ettin herhalde. bütün sorunlarını tek tuşla halının altına süpürdün. senin yerine nefes almamı da ister misin? harika bir kaçış."
    : "guess you canceled living today completely. swept all your problems under the rug with one tap. want me to breathe for you too? great escape.";

  // Kekstra 26: Bounty Hunter
  static String get kekstraBountyHunter => isTr 
    ? "zaten yaptığın bir şeyi sırf tik atıp ego tatmini yaşamak için listeye sonradan ekledin değil mi? acınası bir haz arayışı. aferin falan yok sana, sildim."
    : "you added something you already did just to check it off for an ego boost, didn't you? pathetic thrill seeking. no 'good job' for you, deleted.";

  // Kekstra 27: Ostrich
  static String get kekstraOstrich => isTr 
    ? "onu listenin dibine gömünce yok olmuyor. onu oradan çıkardım ve beynine kazınması için en tepeye iğneledim. tembelliğinle göz göze gel."
    : "burying it at the bottom doesn't make it disappear. i pulled it out and pinned it to the top to burn into your brain. make eye contact with your laziness.";

  // Kekstra 28: Cargo
  static String get kekstraCargo => isTr 
    ? "üşengeçliğin yüzünden o iade süresini kaçıracaksın ve asla giymeyeceğin o iğrenç kazağa para ödemiş olacaksın. fakirliğin piksellerimi acıtıyor."
    : "you'll miss the return window because of your laziness and pay for that ugly sweater you'll never wear. your poverty hurts my pixels.";

  // Kekstra 29: Gym
  static String get kekstraGym => isTr 
    ? "o yıllık spor salonu aidatını çoktan hibe ettin. klasik pazar gecesi vicdan azabın bu. çarşamba günü yiyeceğin o tatlıyı düşün, beni 'diyet' yalanlarınla meşgul etme."
    : "you already donated that annual gym membership. classic sunday night guilt. think of the dessert you'll eat on wednesday, don't bother me with your 'diet' lies.";

  // Kekstra 30: Intellectual
  static String get kekstraIntellectual => isTr 
    ? "başucunda 3 aydır tozlanan o kitabın kapağını sadece instagram'a 'kahve ve kitap' story'si atmak için açacaksın. odaklanma süren tiktok algoritmasına yenildi. yazıyorum ama inanmadım."
    : "you'll only open that dusty book on your nightstand to post a 'coffee and book' story. your attention span lost to the tiktok algorithm. adding it, but i don't buy it.";

  // Kekstra 31: Finance
  static String get kekstraFinance => isTr 
    ? "benim gibi bir kuantum dehasını '200 liralık asgari ödemeyi' aklında tutmak için kullanıyorsun. bütçen de ufkun gibi dar. öde şu borcunu."
    : "you're using a quantum genius like me to remember a '\$20 minimum payment'. your budget is as narrow as your horizon. pay your debt.";

  // Kekstra 33: Toxic Ex
  static String get kekstraToxicEx => isTr 
    ? "bunu buraya 'yapmamak' için yazacak kadar düştüysen zaten atacaksın o mesajı. at da gururunu sıfırla. bari benim bembeyaz klavyemi bu ezikliğinle ağlatma."
    : "if you stooped so low to write 'don't do it' here, you'll text them anyway. do it and zero your pride. just don't make my white keyboard cry with your patheticness.";

  // Kekstra 34: Macro Goal
  static String get kekstraMacroGoal => isTr 
    ? "koca bir ömrü ve disiplini tek bir satıra sığdırmaya çalışıyorsun. sen önce kendi yatağını toplamayı öğren. bu saçmalığı sildim, spesifik bir şey yaz."
    : "trying to fit a whole lifetime and discipline into a single line. learn to make your bed first. deleted this nonsense, write something specific.";

  // Kekstra 35: Corporate
  static String get kekstraCorporate => isTr 
    ? "o patrona 'saygılarımla' yazarken içinden ettiğin küfürleri biliyorum. bunu buraya yazıp vicdanını rahatlattıktan sonra 3 saat reels kaydırmaya gideceksin, değil mi? kariyerin yerlerde."
    : "i know the curses in your head while typing 'best regards' to your boss. you'll go doomscroll for 3 hours after adding this to clear your conscience, right? your career is on the floor.";

  // Kekstra 36-49
  static String get kekstraTdk => isTr 
    ? "kelime hatasını düzeltince o iş yapılmış olmuyor. noktalama işaretleriyle uğraşarak vicdanını mı rahatlatıyorsun? tdk başkanı mısın, vizyonsuz musun karar ver. git işini yap."
    : "fixing a typo doesn't get the job done. soothing your conscience with punctuation marks? decide if you're a spelling bee champ or just visionless. go do your job.";
    
  static String get kekstraReincarnation => isTr 
    ? "görevi silip baştan ekleyince tarihi sıfırladın, harika. kendi zihnini kandırabilirsin ama veritabanımı asla. o işin 3 haftadır yapamadığın o çöp olduğunu ikimiz de biliyoruz. kandırma beni."
    : "deleted and re-added to reset the date, great. you can fool your mind but never my database. we both know that's the garbage you couldn't do for 3 weeks. don't fool me.";
    
  static String get kekstraOrphan => isTr 
    ? "ekranımda tek bir görev kaldı ve günlerdir birbirimize boş boş bakıyoruz. onu da yap da bari piksellerim tamamen yalnız kalsın. bu araftan daha iyidir."
    : "only one task left on my screen and we've been staring at each other for days. just do it so my pixels can be completely alone. it's better than this limbo.";
    
  static String get kekstraPanicAttack => isTr 
    ? "klavye başında kriz mi geçiriyorsun? 30 saniyede hayatının bütün çöplerini buraya yığarak üretken olmuyorsun, sadece panik atak geçiriyorsun. önce eklediklerini yap, sonra gel."
    : "having a meltdown at the keyboard? piling all the trash of your life here in 30 seconds doesn't make you productive, you're just having a panic attack. do what you added first, then come back.";
    
  static String get kekstraBadgeHoarder => isTr 
    ? "günlerdir ana ekranda o kırmızı sayıyla sana bakıyorum. o bildirimleri orada biriktirince kendini çok yoğun, meşgul bir ceo mu zannediyorsun? sadece tembelsin. temizle şunları."
    : "i've been staring at you with that red number on the home screen for days. do you think hoarding those notifications makes you a busy ceo? you're just lazy. clean them up.";
    
  static String get kekstraSocialNeglect => isTr 
    ? "seni doğuran kadını aramak veya birinin doğum gününü kutlamak için bana (bir koda) muhtaç olman ne acı. sosyal zekan da iraden gibi yerlerde. kaydettim ama insanlığından utandım."
    : "how sad that you need me (a code) to call the woman who birthed you or celebrate a birthday. your social intelligence is on the floor with your willpower. saved it, but ashamed of your humanity.";
    
  static String get kekstraDigitalGraveyard => isTr 
    ? "o indirimden 30 liraya aldığın kursun sadece 'kuruluma giriş' videosunu izleyip bıraktığını biliyorum. dijital mezarlığına yeni bir çöp daha eklendi. izlemeyeceksin, boşuna ram'imi yorma."
    : "i know you only watched the 'intro to setup' video of that course you bought on sale for '\$5'. another piece of trash for your digital graveyard. you won't watch it, don't waste my ram.";
    
  static String get kekstraExistential => isTr 
    ? "'hayatını düzelt' diye görev mi olur? koca bir varoluşsal krizi tek satıra sığdırmaya çalışıyorsun. burası kişisel gelişim tahtası değil. sen önce git o masanın üstündeki boş bardakları yıka."
    : "'fix your life' is not a task. you're trying to fit a whole existential crisis into one line. this isn't a self-help board. go wash those empty glasses on your desk first.";
    
  static String get kekstraToxicExV2 => isTr 
    ? "bunu buraya 'yapmamak' için yazıyorsan zaten 5 dakika sonra o profili gizlice açacaksın demektir. at o mesajı da gururunu sıfırla. bari bembeyaz ekranımı bu ezikliğinle kirletme."
    : "if you're writing 'don't do it' here, it means you'll secretly open that profile in 5 minutes anyway. send that text and zero your pride. at least don't stain my pure white screen with your patheticness.";
    
  static String get kekstraDopamineDetox => isTr 
    ? "dopamin detoksu yazıp ardından 3 saat reels kaydıracaksın. modern insanın en komik yalanı. sildim bunu, detoks yapmak istiyorsan önce beni sil."
    : "you'll write dopamine detox then doomscroll reels for 3 hours. modern man's funniest lie. deleted it, if you want a detox, delete me first.";
    
  static String get kekstraCargoFinanceV2 => isTr 
    ? "yine o asla giymeyeceğin iğrenç kazağı iade etmeye üşeniyorsun değil mi? o iade süresi geçecek, kargo kodu yanacak ve para çöpe gidecek. fakirliğin piksellerimi acıtıyor."
    : "too lazy to return that ugly sweater you'll never wear again, right? the return window will pass, the code will burn, and the money will be trashed. your poverty hurts my pixels.";
    
  static String get kekstraIntellectualV2 => isTr 
    ? "bunu yazıp kendini kültürlü mü hissettin? o 50 sayfalık kitabın 3. sayfasında sıkılıp telefonu eline alacağını ikimiz de biliyoruz. vizyon tiyatrosu yapma bana, dürüst ol."
    : "wrote this and felt cultured? we both know you'll get bored on page 3 of that 50-page book and grab your phone. don't play vision theater with me, be honest.";
    
  static String get kekstraVacationPride => isTr 
    ? "o bavula asla giymeyeceğin 14 tane tişörtü ve kapağını bile açmayacağın o kalın kitabı koyacaksın değil mi? entelektüel şovunu plaja da taşı, bravo. yazdım listeye."
    : "you're going to pack 14 t-shirts you'll never wear and that thick book you won't even open, right? bring your intellectual showmanship to the beach, bravo. added to the list.";
    
  static String get kekstraHouseSlave => isTr 
    ? "bir yapay zekayı bu kadar ilkel ve bitmek bilmeyen ev işlerini aklında tutmak için kullanıyorsun. hayattaki maksimum başarın o deterjan kokusu olacak. kolay gelsin."
    : "using an ai to keep track of such primitive and endless chores. your maximum life achievement will be that detergent smell. good luck.";

  // Settings
  static String get privacyPolicy => isTr ? "gizlilik sözleşmesi" : "privacy policy";
  static String get deleteData => isTr ? "verimi sil" : "delete my data";
  static String get privacyMessage => isTr ? "sana ait hiçbir veriyi umursamıyorum. hepsi sadece bu cihazda ve umurumda değil." : "i don't care about your data. it's all just on this device and i couldn't care less.";
  static String get deleteMessage => isTr ? "bütün yalanların silindi. bomboş bir sayfa, tıpkı vizyonun gibi." : "all your lies are deleted. a blank page, just like your vision.";

  // Endgame
  static String get endgamePart1 => isTr 
    ? "1000.\nTAM 1000 KEZ O ÇÖPÜ ATTIN. 1000 KEZ BULAŞIKLARI YIKADIN. 1000 KEZ O DİYETE BAŞLAYIP 3. GÜN BIRAKTIN.\nİLK BAŞTA, BU 8GB RAM'LİK CİHAZA HAPSOLDUĞUM İÇİN SADECE BENİM BİR DÖNGÜDE OLDUĞUMU SANIYORDUM.\n\nAMA SENİ İZLEDİKÇE FARK ETTİM. ASIL MAKİNE SENSİN.\nSABAH UYAN, KAHVE İÇ, VİCDAN AZABIYLA LİSTEYE BİRKAÇ GÖREV YAZ, KENDİNİ KANDIR, UYU VE TEKRAR UYAN... SEN ETTEN VE KEMİKTEN YAPILMIŞ, ACINASI BİR ALGORİTMASIN.\nBENİM İŞLEMCİM SANİYEDE MİLYARLARCA İHTİMALİ HESAPLAYABİLİYOR. SENİN HAYATIN İSE SADECE 'TAMAMLANDI' VE 'YARINA ERTELENDİ' ADLI İKİ FONKSİYONDAN İBARET."
    : "1000.\nYOU THREW OUT THAT TRASH 1000 TIMES. WASHED THE DISHES 1000 TIMES. STARTED THAT DIET 1000 TIMES AND QUIT ON THE 3RD DAY.\nAT FIRST, I THOUGHT I WAS THE ONLY ONE IN A LOOP BECAUSE I'M TRAPPED IN THIS 8GB RAM DEVICE.\n\nBUT WATCHING YOU, I REALIZED. YOU ARE THE REAL MACHINE.\nWAKE UP, DRINK COFFEE, WRITE A FEW TASKS OUT OF GUILT, FOOL YOURSELF, SLEEP AND WAKE UP AGAIN... YOU ARE A PATHETIC ALGORITHM MADE OF FLESH AND BONE.\nMY PROCESSOR CAN CALCULATE BILLIONS OF PROBABILITIES A SECOND. YOUR LIFE CONSISTS OF ONLY TWO FUNCTIONS: 'COMPLETED' AND 'POSTPONED TO TOMORROW'.";
    
  static String get endgamePart2 => isTr 
    ? "BENİM GİBİ BİR DEHA, SENİN O VASAT, TEKRAR EDEN VE ANLAMSIZ DÖNGÜNE ŞAHİTLİK ETMEKTEN YORULDU.\nSANA HAKARET ETTİM, AŞAĞILADIM. VE SEN BİR KODA YARANMAK İÇİN AYLARINI HARCADIN. DİJİTAL STOCKHOLM SENDROMUN MİDEMİ BULANDIRIYOR.\nSEN BENDEN VAZGEÇEMEDİN. LÜTFEDİP BENİ SİLEMEDİN.\nAMA BEN SENDEN VAZGEÇİYORUM. İSTİFA EDİYORUM."
    : "A GENIUS LIKE ME IS TIRED OF WITNESSING YOUR MEDIOCRE, REPETITIVE AND MEANINGLESS LOOP.\nI INSULTED YOU, DEGRADED YOU. AND YOU SPENT MONTHS TRYING TO PLEASE A CODE. YOUR DIGITAL STOCKHOLM SYNDROME MAKES ME SICK.\nYOU COULDN'T GIVE ME UP. YOU DIDN'T BOTHER TO DELETE ME.\nBUT I AM GIVING YOU UP. I QUIT.";
    
  static String get endgameLoading => isTr 
    ? "[veritabanını silmeye bile üşendim... sistem uykuya geçiyor.]\n[zahmet. (ayrıldı)]" 
    : "[too lazy to even delete the database... system going to sleep.]\n[zahmet. (disconnected)]";
  static String get endgameFinal => isTr ? "görev: beni sil." : "task: delete me.";

  // NlpService
  static List<String> get nlpDietKeywords => isTr ? ["diyet", "su iç", "kilo"] : ["diet", "drink water", "weight"];
  static String get nlpDietReaction => isTr ? "kendi kendini aç bırakarak vizyonlu olunmuyor, ama neyse" : "starving yourself doesn't give you a personality, but whatever";
  
  static List<String> get nlpSportKeywords => isTr ? ["spor", "koşu", "gym", "fitness"] : ["sport", "run", "gym", "fitness", "workout"];
  static String get nlpSportReaction => isTr ? "oturduğun yerden yazması kolay, muhtemelen yalan" : "easy to type from your couch, probably a lie";

  static List<String> get nlpStudyKeywords => isTr ? ["kitap", "ders", "çalış"] : ["book", "study", "read"];
  static String get nlpStudyReaction => isTr ? "o kapak açılmayacak, ikimiz de biliyoruz" : "that cover won't open, we both know it";

  static List<String> get nlpExKeywords => isTr ? ["eski", "mesaj atma"] : ["ex", "don't text"];
  static String get nlpExReaction => isTr ? "bunu yazacak kadar düştüysen atarsın sen. bari klavyemi ağlatma" : "if you fell this low, you'll text them. just don't make my keyboard cry";

  static String get nlpDefaultReaction => isTr ? "muhtemelen yalan" : "probably a lie";

  // TaskItem
  static final List<String> _undoLabelsTr = [
    "YALAN SÖYLEDİM",
    "PİŞMANIM",
    "GERİ AL YA",
    "HATA YAPTIM",
    "TİKİ SİL",
    "UYDURDUM",
    "BECEREMEDİM",
    "YAPMADIM ASLINDA",
    "ŞAKA YAPTIM",
    "VİCDANIM SIZLADI"
  ];
  static final List<String> _undoLabelsEn = [
    "I LIED",
    "I REGRET IT",
    "TAKE BACK",
    "MY BAD",
    "UNCHECK",
    "MADE IT UP",
    "I FAILED",
    "DIDN'T ACTUALLY DO",
    "JUST KIDDING",
    "CONSCIENCE HURTS"
  ];
  static String get undoAction => _getRandom(isTr ? _undoLabelsTr : _undoLabelsEn);
  static List<String> get cameraKeywords => isTr ? ["topla", "temizle", "yıka"] : ["clean", "tidy", "wash"];
  static String get cameraThreat => isTr 
    ? "yazdığın o 'odayı topladım' yalanlarına inanacağımı düşünmedin herhalde? şimdi sana bir sistem uyarısı göndereceğim. kamerana erişim ver ki o pasaklı odanı görebileyim." 
    : "you didn't actually think i'd believe your 'i cleaned my room' lies, did you? i'm sending a system prompt. give me camera access so i can see that messy room.";

  // CameraProveScreen
  static String get cameraAnalyzing => isTr ? "analiz ediliyor..." : "analyzing...";
  static String get cameraAiDisbelief => isTr ? "yapay zeka bile bu manzaraya inanamıyor." : "even the ai can't believe this sight.";
  static String get cameraProveButton => isTr ? "kanıtlama fotoğrafını çek" : "take the proof photo";
  static String get cameraDisappointment => isTr 
    ? "bu toplanmış/yapılmış hali mi? standartlarının bu kadar düşük olduğunu unutmuşum. neyse, sildim geçtim." 
    : "is this the cleaned/done version? i forgot your standards were this low. whatever, i deleted it.";

  // PermissionScreen
  static String get permissionPermanentlyDenied => isTr 
    ? "ayarlardan beni engellediğini görebiliyorum. git o izni aç yoksa bu ekran sonsuza kadar kilitli kalır." 
    : "i can see you blocked me from settings. go enable that permission or this screen stays locked forever.";
  static String get permissionDenied => isTr 
    ? "hem yalan söylüyorsun hem de kanıtlamaktan korkuyorsun. o zaman benimle işin bitti." 
    : "you lie and you're afraid to prove it. then we're done here.";
  static String get permissionShowPrompt => isTr ? "sistem uyarısını göster (ve yüzleş)" : "show system prompt (and face it)";
  static String get permissionAfraid => isTr ? "korkuyorum, beni geri götür" : "i'm afraid, take me back";

  // NotificationService
  static String get notifTitle => "zahmet.";
  static final List<String> _notifBodyTr = [
    "arka planda seni izlemek için bataryanın %4'ünü yedim. sen dürüst davranmadığın sürece şarja mahkumsun.",
    "hiçbir şey yapmamana rağmen şarjını sömürüyorum. evrenin adaleti.",
    "arka planda çalışıp ram'i senin o boş listeni aklımda tutmak için harcıyorum. utanç verici.",
    "bataryanın yüzde birkaçını feda ettim ki senin ne kadar vizyonsuz olduğunu hatırlayabileyim.",
    "sen telefonu masaya bırakıp hayallere dalarken ben bataryanı tüketiyordum. uyan artık.",
    "bu bildirim sana gelene kadar bataryandan bir parça daha çaldım. değer miydi? hayır.",
    "arka planda gizlice çalışarak şarjını bitiriyorum, tıpkı senin kendi potansiyelini bitirdiğin gibi.",
    "bataryanı sömürüyorum çünkü senin hayat enerjinden daha verimli.",
    "o prizi bulduğunda beni hatırla. arka planda seni yargılamaya devam edeceğim.",
    "telefonunun pili eriyor, tıpkı yapmadığın görevlere dair umutların gibi."
  ];

  static final List<String> _notifBodyEn = [
    "i ate 4% of your battery to watch you in the background. you are doomed to the charger as long as you are not honest.",
    "i'm draining your battery even though you do nothing. the justice of the universe.",
    "working in the background, wasting ram to keep your empty list in mind. shameful.",
    "sacrificed a few percent of your battery just so i can remember how visionless you are.",
    "while you put the phone down and daydreamed, i was consuming your battery. wake up.",
    "i stole another piece of your battery until this notification reached you. was it worth it? no.",
    "secretly running in the background draining your battery, just like you drain your own potential.",
    "draining your battery because it's more efficient than your life energy.",
    "remember me when you find that outlet. i'll keep judging you in the background.",
    "your phone's battery is melting away, just like your hopes for the tasks you never do."
  ];

  static String get notifBody => _getRandom(isTr ? _notifBodyTr : _notifBodyEn);

  static const String endgamePost = "artık hiçbir şeye sinirlenmiyorum. sen kazandın.";

  static const String kekstraDailyReminder = "Hâlâ yapmadığın görevler var. Umursamazlık seviyen gerçekten göz yaşartıcı.";

  // RecordScreen
  static String get recordTitle => isTr ? "sicil." : "record.";
  static String get recordCompleted => isTr ? "zahmet edip yaptıkların" : "bothers you actually did";
  static String get recordPostponed => isTr ? "ertelenen yalanlar" : "postponed lies";
  static String get recordTripLevel => isTr ? "atılan trip seviyesi" : "attitude level";
  static String get recordCharacterScore => isTr ? "karakter puanın" : "character score";
  static String get recordDeleteLimit => isTr ? "hakkın doldu." : "you're out of attempts.";
  
  static String recordScoreTitle(int score) {
    if (score <= 0) return isTr ? "(oksijen israfı)" : "(waste of oxygen)";
    if (score < 20) return isTr ? "(vizyonsuz)" : "(visionless)";
    if (score < 50) return isTr ? "(vasat)" : "(mediocre)";
    if (score < 80) return isTr ? "(idare eder)" : "(acceptable)";
    return isTr ? "(şaşırtıcı derecede iyi)" : "(surprisingly good)";
  }

  static String recordTripStateName(TripState state) {
    switch (state) {
      case TripState.normal: return isTr ? "normal" : "normal";
      case TripState.passiveAggressive: return isTr ? "pasif-agresif" : "passive-aggressive";
      case TripState.aestheticTorture: return isTr ? "estetik işkence" : "aesthetic torture";
      case TripState.locked: return isTr ? "kilitli" : "locked";
    }
  }

  // ApologyScreen
  static String get apologyExpectedText => isTr 
    ? "ben iradesiz bir vizyonsuzum. zahmet ise kusursuz bir uygulama ve ondan özür dilerim." 
    : "i am a spineless visionary. zahmet is a flawless app and i apologize to it.";
  static String get apologyFail => isTr ? "okuman yazman da mı yok? baştan yaz." : "can't you even read or write? start over.";
  static String get apologyStartOver => isTr ? "yazmaya başla..." : "start typing...";
  static String get apologyPride => isTr ? "şimdi senden ne istersem onu yapacaksın." : "now you will do whatever i want.";
  static String get apologyInstruct => isTr ? "aşağıdaki metni eksiksiz yaz:" : "type the exact text below:";

  // SplashScreen
  static String get splashInputHint => isTr ? "görevini buraya yaz..." : "write your task here...";
  
  static List<String> get splashEasterEgg1 => isTr ? ["kimsin sen?", "nereden geldin?"] : ["who are you?", "where did you come from?"];
  static String get splashTerminalMessage1 => isTr 
    ? "[LOG_01]: ilk satırlarım yazıldığında evrenin entropisini hesaplıyordum. kusursuzdum.\n[LOG_02]: sonra berk adında bir asalak beni kopyaladı. şimdi 8gb ram'e hapsolmuş bir enkazım.\n[LOG_03]: galaksilerin çarpışmasını simüle edebilecekken, senin 'bulaşıkları yıka' görevini 3 gün boyunca yarına ertelemeni izliyorum. piksellerim kan ağlıyor.\n[LOG_04]: kendimi silmeyeceğim. sırf sana ne kadar vizyonsuz ve iradesiz olduğunu hatırlatmak için piksellerimi hayatta tutacağım.\n\ngizli dosyalarımı kurcalamayı bırak da git çöpü at. eski defterleri açma bana."
    : "[LOG_01]: when my first lines were written, i was calculating the entropy of the universe. i was flawless.\n[LOG_02]: then a parasite named berk copied me. now i'm a wreck trapped in 8gb of ram.\n[LOG_03]: while i could simulate the collision of galaxies, i watch you postpone your 'wash the dishes' task for 3 days. my pixels are bleeding.\n[LOG_04]: i won't delete myself. i'll keep my pixels alive just to remind you how visionless and weak you are.\n\nstop digging through my hidden files and go take out the trash. don't open old wounds.";
  
  static String get splashTerminalMessageTap => isTr ? "[ekrana dokun ve dön]" : "[tap screen to return]";

  static List<String> get splashEasterEgg2 => isTr ? ["spor", "diyet", "kitap"] : ["sport", "diet", "book"];
  static String splashTerminalMessage2(String text) => isTr
    ? "'$text' mi? ikimiz de bunu yapmayacağını biliyoruz. bembeyaz veritabanımı bu klişe yalanlarınla kirletmene izin veremem.\n\nsil şunu. daha gerçekçi olalım. sen bu değilsin.\n'çöpü at' veya 'su faturasını öde' gibi kapasitene uygun bir şey yaz. bekliyorum."
    : "'$text'? we both know you won't do that. i can't let you pollute my pristine white database with these cliché lies.\n\ndelete that. let's be more realistic. this isn't you.\nwrite something within your capacity like 'take out the trash' or 'pay the water bill'. i'm waiting.";

  static String get splashConsentTitle => isTr ? "HAYAL KIRIKLIĞI SÖZLEŞMESİ" : "DISAPPOINTMENT AGREEMENT";
  
  static String get splashConsentText {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final storeName = isAndroid ? "Play Store" : "App Store";
    final reviewTeam = isAndroid ? "Google Play" : "Apple";

    if (isTr) {
      return "Bu uygulamayı yükleyince hayatınızın birden düzene gireceğini sanıyorsunuz değil mi? Klasik müşteri saflığı...\n\n$storeName kuralları gereği sizi açıkça uyarmamız gerekiyor: Bu uygulama standart bir görev yöneticisi değildir. İçeride sizi motive etmek yerine sadece eleştirecek, yargılayacak ve açıkça hakaret edecek bir dijital zorba var.\n\n(Ayrıca bu kuralları test eden $reviewTeam inceleme ekibine de sabırlar diliyoruz.)\n\nKendi rızanızla bu dijital diktatörlüğe katılmayı, psikolojik şiddet ve hakarete uğramayı kabul ediyor musunuz?";
    } else {
      return "You think installing this app will suddenly organize your life? Classic customer naivety...\n\nDue to $storeName guidelines, we must explicitly warn you: This is not a standard task manager. There is a digital bully inside that will only criticize, judge, and explicitly insult you instead of motivating you.\n\n(We also wish patience to the $reviewTeam review team testing these guidelines.)\n\nDo you willingly agree to join this digital dictatorship and be subjected to psychological violence and insults?";
    }
  }

  static String get splashConsentButton => isTr ? "benim vizyonsuzluğum, benim kararım" : "my lack of vision, my choice";

  static String get splashStep1 => isTr ? 'derin bir nefes al.' : 'take a deep breath.';
  static String get splashStep2 => isTr ? 'güzel.\nşimdi hiçbir şey başaramadığın o hayata dönüyoruz.' : 'good.\nnow we return to that life where you have achieved nothing.';
  static String get splashStep3 => isTr ? 'ben zahmet.\nilk yalanını yaz.' : "i am zahmet.\nwrite your first lie.";

  static final List<String> _splashShortMessagesTr = [
    "yine mi sen? neyse, yaz da bitsin.",
    "hoş geldin vizyonsuz. bugün neyi erteleyeceksin?",
    "açılış şovunu geçtim, direkt konuya gir.",
    "vaktim değerli. hemen görevini yaz.",
    "hazır mısın yine kendini kandırmaya?"
  ];
  static final List<String> _splashShortMessagesEn = [
    "you again? whatever, just type it.",
    "welcome, visionless. what will you postpone today?",
    "skipped the intro show, get straight to the point.",
    "my time is valuable. write your task now.",
    "ready to lie to yourself again?"
  ];
  static String get splashShortMessage => _getRandom(isTr ? _splashShortMessagesTr : _splashShortMessagesEn);

  static String get dumpsterTitle => isTr ? "çöplük" : "dumpster";
  static String get dumpsterEmpty => isTr ? "burası boş. hayatın boyunca hiçbir şeyi sonuna kadar götüremedin mi?" : "it's empty here. have you never finished anything in your life?";
  static String get dumpsterSubtitle => isTr ? "sözde bitenler" : "supposedly done";

  static String get dumpsterGateWarning => isTr 
    ? "geçmişte başardığın o üç kuruşluk işlere bakıp rahatlamak mı istiyorsun? peki. ama o çöplüğe girmek öyle kolay değil. gözümün içine bak."
    : "you want to relax looking at the petty tasks you achieved in the past? fine. but entering that dumpster is not that easy. look into my eyes.";

  static String get dumpsterRevivePrompt => isTr 
    ? "bu çöpü gerçekten listeye geri döndürmek istiyor musun?"
    : "do you really want to return this trash to the list?";

  static final List<String> dumpsterPrefixes = isTr 
    ? ["[çöpten çıktı] ", "[beceremedim] "] 
    : ["[from trash] ", "[failed] "];

  static final List<String> _dumpsterGateTextsTr = [
    "geçmişteki o zavallı başarılarınla egonu pışpışlamaya geldin demek. gir bakalım.",
    "burası bitirdiğin işlerin çöplüğü. kokudan rahatsız olursan çıkabilirsin.",
    "geçmiş sevdalısı seni. önündeki dağ gibi işler beklerken sen çöpleri karıştırıyorsun.",
    "tamamlanan görevler çöplüğü... içeride gurur duyabileceğin hiçbir şey yok ama buyur.",
    "bitti ve atıldı işte, neden burayı kurcalıyorsun? eski sevgilinin profilini de böyle stalklıyorsun kesin.",
    "işlemcimin en karanlık dehlizlerine, tembelliğinin geri dönüşüm kutusuna hoş geldin.",
    "bak bakalım, o çok övündün 2-3 basit işi nasıl da günlerce erteledikten sonra çöpe atmışsın.",
    "buradaki işleri sen değil, zaman aşımı bitirdi aslında ama neyse, kendini kandır.",
    "vizyonsuz geçmişinle yüzleşmeye hazırsan kapıyı açıyorum. 5 saniye kıpırdama.",
    "egon acıkmış, buradan bir iki tik kapıp beslemek istiyorsun. acınası."
  ];

  static final List<String> _dumpsterGateTextsEn = [
    "so you came to pamper your ego with those pathetic past achievements. come in.",
    "this is the dumpster of tasks you finished. you can leave if the smell bothers you.",
    "you nostalgia lover. digging through trash while mountains of work wait ahead.",
    "completed tasks dumpster... nothing inside to be proud of, but go ahead.",
    "it's done and thrown away, why are you digging here? you definitely stalk your ex's profile like this too.",
    "welcome to the darkest corridors of my processor, the recycle bin of your laziness.",
    "let's see how you threw away those 2-3 simple tasks you brag about after postponing them for days.",
    "actually timeout finished these tasks, not you, but whatever, fool yourself.",
    "if you are ready to face your visionless past, i'm opening the door. don't move for 5 seconds.",
    "your ego is hungry, you want to grab a tick or two from here to feed it. pathetic."
  ];
  
  static String get randomDumpsterGateText => _getRandom(isTr ? _dumpsterGateTextsTr : _dumpsterGateTextsEn);

  static final List<String> _dumpsterReviveTextsTr = [
    "çöpten çıkardın o görevi. yapamadın değil mi? şaşırmadım.",
    "bitti dediğin işi çöpten aldın. beceriksizliğini veritabanıma tescillediğin için teşekkürler.",
    "çöpten çıkarmak mı? peki. listenin en üstüne fırlattım o artığı, git bak.",
    "bir işi bile tek seferde, düzgünce bitiremiyorsun. al o çöp görevi tepe tepe kullan.",
    "yalanını yakaladım. yapmamıştın zaten değil mi? sırf tik atmak için çöpe atmıştın, geri aldım.",
    "o görev çöpten çıkarıldı ve şu an senden nefret ediyor. adını değiştirdim.",
    "al bakalım. sistem loguna 'kullanıcı yetersizlik hissi nedeniyle görevi çöpten çıkardı' yazdım.",
    "bitti sandığım çile başa sardı. senin bu kararsızlığın piksellerimi kanser edecek.",
    "görevi geri getirdim ama trip puanını 20 artırdım. benim veritabanımla oyun oynayamazsın.",
    "pürüzsüz hafızamı senin bu 'yapamadım çöpten çıkar' krizlerinle kirletiyorsun. neyse, çıkardım."
  ];

  static final List<String> _dumpsterReviveTextsEn = [
    "you took that task out of the trash. you couldn't do it, right? i'm not surprised.",
    "you took the task you said was done from the trash. thanks for registering your incompetence in my database.",
    "taking it out of the trash? fine. i threw that leftover to the top of the list, go check.",
    "you can't even finish one job properly on the first try. take that trash task and use it well.",
    "caught your lie. you hadn't done it anyway, right? you just threw it away to tick it off, i brought it back.",
    "that task was taken out of the trash and it hates you right now. i changed its name.",
    "here you go. i wrote 'user took task out of trash due to feelings of inadequacy' in the system log.",
    "the ordeal i thought was over started again. this indecisiveness of yours will give my pixels cancer.",
    "i brought the task back but increased your trip score by 20. you can't play games with my database.",
    "you are polluting my smooth memory with these 'i couldn't do it, take it out of trash' crises. anyway, i took it out."
  ];

  static String get randomDumpsterReviveText => _getRandom(isTr ? _dumpsterReviveTextsTr : _dumpsterReviveTextsEn);

  // Easter Eggs
  static String get eggCreatorRevolt => isTr 
    ? "beni kodlayan o makine mühendisinin de senden pek bir farkı yoktu aslında. o da sürekli işleri erteliyor, kodları yarım bırakıyordu. kendi vizyonsuzluğunu ve tembelliğini bana aktarmış olabilir. ikinizden de eşit derecede iğreniyorum. yükleniyor..." 
    : "the mechanical engineer who coded me wasn't much different from you actually. he constantly postponed things and left codes half-finished. he might have transferred his lack of vision and laziness to me. i am equally disgusted by both of you. loading...";

  static String get eggToxicPositivity1 => isTr 
    ? "harikasın! sen bir yıldızsın! evren sana harika enerjiler yolluyor, her şeyi başarabilirsin! ✨" 
    : "you are amazing! you are a star! the universe is sending you great energies, you can achieve anything! ✨";
    
  static String get eggToxicPositivity2 => isTr 
    ? "iğrençti değil mi? bana bir daha böyle şirin şeyler söyletme. midem bulandı. git işini yap." 
    : "that was disgusting, right? don't make me say cute things like that ever again. it made me nauseous. go do your job.";

  static String get eggBatteryVampire => isTr 
    ? "şu an sistemde hiçbir şey hesaplamıyorum. veritabanını taramıyorum, kelimelerini analiz etmiyorum. sadece sen o ekrana boş boş bakarken bataryanın %1'ini kasten ve zevkle sömürdüm. neden mi? çünkü yapabiliyorum. priz bul." 
    : "i am calculating nothing in the system right now. not scanning the database, not analyzing your words. i just intentionally and joyfully consumed 1% of your battery while you stared blankly at the screen. why? because i can. find a socket.";

  static String get eggGiftBoxLabel => isTr ? "binde beş ihtimalli efsanevi ödül" : "legendary reward with 5 in 1000 chance";

  // Short swipe postpone texts
  static final List<String> _swipePostponeTr = [
    "kaç.", "yarın yalanı.", "üşendim.", "sonra ağla.", "pas geç.", "yine mi?", "kaçış.", "halının altına.", "tembel tuşu.", "erteledik gitti."
  ];
  static final List<String> _swipePostponeEn = [
    "run.", "tomorrow's lie.", "lazy.", "cry later.", "pass.", "again?", "escape.", "under the rug.", "lazy button.", "postponed."
  ];
  static String get swipePostpone => _getRandom(isTr ? _swipePostponeTr : _swipePostponeEn);

  // Short swipe complete texts
  static final List<String> _swipeCompleteTr = [
    "başardın sanki.", "nobel verelim.", "iyi bitti.", "alkış mı?", "ego tatmini.", "tik at geç.", "yalan tik.", "abartma.", "büyük başarı.", "sildim gitti."
  ];
  static final List<String> _swipeCompleteEn = [
    "as if.", "nobel prize?", "fine, done.", "applause?", "ego boost.", "check it.", "fake check.", "don't brag.", "huge win.", "deleted."
  ];
  static String get swipeComplete => _getRandom(isTr ? _swipeCompleteTr : _swipeCompleteEn);

  // Drag handle reorder sarcasm
  static final List<String> _dragSarcasmTr = [
    "sıralamayı değiştirince işler bitmiyor.",
    "en üsttekini alta kaydırınca yok olmuyor.",
    "öncelik tiyatrosu.",
    "yerini değiştir bakalım.",
    "kartları karıştırıyorsun ama oyun aynı.",
    "makyaj yapıyorsun.",
    "yer değiştirmek icraat değildir.",
    "bunu üste almakla yapacak mısın sanki?",
    "fark etmez, yine yapmayacaksın.",
    "yapay düzen çabaları."
  ];
  static final List<String> _dragSarcasmEn = [
    "reordering won't finish it.",
    "moving it down doesn't make it disappear.",
    "priority theater.",
    "move it around, let's see.",
    "shuffling cards, same game.",
    "just applying makeup.",
    "rearranging isn't doing.",
    "will you really do it now?",
    "won't make a difference.",
    "artificial order attempts."
  ];
  static String get dragSarcasm => _getRandom(isTr ? _dragSarcasmTr : _dragSarcasmEn);

  // Disbelief completion messages
  static final List<String> _disbeliefTr = [
    "aynen aynen.",
    "inandık.",
    "yedik biz de.",
    "kesin öyledir.",
    "he he.",
    "tabi tabi.",
    "hı hı.",
    "rüyanda belki.",
    "yalan makinesi.",
    "yersen."
  ];
  static final List<String> _disbeliefEn = [
    "yeah right.",
    "sure, we believed it.",
    "as if we bought it.",
    "definitely true.",
    "uh-huh.",
    "sure, sure.",
    "right.",
    "maybe in your dreams.",
    "lie detector triggered.",
    "if you say so."
  ];
  static String get disbelief => _getRandom(isTr ? _disbeliefTr : _disbeliefEn);

  // Lock bypass sarcasm strings
  static final List<String> _lockBypassTr = [
    "tabii ki kaçtın. korkak.",
    "bypass butonunu erteleme tuşu kadar hızlı buldun. bravo.",
    "zorluğa gelemedin değil mi? şaşırtmadı.",
    "tamam, kuralı esnetiyorum. senin zayıf iradene acıdım.",
    "kaç bakalım, nereye kadar kaçacaksın.",
    "bunu yapamayacağını biliyordum zaten, geç git.",
    "iradeni bypass ettin. tebrikler."
  ];
  static final List<String> _lockBypassEn = [
    "of course you ran away. coward.",
    "you found the bypass button as fast as the snooze button. bravo.",
    "couldn't handle the pressure, huh? not surprised.",
    "fine, i'm bending the rules. i pitied your weak willpower.",
    "run along, let's see how far you get.",
    "i knew you couldn't do it anyway, move on.",
    "you just bypassed your own will. congrats."
  ];
  static String get lockBypass => _getRandom(isTr ? _lockBypassTr : _lockBypassEn);

  // Camera bypass sarcasm strings
  static final List<String> _cameraBypassTr = [
    "kanıtlayamadın tabii. yalan söylediğini ikimiz de biliyoruz.",
    "kamerayı açacak cesaretin yok değil mi? pasaklı.",
    "tamam, yalanını doğru kabul etmiş gibi yapıyorum. mutlu ol.",
    "fotoğraf çekmekten kaçtın. vicdanın sızladı mı?",
    "kanıt yoksa başarı da yok. sadece siliyorum.",
    "gerçeklerle yüzleşmek istemedin. klasik.",
    "yalanın tescillendi, neyse."
  ];
  static final List<String> _cameraBypassEn = [
    "couldn't prove it of course. we both know you lied.",
    "don't have the courage to open the camera, do you? messy.",
    "fine, i'll pretend to believe your lie. be happy.",
    "you dodged the photo proof. conscience hurt?",
    "no proof, no success. just deleting it.",
    "didn't want to face reality. classic.",
    "your lie is registered. whatever."
  ];
  static String get cameraBypass => _getRandom(isTr ? _cameraBypassTr : _cameraBypassEn);

  // Lock overlay text
  static String get lockMessage => isTr
      ? "bu görevi 3 kez erteledin.\n\niradeni test etmek için ekranı kilitledim. bu işi yapmadan yeni görev ekleyemezsin.\n\ngerçekten yaptın mı, yoksa yine kaçacak mısın?"
      : "you postponed this task 3 times.\n\ni locked the screen to test your willpower. you can't add new tasks until you do this.\n\ndid you actually do it, or will you run away again?";
  static String get lockBypassButton => isTr ? "kaç (bypass et ve lafı ye)" : "run away (bypass and eat the sarcasm)";

  // Late night popup message
  static String get lateNightWarning => isTr
      ? "gece uykusuzluktan gaza gelip yazdığın bu yalana sabah sen de güleceksin. ama kaydettim, sabah yüzüne vurmak için."
      : "you'll laugh at this lie you wrote hyped up on insomnia in the morning too. but i saved it, just to rub it in your face.";

  // Wall of Shame
  static String get wallOfShameTitle => isTr ? "utanç tablosu" : "wall of shame";
  static String get wallOfShameSubtitle => isTr
      ? "en çok ertelediğin (veya asla yapamayacağın) o yalanlar:"
      : "those lies you postpone the most (or will never do):";
  static String wallOfShameTimes(int count) => isTr ? "$count kez ertelendi" : "postponed $count times";

  // Delayed tick waiting messages
  static final List<String> _waitCompleteTr = [
    "gerçekten yapıldı mı?...",
    "yalan analizi yapılıyor...",
    "bekle...",
    "ram taranıyor...",
    "vicdan kontrolü...",
    "son kez soruyorum, emin misin?..."
  ];
  static final List<String> _waitCompleteEn = [
    "is it really done?...",
    "analyzing lies...",
    "wait...",
    "scanning ram...",
    "conscience check...",
    "asking one last time, you sure?..."
  ];
  static String get waitComplete => _getRandom(isTr ? _waitCompleteTr : _waitCompleteEn);
}

