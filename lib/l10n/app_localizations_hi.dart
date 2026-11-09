// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'Clutch';

  @override
  String get tagline => 'जब ज़रूरत हो, तब काम आए';

  @override
  String get next => 'आगे';

  @override
  String get back => 'पीछे';

  @override
  String get skip => 'छोड़ें';

  @override
  String get done => 'हो गया';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get edit => 'बदलें';

  @override
  String get duplicate => 'कॉपी बनाएँ';

  @override
  String get add => 'जोड़ें';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get saved => 'सेव हो गया ✓';

  @override
  String get ob1Title => 'आपकी इमरजेंसी जानकारी, एक नज़र में।';

  @override
  String get ob1Body =>
      'एलर्जी, ब्लड ग्रुप और किसे कॉल करें, सीधे लॉक स्क्रीन पर। 2 सेकंड में पढ़ें, फ़ोन अनलॉक किए बिना।';

  @override
  String get ob2Title => 'न अकाउंट। न इंटरनेट। सच में।';

  @override
  String get ob2Body =>
      'सब कुछ इसी फ़ोन पर एन्क्रिप्टेड रहता है। ऐप को ऑनलाइन जाने की अनुमति ही नहीं है।';

  @override
  String get ob3Title => 'आपके और पूरे परिवार के लिए।';

  @override
  String get ob3Body =>
      'माता-पिता, बच्चों और दादा-दादी के लिए कार्ड बनाएँ। वॉलेट कार्ड प्रिंट करें जो फ़ोन बंद होने पर भी काम आए।';

  @override
  String get obCta => 'मेरा पहला कार्ड बनाएँ';

  @override
  String get disclaimer =>
      'Clutch कोई मेडिकल डिवाइस नहीं है। अपनी जानकारी सही रखना आपकी ज़िम्मेदारी है।';

  @override
  String get offlineSticker => '✦ 100% ऑफ़लाइन';

  @override
  String get homeTitle => 'आपके कार्ड';

  @override
  String get homeEmptyTitle => 'अभी कोई कार्ड नहीं';

  @override
  String get homeEmptyBody =>
      'लगभग 3 मिनट लगते हैं। सिर्फ़ नाम ज़रूरी है, बाकी सब वैकल्पिक है।';

  @override
  String get newCard => 'नया कार्ड';

  @override
  String get makeOutputs => 'वॉलपेपर, कार्ड और QR';

  @override
  String staleBanner(String name) {
    return '$name का कार्ड 6+ महीने पुराना है। एक बार जाँच लें?';
  }

  @override
  String deleteConfirm(String name) {
    return '$name का कार्ड हटाएँ? यह वापस नहीं होगा।';
  }

  @override
  String updatedOn(String date) {
    return 'अपडेट $date';
  }

  @override
  String get fam => 'परिवार';

  @override
  String get stepBasics => 'बुनियादी';

  @override
  String get stepMedical => 'मेडिकल';

  @override
  String get stepContacts => 'संपर्क';

  @override
  String get stepReview => 'जाँचें';

  @override
  String stepOf(int n) {
    return 'चरण $n / 4';
  }

  @override
  String get fName => 'पूरा नाम';

  @override
  String get nameRequired => 'बस नाम ज़रूरी है';

  @override
  String get fLanguage => 'कार्ड की भाषा';

  @override
  String get fLanguageSub => 'वॉलपेपर और कार्ड पर मदद करने वाले क्या पढ़ेंगे';

  @override
  String get fVibe => 'कार्ड का रंग';

  @override
  String get fBlood => 'ब्लड ग्रुप';

  @override
  String get bloodUnknown => 'पता नहीं';

  @override
  String get fDonor => 'अंगदाता';

  @override
  String get notSet => 'छोड़ें';

  @override
  String get fAllergies => 'एलर्जी';

  @override
  String get fConditions => 'बीमारियाँ';

  @override
  String get fMeds => 'दवाइयाँ';

  @override
  String get medName => 'दवा';

  @override
  String get medDose => 'खुराक';

  @override
  String get addMed => 'दवा जोड़ें';

  @override
  String get fNotes => 'मदद करने वालों के लिए नोट';

  @override
  String get notesHint => 'जैसे: इनहेलर इस्तेमाल करते हैं, EpiPen साथ रखते हैं';

  @override
  String get addItemHint => 'लिखें और + दबाएँ';

  @override
  String get fContacts => 'इमरजेंसी संपर्क';

  @override
  String contactN(int n) {
    return 'संपर्क $n';
  }

  @override
  String get cName => 'नाम';

  @override
  String get cRelation => 'रिश्ता';

  @override
  String get cPhone => 'फ़ोन';

  @override
  String get badPhone => 'यह नंबर सही नहीं लग रहा';

  @override
  String get addContact => 'संपर्क जोड़ें';

  @override
  String get pickContact => 'कॉन्टैक्ट्स से चुनें';

  @override
  String get maxContactsNote =>
      'ज़्यादा से ज़्यादा 3 संपर्क। पहला सबसे आगे दिखेगा।';

  @override
  String get fDoctor => 'डॉक्टर';

  @override
  String get doctorName => 'डॉक्टर का नाम';

  @override
  String get doctorPhone => 'डॉक्टर का फ़ोन';

  @override
  String get reviewTitle => 'बढ़िया लग रहा है ✨';

  @override
  String get reviewBody =>
      'सिर्फ़ इसी फ़ोन पर सेव है। अब: वॉलपेपर, वॉलेट कार्ड और QR।';

  @override
  String get relMom => 'माँ';

  @override
  String get relDad => 'पापा';

  @override
  String get relPartner => 'पार्टनर';

  @override
  String get relSibling => 'भाई/बहन';

  @override
  String get relFriend => 'दोस्त';

  @override
  String get relChild => 'बच्चा';

  @override
  String get tabWallpaper => 'वॉलपेपर';

  @override
  String get tabCard => 'कार्ड';

  @override
  String get tabQr => 'QR';

  @override
  String get whatShows => 'क्या दिखेगा';

  @override
  String get wpWarning =>
      'ध्यान दें: जो भी आपका फ़ोन देखेगा, वह लॉक स्क्रीन पढ़ सकता है। सिर्फ़ वही दिखाएँ जो ठीक लगे।';

  @override
  String get wpStyle => 'स्टाइल';

  @override
  String get styleLight => 'लाइट';

  @override
  String get styleDark => 'डार्क';

  @override
  String get wpOffset => 'ऊपर या नीचे करें';

  @override
  String get clockZone => 'घड़ी की जगह';

  @override
  String get setLock => 'लॉक स्क्रीन पर लगाएँ';

  @override
  String get saveToPhotos => 'Photos में सेव करें';

  @override
  String get sharePng => 'PNG शेयर करें';

  @override
  String get wpDone => 'लॉक स्क्रीन तैयार ✨';

  @override
  String get savedToPhotos => 'Photos में सेव हो गया ✓';

  @override
  String get iosStepsTitle => 'अब इसे लॉक स्क्रीन पर लगाएँ';

  @override
  String get iosSteps =>
      '1. Photos खोलें और Clutch वाली इमेज चुनें\n2. Share → Use as Wallpaper दबाएँ\n3. Lock Screen चुनें और Add दबाएँ';

  @override
  String get exportPdf => 'प्रिंट / PDF';

  @override
  String get thisCard => 'सिर्फ़ यह कार्ड';

  @override
  String wholeFam(int n) {
    return 'सभी $n कार्ड';
  }

  @override
  String get pdfHint =>
      '100% स्केल पर प्रिंट करें। हर जोड़ी को काटें, बीच से मोड़ें, हो सके तो लैमिनेट करें।';

  @override
  String get front => 'आगे';

  @override
  String get backSide => 'पीछे';

  @override
  String qrCount(int n) {
    return '$n/300 अक्षर';
  }

  @override
  String get shareQr => 'QR शेयर करें';

  @override
  String get writeNfc => 'NFC टैग पर लिखें';

  @override
  String get nfcHold => 'NFC टैग या स्टिकर को फ़ोन के पीछे लगाएँ…';

  @override
  String get nfcDone => 'टैग पर लिख दिया ✨';

  @override
  String nfcFail(String error) {
    return 'लिख नहीं पाए: $error';
  }

  @override
  String get vName => 'नाम';

  @override
  String get vBlood => 'ब्लड';

  @override
  String get vAllergies => 'एलर्जी';

  @override
  String get vConditions => 'बीमारियाँ';

  @override
  String get vMeds => 'दवाइयाँ';

  @override
  String get vContacts => 'संपर्क';

  @override
  String get vDoctor => 'डॉक्टर';

  @override
  String get vDonor => 'अंगदाता';

  @override
  String get vNotes => 'नोट';

  @override
  String get vSos => 'SOS नंबर';

  @override
  String get somethingWrong => 'कुछ गड़बड़ हुई। फिर से कोशिश करें?';

  @override
  String get sLanguage => 'ऐप की भाषा';

  @override
  String get system => 'सिस्टम';

  @override
  String get sTheme => 'थीम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get sReminder => '6 महीने की याद';

  @override
  String get sReminderSub => 'कार्ड सही है या नहीं, यह जाँचने की याद';

  @override
  String get sLock => 'एडिट लॉक';

  @override
  String get sLockSub =>
      'बदलने या एक्सपोर्ट करने से पहले फ़िंगरप्रिंट, फ़ेस या PIN';

  @override
  String get sLockUnavailable => 'पहले फ़ोन पर स्क्रीन लॉक लगाएँ';

  @override
  String get sSos => 'इमरजेंसी नंबर';

  @override
  String sSosSub(String n) {
    return 'आउटपुट पर छपता है। आपके क्षेत्र का डिफ़ॉल्ट: $n';
  }

  @override
  String get sBackup => 'बैकअप';

  @override
  String get passphrase => 'पासफ़्रेज़ (वैकल्पिक)';

  @override
  String get passphraseHint => 'बिना एन्क्रिप्शन के लिए खाली छोड़ें';

  @override
  String get backupWarn =>
      'पासफ़्रेज़ के बिना, फ़ाइल वाला कोई भी आपके कार्ड पढ़ सकता है।';

  @override
  String get exportBackup => 'बैकअप एक्सपोर्ट करें';

  @override
  String get importBackup => 'बैकअप इम्पोर्ट करें';

  @override
  String importDone(int n) {
    return '$n कार्ड इम्पोर्ट हुए ✓';
  }

  @override
  String get importFail => 'यह फ़ाइल काम नहीं की';

  @override
  String get needPass => 'यह बैकअप लॉक है। ऊपर पासफ़्रेज़ डालें।';

  @override
  String get wrongPass => 'गलत पासफ़्रेज़';

  @override
  String get sAbout => 'जानकारी';

  @override
  String get privacyLine =>
      'न अकाउंट। न एनालिटिक्स। न इंटरनेट अनुमति। आपका डेटा इस फ़ोन से बाहर नहीं जाता।';

  @override
  String get licences => 'लाइसेंस';

  @override
  String get unlockReason =>
      'इमरजेंसी कार्ड बदलने या एक्सपोर्ट करने के लिए अनलॉक करें';

  @override
  String get remChannel => 'कार्ड की याद';

  @override
  String get remTitle => 'कार्ड चेक-इन ⏰';

  @override
  String remBody(String name) {
    return 'क्या $name का इमरजेंसी कार्ड अब भी सही है?';
  }

  @override
  String get outIce => 'आपातकाल में';

  @override
  String get outMoreInfo => 'मेडिकल जानकारी';

  @override
  String get outBlood => 'ब्लड';

  @override
  String get outAllergies => 'एलर्जी';

  @override
  String get outConditions => 'बीमारियाँ';

  @override
  String get outMeds => 'दवाइयाँ';

  @override
  String get outCall => 'कॉल करें';

  @override
  String get outDoctor => 'डॉक्टर';

  @override
  String get outDonor => 'अंगदाता';

  @override
  String get outNotes => 'नोट';

  @override
  String get outSos => 'इमरजेंसी';

  @override
  String get outUpdated => 'अपडेट';

  @override
  String get outScan => 'जानकारी के लिए स्कैन करें';

  @override
  String get outDisclaimer =>
      'जानकारी कार्डधारक ने दी है। यह जाँची हुई मेडिकल सलाह नहीं है।';

  @override
  String get wpLayout => 'लेआउट';

  @override
  String get layoutQr => 'सिर्फ़ QR';

  @override
  String get layoutDetails => 'जानकारी दिखाएँ';

  @override
  String get layoutQrHint =>
      'लॉक स्क्रीन पर सिर्फ़ “आपातकाल में” और एक QR दिखेगा। स्कैन करने पर आपकी जानकारी दिखेगी।';

  @override
  String get wpBackground => 'बैकग्राउंड';

  @override
  String get stylePhoto => 'मेरी फ़ोटो';

  @override
  String get styleSage => 'सेज';

  @override
  String get styleRose => 'रोज़';

  @override
  String get styleSky => 'स्काई';

  @override
  String get addTile => 'क्विक सेटिंग्स में भी जोड़ें';

  @override
  String get tileLabel => 'इमरजेंसी QR';

  @override
  String get tileManual =>
      'दो बार नीचे स्वाइप करें, ✎ एडिट दबाएँ और “इमरजेंसी QR” जोड़ें।';

  @override
  String get qrOpensAs => 'स्कैन होने पर ऐसे खुले';

  @override
  String get qrModeLink => 'Clutch पेज';

  @override
  String get qrModeText => 'सादा टेक्स्ट';

  @override
  String get qrModeLinkHint =>
      'टैप-टू-कॉल बटन वाला साफ़ Clutch पेज खुलता है। स्कैन करने वाले फ़ोन में इंटरनेट चाहिए। आपकी जानकारी सिर्फ़ QR में रहती है, किसी सर्वर पर नहीं।';

  @override
  String get qrModeTextHint =>
      'बिना इंटरनेट के भी काम करता है, पर सादे टेक्स्ट में खुलता है।';

  @override
  String get widgetTitle => 'इमरजेंसी QR विजेट';

  @override
  String get widgetSub =>
      'आपका “आपातकाल में” QR होम स्क्रीन पर, या जहाँ फ़ोन अनुमति दे वहाँ लॉक स्क्रीन पर रखता है। टैप करने पर QR पूरी स्क्रीन पर दिखता है।';

  @override
  String get addWidget => 'विजेट जोड़ें';

  @override
  String get widgetLockHint =>
      'QR को होम स्क्रीन पर जोड़ता है। Pixel और लॉक स्क्रीन विजेट वाले फ़ोन पर इसे वहाँ भी जोड़ सकते हैं। Samsung लॉक स्क्रीन पर सिर्फ़ अपने विजेट चलने देता है, इसलिए वहाँ QR वॉलपेपर या क्विक सेटिंग्स टाइल इस्तेमाल करें।';

  @override
  String get widgetManual => 'होम स्क्रीन को दबाकर रखें → Widgets → Clutch।';
}

