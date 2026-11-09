// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appName => 'Clutch';

  @override
  String get tagline => 'అవసరమైనప్పుడు అండగా';

  @override
  String get next => 'తర్వాత';

  @override
  String get back => 'వెనక్కి';

  @override
  String get skip => 'దాటవేయి';

  @override
  String get done => 'అయిపోయింది';

  @override
  String get cancel => 'రద్దు';

  @override
  String get delete => 'తొలగించు';

  @override
  String get edit => 'మార్చు';

  @override
  String get duplicate => 'కాపీ చేయి';

  @override
  String get add => 'జోడించు';

  @override
  String get yes => 'అవును';

  @override
  String get no => 'కాదు';

  @override
  String get settings => 'సెట్టింగ్‌లు';

  @override
  String get saved => 'సేవ్ అయింది ✓';

  @override
  String get ob1Title => 'మీ ఎమర్జెన్సీ సమాచారం, ఒక్క చూపులో.';

  @override
  String get ob1Body =>
      'అలర్జీలు, బ్లడ్ గ్రూప్, ఎవరికి కాల్ చేయాలి, నేరుగా లాక్ స్క్రీన్‌పై. 2 సెకన్లలో చదవొచ్చు, అన్‌లాక్ అవసరం లేదు.';

  @override
  String get ob2Title => 'అకౌంట్ లేదు. ఇంటర్నెట్ లేదు. నిజంగా.';

  @override
  String get ob2Body =>
      'అంతా ఈ ఫోన్‌లోనే ఎన్‌క్రిప్ట్ అయి ఉంటుంది. యాప్‌కు ఆన్‌లైన్ వెళ్లే అనుమతే లేదు.';

  @override
  String get ob3Title => 'మీకు, మీ కుటుంబం మొత్తానికి.';

  @override
  String get ob3Body =>
      'అమ్మానాన్నలు, పిల్లలు, తాతయ్య-అమ్మమ్మల కోసం కార్డులు చేయండి. ఫోన్ పనిచేయకపోయినా ఉపయోగపడే వాలెట్ కార్డు ప్రింట్ చేయండి.';

  @override
  String get obCta => 'నా మొదటి కార్డు చేయండి';

  @override
  String get disclaimer =>
      'Clutch వైద్య పరికరం కాదు. మీ వివరాలు సరిగ్గా ఉంచడం మీ బాధ్యత.';

  @override
  String get offlineSticker => '✦ 100% ఆఫ్‌లైన్';

  @override
  String get homeTitle => 'మీ కార్డులు';

  @override
  String get homeEmptyTitle => 'ఇంకా కార్డులు లేవు';

  @override
  String get homeEmptyBody =>
      'సుమారు 3 నిమిషాలు పడుతుంది. పేరు మాత్రమే తప్పనిసరి, మిగతావన్నీ ఐచ్ఛికం.';

  @override
  String get newCard => 'కొత్త కార్డు';

  @override
  String get makeOutputs => 'వాల్‌పేపర్, కార్డు & QR';

  @override
  String staleBanner(String name) {
    return '$name కార్డు 6+ నెలల పాతది. ఒకసారి చూద్దామా?';
  }

  @override
  String deleteConfirm(String name) {
    return '$name కార్డు తొలగించాలా? ఇది తిరిగి రాదు.';
  }

  @override
  String updatedOn(String date) {
    return 'అప్‌డేట్ $date';
  }

  @override
  String get fam => 'కుటుంబం';

  @override
  String get stepBasics => 'ప్రాథమికం';

  @override
  String get stepMedical => 'వైద్యం';

  @override
  String get stepContacts => 'కాంటాక్ట్‌లు';

  @override
  String get stepReview => 'సమీక్ష';

  @override
  String stepOf(int n) {
    return 'దశ $n / 4';
  }

  @override
  String get fName => 'పూర్తి పేరు';

  @override
  String get nameRequired => 'పేరు ఒక్కటే అవసరం';

  @override
  String get fLanguage => 'కార్డు భాష';

  @override
  String get fLanguageSub => 'వాల్‌పేపర్, కార్డుపై సహాయకులు చదివేది';

  @override
  String get fVibe => 'కార్డు రంగు';

  @override
  String get fBlood => 'బ్లడ్ గ్రూప్';

  @override
  String get bloodUnknown => 'తెలియదు';

  @override
  String get fDonor => 'అవయవ దాత';

  @override
  String get notSet => 'దాటవేయి';

  @override
  String get fAllergies => 'అలర్జీలు';

  @override
  String get fConditions => 'ఆరోగ్య సమస్యలు';

  @override
  String get fMeds => 'మందులు';

  @override
  String get medName => 'మందు';

  @override
  String get medDose => 'మోతాదు';

  @override
  String get addMed => 'మందు జోడించు';

  @override
  String get fNotes => 'సహాయకుల కోసం గమనిక';

  @override
  String get notesHint => 'ఉదా: ఇన్‌హేలర్ వాడతారు, EpiPen దగ్గర ఉంటుంది';

  @override
  String get addItemHint => 'టైప్ చేసి + నొక్కండి';

  @override
  String get fContacts => 'ఎమర్జెన్సీ కాంటాక్ట్‌లు';

  @override
  String contactN(int n) {
    return 'కాంటాక్ట్ $n';
  }

  @override
  String get cName => 'పేరు';

  @override
  String get cRelation => 'సంబంధం';

  @override
  String get cPhone => 'ఫోన్';

  @override
  String get badPhone => 'ఈ నంబర్ సరిగ్గా లేనట్టుంది';

  @override
  String get addContact => 'కాంటాక్ట్ జోడించు';

  @override
  String get pickContact => 'కాంటాక్ట్‌ల నుంచి ఎంచుకోండి';

  @override
  String get maxContactsNote =>
      'గరిష్ఠంగా 3 కాంటాక్ట్‌లు. మొదటిది ముందుగా కనిపిస్తుంది.';

  @override
  String get fDoctor => 'డాక్టర్';

  @override
  String get doctorName => 'డాక్టర్ పేరు';

  @override
  String get doctorPhone => 'డాక్టర్ ఫోన్';

  @override
  String get reviewTitle => 'అదిరింది ✨';

  @override
  String get reviewBody =>
      'ఈ ఫోన్‌లో మాత్రమే సేవ్ అయింది. ఇప్పుడు: వాల్‌పేపర్, వాలెట్ కార్డు, QR.';

  @override
  String get relMom => 'అమ్మ';

  @override
  String get relDad => 'నాన్న';

  @override
  String get relPartner => 'భాగస్వామి';

  @override
  String get relSibling => 'తోబుట్టువు';

  @override
  String get relFriend => 'స్నేహితుడు';

  @override
  String get relChild => 'పిల్లలు';

  @override
  String get tabWallpaper => 'వాల్‌పేపర్';

  @override
  String get tabCard => 'కార్డు';

  @override
  String get tabQr => 'QR';

  @override
  String get whatShows => 'ఏం కనిపిస్తుంది';

  @override
  String get wpWarning =>
      'గమనించండి: మీ ఫోన్ చూసే ఎవరైనా లాక్ స్క్రీన్ చదవగలరు. మీకు ఓకే అనిపించేవి మాత్రమే చూపించండి.';

  @override
  String get wpStyle => 'స్టైల్';

  @override
  String get styleLight => 'లైట్';

  @override
  String get styleDark => 'డార్క్';

  @override
  String get wpOffset => 'పైకి లేదా కిందికి జరపండి';

  @override
  String get clockZone => 'గడియారం స్థలం';

  @override
  String get setLock => 'లాక్ స్క్రీన్‌గా పెట్టు';

  @override
  String get saveToPhotos => 'Photos లో సేవ్ చేయి';

  @override
  String get sharePng => 'PNG షేర్ చేయి';

  @override
  String get wpDone => 'లాక్ స్క్రీన్ రెడీ ✨';

  @override
  String get savedToPhotos => 'Photos లో సేవ్ అయింది ✓';

  @override
  String get iosStepsTitle => 'ఇప్పుడు లాక్ స్క్రీన్‌గా పెట్టండి';

  @override
  String get iosSteps =>
      '1. Photos తెరిచి Clutch ఇమేజ్ ఎంచుకోండి\n2. Share → Use as Wallpaper నొక్కండి\n3. Lock Screen ఎంచుకుని Add నొక్కండి';

  @override
  String get exportPdf => 'ప్రింట్ / PDF';

  @override
  String get thisCard => 'ఈ కార్డు మాత్రమే';

  @override
  String wholeFam(int n) {
    return 'మొత్తం $n కార్డులు';
  }

  @override
  String get pdfHint =>
      '100% స్కేల్‌లో ప్రింట్ చేయండి. ప్రతి జతను కత్తిరించి, మధ్యలో మడవండి, వీలైతే లామినేట్ చేయండి.';

  @override
  String get front => 'ముందు';

  @override
  String get backSide => 'వెనుక';

  @override
  String qrCount(int n) {
    return '$n/300 అక్షరాలు';
  }

  @override
  String get shareQr => 'QR షేర్ చేయి';

  @override
  String get writeNfc => 'NFC ట్యాగ్‌పై రాయి';

  @override
  String get nfcHold => 'NFC ట్యాగ్ లేదా స్టిక్కర్‌ను ఫోన్ వెనుక పెట్టండి…';

  @override
  String get nfcDone => 'ట్యాగ్‌పై రాశాం ✨';

  @override
  String nfcFail(String error) {
    return 'రాయలేకపోయాం: $error';
  }

  @override
  String get vName => 'పేరు';

  @override
  String get vBlood => 'బ్లడ్';

  @override
  String get vAllergies => 'అలర్జీలు';

  @override
  String get vConditions => 'సమస్యలు';

  @override
  String get vMeds => 'మందులు';

  @override
  String get vContacts => 'కాంటాక్ట్‌లు';

  @override
  String get vDoctor => 'డాక్టర్';

  @override
  String get vDonor => 'దాత';

  @override
  String get vNotes => 'గమనికలు';

  @override
  String get vSos => 'SOS నంబర్';

  @override
  String get somethingWrong => 'ఏదో తప్పు జరిగింది. మళ్ళీ ప్రయత్నిస్తారా?';

  @override
  String get sLanguage => 'యాప్ భాష';

  @override
  String get system => 'సిస్టమ్';

  @override
  String get sTheme => 'థీమ్';

  @override
  String get themeLight => 'లైట్';

  @override
  String get themeDark => 'డార్క్';

  @override
  String get sReminder => '6 నెలల చెక్-ఇన్';

  @override
  String get sReminderSub => 'కార్డులు ఇంకా సరిగ్గా ఉన్నాయో చూసుకోమని గుర్తు';

  @override
  String get sLock => 'ఎడిట్ లాక్';

  @override
  String get sLockSub =>
      'మార్చే లేదా ఎక్స్‌పోర్ట్ చేసే ముందు ఫింగర్‌ప్రింట్, ఫేస్ లేదా PIN';

  @override
  String get sLockUnavailable => 'ముందు ఫోన్‌లో స్క్రీన్ లాక్ పెట్టండి';

  @override
  String get sSos => 'ఎమర్జెన్సీ నంబర్';

  @override
  String sSosSub(String n) {
    return 'అవుట్‌పుట్‌లపై ముద్రిస్తాం. మీ ప్రాంతం డిఫాల్ట్: $n';
  }

  @override
  String get sBackup => 'బ్యాకప్';

  @override
  String get passphrase => 'పాస్‌ఫ్రేజ్ (ఐచ్ఛికం)';

  @override
  String get passphraseHint => 'ఎన్‌క్రిప్షన్ వద్దంటే ఖాళీగా వదలండి';

  @override
  String get backupWarn =>
      'పాస్‌ఫ్రేజ్ లేకపోతే, ఫైల్ ఉన్న ఎవరైనా మీ కార్డులు చదవగలరు.';

  @override
  String get exportBackup => 'బ్యాకప్ ఎక్స్‌పోర్ట్';

  @override
  String get importBackup => 'బ్యాకప్ ఇంపోర్ట్';

  @override
  String importDone(int n) {
    return '$n కార్డులు ఇంపోర్ట్ అయ్యాయి ✓';
  }

  @override
  String get importFail => 'ఈ ఫైల్ పనిచేయలేదు';

  @override
  String get needPass => 'ఈ బ్యాకప్ లాక్ అయింది. పైన పాస్‌ఫ్రేజ్ ఇవ్వండి.';

  @override
  String get wrongPass => 'తప్పు పాస్‌ఫ్రేజ్';

  @override
  String get sAbout => 'గురించి';

  @override
  String get privacyLine =>
      'అకౌంట్ లేదు. అనలిటిక్స్ లేదు. ఇంటర్నెట్ అనుమతి లేదు. మీ డేటా ఈ ఫోన్ దాటి వెళ్ళదు.';

  @override
  String get licences => 'లైసెన్సులు';

  @override
  String get unlockReason =>
      'ఎమర్జెన్సీ కార్డు మార్చడానికి లేదా ఎక్స్‌పోర్ట్ చేయడానికి అన్‌లాక్ చేయండి';

  @override
  String get remChannel => 'కార్డు చెక్-ఇన్‌లు';

  @override
  String get remTitle => 'కార్డు చెక్-ఇన్ ⏰';

  @override
  String remBody(String name) {
    return '$name ఎమర్జెన్సీ కార్డు ఇంకా సరిగ్గా ఉందా?';
  }

  @override
  String get outIce => 'అత్యవసర సమయంలో';

  @override
  String get outMoreInfo => 'వైద్య సమాచారం';

  @override
  String get outBlood => 'బ్లడ్';

  @override
  String get outAllergies => 'అలర్జీలు';

  @override
  String get outConditions => 'ఆరోగ్య సమస్యలు';

  @override
  String get outMeds => 'మందులు';

  @override
  String get outCall => 'కాల్ చేయండి';

  @override
  String get outDoctor => 'డాక్టర్';

  @override
  String get outDonor => 'అవయవ దాత';

  @override
  String get outNotes => 'గమనికలు';

  @override
  String get outSos => 'ఎమర్జెన్సీ';

  @override
  String get outUpdated => 'అప్‌డేట్';

  @override
  String get outScan => 'వివరాలకు స్కాన్ చేయండి';

  @override
  String get outDisclaimer =>
      'వివరాలు కార్డుదారు ఇచ్చినవి. ధృవీకరించిన వైద్య సలహా కాదు.';

  @override
  String get wpLayout => 'లేఅవుట్';

  @override
  String get layoutQr => 'QR మాత్రమే';

  @override
  String get layoutDetails => 'వివరాలు చూపించు';

  @override
  String get layoutQrHint =>
      'లాక్ స్క్రీన్‌పై “అత్యవసర సమయంలో” మరియు ఒక QR మాత్రమే కనిపిస్తాయి. స్కాన్ చేస్తే మీ వివరాలు కనిపిస్తాయి.';

  @override
  String get wpBackground => 'బ్యాక్‌గ్రౌండ్';

  @override
  String get stylePhoto => 'నా ఫోటో';

  @override
  String get styleSage => 'సేజ్';

  @override
  String get styleRose => 'రోజ్';

  @override
  String get styleSky => 'స్కై';

  @override
  String get passToggle => 'లాక్ స్క్రీన్ బటన్';

  @override
  String get passToggleSub =>
      'లాక్ స్క్రీన్‌పై పెట్టుకోగల “Clutch SOS” బటన్‌ను జోడిస్తుంది. నొక్కితే అన్‌లాక్ చేయకుండానే QR కనిపిస్తుంది.';

  @override
  String get passSetupTitle => 'SOS బటన్‌ను లాక్ స్క్రీన్‌పై పెట్టండి';

  @override
  String get passSteps =>
      '1. లాక్ స్క్రీన్‌ను నొక్కి పట్టుకోండి, లేదా లాక్ స్క్రీన్ సెట్టింగ్‌లు → Edit Lock screen తెరవండి\n2. కింద ఉన్న రెండు షార్ట్‌కట్‌లలో ఒకదాన్ని నొక్కండి\n3. “Clutch SOS” ఎంచుకుని Done నొక్కండి';

  @override
  String get openLockSettings => 'లాక్ స్క్రీన్ సెట్టింగ్‌లు తెరవండి';

  @override
  String get addTile => 'క్విక్ సెట్టింగ్స్‌లో కూడా జోడించు';

  @override
  String get tileLabel => 'ఎమర్జెన్సీ QR';

  @override
  String get tileManual =>
      'రెండుసార్లు కిందికి స్వైప్ చేసి, ✎ ఎడిట్ నొక్కి “ఎమర్జెన్సీ QR” జోడించండి.';

  @override
  String get qrOpensAs => 'స్కాన్ చేసినప్పుడు ఇలా తెరవాలి';

  @override
  String get qrModeLink => 'Clutch పేజీ';

  @override
  String get qrModeText => 'సాధారణ టెక్స్ట్';

  @override
  String get qrModeLinkHint =>
      'కాల్ బటన్లతో శుభ్రమైన Clutch పేజీ తెరుచుకుంటుంది. స్కాన్ చేసే ఫోన్‌లో ఇంటర్నెట్ అవసరం. మీ వివరాలు QR లోనే ఉంటాయి, ఏ సర్వర్‌లోనూ కాదు.';

  @override
  String get qrModeTextHint =>
      'ఇంటర్నెట్ లేకపోయినా పనిచేస్తుంది, కానీ సాధారణ టెక్స్ట్‌గా తెరుచుకుంటుంది.';
}