/// The translations for Hindi, using the Latin script (`hi_Latn`).
class AppLocalizationsHiLatn extends AppLocalizationsHi {
  AppLocalizationsHiLatn() : super('hi_Latn');

  @override
  String get appName => 'Clutch';

  @override
  String get tagline => 'jab zaroorat ho, tab clutch';

  @override
  String get next => 'Aage';

  @override
  String get back => 'Peeche';

  @override
  String get skip => 'Skip karo';

  @override
  String get done => 'Ho gaya';

  @override
  String get cancel => 'Rehne do';

  @override
  String get delete => 'Hatao';

  @override
  String get edit => 'Edit karo';

  @override
  String get duplicate => 'Copy banao';

  @override
  String get add => 'Add karo';

  @override
  String get yes => 'Haan';

  @override
  String get no => 'Nahi';

  @override
  String get settings => 'Settings';

  @override
  String get saved => 'Save ho gaya ✓';

  @override
  String get ob1Title => 'Emergency info, bas ek nazar mein.';

  @override
  String get ob1Body =>
      'Allergy, blood group aur kisko call karna hai, seedha lock screen pe. 2 second mein padh lo, unlock ki zaroorat nahi.';

  @override
  String get ob2Title => 'No account. No internet. No cap.';

  @override
  String get ob2Body =>
      'Sab kuch isi phone pe encrypted rehta hai. App ko online jaane ki permission hi nahi hai.';

  @override
  String get ob3Title => 'Tere liye aur poori fam ke liye.';

  @override
  String get ob3Body =>
      'Mummy-papa, bachchon aur dada-dadi ke cards banao. Wallet card print karo jo phone band ho tab bhi kaam aaye.';

  @override
  String get obCta => 'Mera pehla card banao';

  @override
  String get disclaimer =>
      'Clutch koi medical device nahi hai. Details sahi rakhna tumhari zimmedari hai.';

  @override
  String get offlineSticker => '✦ 100% offline';

  @override
  String get homeTitle => 'tere cards';

  @override
  String get homeEmptyTitle => 'Abhi koi card nahi';

  @override
  String get homeEmptyBody =>
      'Bas 3 minute lagte hain. Sirf naam zaroori hai, baaki sab optional.';

  @override
  String get newCard => 'Naya card';

  @override
  String get makeOutputs => 'Wallpaper, card & QR';

  @override
  String staleBanner(String name) {
    return '$name ka card 6+ mahine purana hai. Ek baar check karein?';
  }

  @override
  String deleteConfirm(String name) {
    return '$name ka card hatana hai? Wapas nahi aayega.';
  }

  @override
  String updatedOn(String date) {
    return 'Updated $date';
  }

  @override
  String get fam => 'the fam';

  @override
  String get stepBasics => 'Basics';

  @override
  String get stepMedical => 'Medical';

  @override
  String get stepContacts => 'Contacts';

  @override
  String get stepReview => 'Review';

  @override
  String stepOf(int n) {
    return 'Step $n / 4';
  }

  @override
  String get fName => 'Poora naam';

  @override
  String get nameRequired => 'Bas naam chahiye, baaki chill';

  @override
  String get fLanguage => 'Card ki bhasha';

  @override
  String get fLanguageSub => 'Wallpaper aur card pe responders kya padhenge';

  @override
  String get fVibe => 'Card ka colour';

  @override
  String get fBlood => 'Blood group';

  @override
  String get bloodUnknown => 'Pata nahi';

  @override
  String get fDonor => 'Organ donor';

  @override
  String get notSet => 'Skip';

  @override
  String get fAllergies => 'Allergies';

  @override
  String get fConditions => 'Conditions';

  @override
  String get fMeds => 'Dawaiyan';

  @override
  String get medName => 'Dawai';

  @override
  String get medDose => 'Dose';

  @override
  String get addMed => 'Dawai add karo';

  @override
  String get fNotes => 'Responders ke liye note';

  @override
  String get notesHint => 'jaise: inhaler use karte hain, EpiPen saath hai';

  @override
  String get addItemHint => 'Likho aur + dabao';

  @override
  String get fContacts => 'Emergency contacts';

  @override
  String contactN(int n) {
    return 'Contact $n';
  }

  @override
  String get cName => 'Naam';

  @override
  String get cRelation => 'Rishta';

  @override
  String get cPhone => 'Phone';

  @override
  String get badPhone => 'Ye number thoda off lag raha hai';

  @override
  String get addContact => 'Contact add karo';

  @override
  String get pickContact => 'Contacts se chuno';

  @override
  String get maxContactsNote =>
      'Max 3 contacts. Pehla wala sabse aage dikhega.';

  @override
  String get fDoctor => 'Doctor';

  @override
  String get doctorName => 'Doctor ka naam';

  @override
  String get doctorPhone => 'Doctor ka phone';

  @override
  String get reviewTitle => 'Ekdum mast ✨';

  @override
  String get reviewBody =>
      'Sirf isi phone pe save hai. Ab: wallpaper, wallet card aur QR.';

  @override
  String get relMom => 'Mummy';

  @override
  String get relDad => 'Papa';

  @override
  String get relPartner => 'Partner';

  @override
  String get relSibling => 'Bhai/Behen';

  @override
  String get relFriend => 'Dost';

  @override
  String get relChild => 'Bachcha';

  @override
  String get tabWallpaper => 'Wallpaper';

  @override
  String get tabCard => 'Card';

  @override
  String get tabQr => 'QR';

  @override
  String get whatShows => 'Kya dikhega';

  @override
  String get wpWarning =>
      'Dhyaan do: jo bhi tera phone dekhega, lock screen padh sakta hai. Wahi dikhao jo theek lage.';

  @override
  String get wpStyle => 'Style';

  @override
  String get styleLight => 'Light';

  @override
  String get styleDark => 'Dark';

  @override
  String get wpOffset => 'Upar ya neeche karo';

  @override
  String get clockZone => 'clock zone';

  @override
  String get setLock => 'Lock screen pe lagao';

  @override
  String get saveToPhotos => 'Photos mein save karo';

  @override
  String get sharePng => 'PNG share karo';

  @override
  String get wpDone => 'Lock screen glow-up done ✨';

  @override
  String get savedToPhotos => 'Photos mein save ✓';

  @override
  String get iosStepsTitle => 'Ab lock screen pe lagao';

  @override
  String get iosSteps =>
      '1. Photos kholo aur Clutch wali image dhoondo\n2. Share → Use as Wallpaper dabao\n3. Lock Screen chuno aur Add dabao';

  @override
  String get exportPdf => 'Print / PDF';

  @override
  String get thisCard => 'Sirf ye card';

  @override
  String wholeFam(int n) {
    return 'Saare $n cards';
  }

  @override
  String get pdfHint =>
      '100% scale pe print karo. Har pair kaato, beech se fold karo, ho sake to laminate.';

  @override
  String get front => 'Front';

  @override
  String get backSide => 'Back';

  @override
  String qrCount(int n) {
    return '$n/300 characters';
  }

  @override
  String get shareQr => 'QR share karo';

  @override
  String get writeNfc => 'NFC tag pe likho';

  @override
  String get nfcHold => 'NFC tag ya sticker phone ke peeche lagao…';

  @override
  String get nfcDone => 'Tag pe likh diya ✨';

  @override
  String nfcFail(String error) {
    return 'Likh nahi paaye: $error';
  }

  @override
  String get vName => 'Naam';

  @override
  String get vBlood => 'Blood';

  @override
  String get vAllergies => 'Allergies';

  @override
  String get vConditions => 'Conditions';

  @override
  String get vMeds => 'Dawaiyan';

  @override
  String get vContacts => 'Contacts';

  @override
  String get vDoctor => 'Doctor';

  @override
  String get vDonor => 'Donor';

  @override
  String get vNotes => 'Notes';

  @override
  String get vSos => 'SOS number';

  @override
  String get somethingWrong => 'Kuch gadbad ho gayi. Phir try karein?';

  @override
  String get sLanguage => 'App ki bhasha';

  @override
  String get system => 'System';

  @override
  String get sTheme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get sReminder => '6 mahine ka check-in';

  @override
  String get sReminderSub =>
      'Cards abhi bhi sahi hain, ye check karne ka nudge';

  @override
  String get sLock => 'Edit lock';

  @override
  String get sLockSub => 'Edit ya export se pehle fingerprint, face ya PIN';

  @override
  String get sLockUnavailable => 'Pehle phone pe screen lock lagao';

  @override
  String get sSos => 'Emergency number';

  @override
  String sSosSub(String n) {
    return 'Outputs pe chhapta hai. Tere area ka default: $n';
  }

  @override
  String get sBackup => 'Backup';

  @override
  String get passphrase => 'Passphrase (optional)';

  @override
  String get passphraseHint => 'Bina encryption ke liye khaali chhodo';

  @override
  String get backupWarn =>
      'Passphrase ke bina, file wala koi bhi cards padh sakta hai.';

  @override
  String get exportBackup => 'Backup export karo';

  @override
  String get importBackup => 'Backup import karo';

  @override
  String importDone(int n) {
    return '$n cards import ho gaye ✓';
  }

  @override
  String get importFail => 'Ye file nahi chali';

  @override
  String get needPass => 'Ye backup locked hai. Upar passphrase daalo.';

  @override
  String get wrongPass => 'Galat passphrase';

  @override
  String get sAbout => 'About';

  @override
  String get privacyLine =>
      'No account. No analytics. No internet permission. Tera data is phone se bahar nahi jaata.';

  @override
  String get licences => 'Licences';

  @override
  String get unlockReason =>
      'Emergency card edit ya export karne ke liye unlock karo';

  @override
  String get remChannel => 'Card check-ins';

  @override
  String get remTitle => 'Card check-in ⏰';

  @override
  String remBody(String name) {
    return '$name ka emergency card abhi bhi sahi hai?';
  }

  @override
  String get outIce => 'IN CASE OF EMERGENCY';

  @override
  String get outMoreInfo => 'MEDICAL INFO';

  @override
  String get outBlood => 'Blood';

  @override
  String get outAllergies => 'Allergies';

  @override
  String get outConditions => 'Conditions';

  @override
  String get outMeds => 'Medications';

  @override
  String get outCall => 'Call';

  @override
  String get outDoctor => 'Doctor';

  @override
  String get outDonor => 'Organ donor';

  @override
  String get outNotes => 'Notes';

  @override
  String get outSos => 'Emergency';

  @override
  String get outUpdated => 'Updated';

  @override
  String get outScan => 'Scan for details';

  @override
  String get outDisclaimer =>
      'Details provided by the card holder. Not verified medical advice.';

  @override
  String get wpLayout => 'Layout';

  @override
  String get layoutQr => 'Sirf QR';

  @override
  String get layoutDetails => 'Details dikhao';

  @override
  String get layoutQrHint =>
      'Lock screen pe sirf “In case of emergency” aur ek QR dikhega. Scan karne pe details dikhengi.';

  @override
  String get wpBackground => 'Background';

  @override
  String get stylePhoto => 'Meri photo';

  @override
  String get styleSage => 'Sage';

  @override
  String get styleRose => 'Rose';

  @override
  String get styleSky => 'Sky';

  @override
  String get addTile => 'Quick Settings mein bhi add karo';

  @override
  String get tileLabel => 'Emergency QR';

  @override
  String get tileManual =>
      'Do baar neeche swipe karo, ✎ edit dabao aur “Emergency QR” add karo.';

  @override
  String get qrOpensAs => 'Scan hone pe kaise khule';

  @override
  String get qrModeLink => 'Clutch page';

  @override
  String get qrModeText => 'Plain text';

  @override
  String get qrModeLinkHint =>
      'Tap-to-call buttons wala clean Clutch page khulta hai. Scan karne wale phone mein internet chahiye. Details sirf QR mein hain, kisi server pe nahi.';

  @override
  String get qrModeTextHint =>
      'Bina internet ke bhi chalta hai, par plain text mein khulta hai.';

  @override
  String get widgetTitle => 'Emergency QR widget';

  @override
  String get widgetSub =>
      'Tera “In case of emergency” QR home screen pe, ya jahan phone allow kare wahan lock screen pe. Tap karo to QR full screen.';

  @override
  String get addWidget => 'Widget add karo';

  @override
  String get widgetLockHint =>
      'QR ko home screen pe add karta hai. Pixel aur lock screen widget wale phones pe wahan bhi add kar sakte ho. Samsung lock screen pe sirf apne widgets allow karta hai, to wahan QR wallpaper ya Quick Settings tile use karo.';

  @override
  String get widgetManual => 'Home screen ko hold karo → Widgets → Clutch.';
}
