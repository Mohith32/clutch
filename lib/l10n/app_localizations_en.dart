// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Clutch';

  @override
  String get tagline => 'comes in clutch when it matters';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String get done => 'Done';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get add => 'Add';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get settings => 'Settings';

  @override
  String get saved => 'Saved ✓';

  @override
  String get ob1Title => 'Your emergency info, glanceable.';

  @override
  String get ob1Body =>
      'Allergies, blood group and who to call, right on your lock screen. Readable in 2 seconds, no unlock needed.';

  @override
  String get ob2Title => 'No account. No internet. No cap.';

  @override
  String get ob2Body =>
      'Everything stays encrypted on this phone. The app doesn\'t even have permission to go online.';

  @override
  String get ob3Title => 'For you and the whole fam.';

  @override
  String get ob3Body =>
      'Make cards for parents, kids and grandparents. Print wallet cards that work even when the phone doesn\'t.';

  @override
  String get obCta => 'Make my first card';

  @override
  String get disclaimer =>
      'Clutch is not a medical device. You\'re responsible for keeping your details accurate.';

  @override
  String get offlineSticker => '✦ 100% offline';

  @override
  String get homeTitle => 'your cards';

  @override
  String get homeEmptyTitle => 'No cards yet';

  @override
  String get homeEmptyBody =>
      'Takes about 3 minutes. Only the name is required, everything else is optional.';

  @override
  String get newCard => 'New card';

  @override
  String get makeOutputs => 'Wallpaper, card & QR';

  @override
  String staleBanner(String name) {
    return '$name\'s card is 6+ months old. Quick check?';
  }

  @override
  String deleteConfirm(String name) {
    return 'Delete $name\'s card? This can\'t be undone.';
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
    return 'Step $n of 4';
  }

  @override
  String get fName => 'Full name';

  @override
  String get nameRequired => 'Name is the one thing we need';

  @override
  String get fLanguage => 'Card language';

  @override
  String get fLanguageSub =>
      'What responders will read on the wallpaper and card';

  @override
  String get fVibe => 'Card colour';

  @override
  String get fBlood => 'Blood group';

  @override
  String get bloodUnknown => 'Not sure';

  @override
  String get fDonor => 'Organ donor';

  @override
  String get notSet => 'Skip';

  @override
  String get fAllergies => 'Allergies';

  @override
  String get fConditions => 'Conditions';

  @override
  String get fMeds => 'Medications';

  @override
  String get medName => 'Medicine';

  @override
  String get medDose => 'Dose';

  @override
  String get addMed => 'Add medication';

  @override
  String get fNotes => 'Notes for responders';

  @override
  String get notesHint => 'e.g. Uses an inhaler, carries an EpiPen';

  @override
  String get addItemHint => 'Type and tap +';

  @override
  String get fContacts => 'Emergency contacts';

  @override
  String contactN(int n) {
    return 'Contact $n';
  }

  @override
  String get cName => 'Name';

  @override
  String get cRelation => 'Relation';

  @override
  String get cPhone => 'Phone';

  @override
  String get badPhone => 'That number looks off';

  @override
  String get addContact => 'Add contact';

  @override
  String get pickContact => 'Pick from contacts';

  @override
  String get maxContactsNote =>
      'Up to 3 contacts. The first one goes front and centre.';

  @override
  String get fDoctor => 'Doctor';

  @override
  String get doctorName => 'Doctor\'s name';

  @override
  String get doctorPhone => 'Doctor\'s phone';

  @override
  String get reviewTitle => 'Looking good ✨';

  @override
  String get reviewBody =>
      'Saved on this phone only. Next up: wallpaper, wallet card and QR.';

  @override
  String get relMom => 'Mom';

  @override
  String get relDad => 'Dad';

  @override
  String get relPartner => 'Partner';

  @override
  String get relSibling => 'Sibling';

  @override
  String get relFriend => 'Friend';

  @override
  String get relChild => 'Child';

  @override
  String get tabWallpaper => 'Wallpaper';

  @override
  String get tabCard => 'Card';

  @override
  String get tabQr => 'QR';

  @override
  String get whatShows => 'What shows up';

  @override
  String get wpWarning =>
      'Heads up: anyone who sees your phone can read your lock screen. Only show what you\'re okay with.';

  @override
  String get wpStyle => 'Style';

  @override
  String get styleLight => 'Light';

  @override
  String get styleDark => 'Dark';

  @override
  String get wpOffset => 'Move it up or down';

  @override
  String get clockZone => 'clock zone';

  @override
  String get setLock => 'Set as lock screen';

  @override
  String get saveToPhotos => 'Save to Photos';

  @override
  String get sharePng => 'Share PNG';

  @override
  String get wpDone => 'Lock screen glow-up done ✨';

  @override
  String get savedToPhotos => 'Saved to Photos ✓';

  @override
  String get iosStepsTitle => 'Now set it as your lock screen';

  @override
  String get iosSteps =>
      '1. Open Photos and find the Clutch image\n2. Tap Share → Use as Wallpaper\n3. Choose Lock Screen and tap Add';

  @override
  String get exportPdf => 'Print / PDF';

  @override
  String get thisCard => 'Just this card';

  @override
  String wholeFam(int n) {
    return 'All $n cards';
  }

  @override
  String get pdfHint =>
      'Print at 100% scale. Cut around each pair, fold down the middle, laminate if you can.';

  @override
  String get front => 'Front';

  @override
  String get backSide => 'Back';

  @override
  String qrCount(int n) {
    return '$n/300 characters';
  }

  @override
  String get shareQr => 'Share QR';

  @override
  String get writeNfc => 'Write to NFC tag';

  @override
  String get nfcHold => 'Hold an NFC tag or sticker to the back of your phone…';

  @override
  String get nfcDone => 'Written to tag ✨';

  @override
  String nfcFail(String error) {
    return 'Couldn\'t write: $error';
  }

  @override
  String get vName => 'Name';

  @override
  String get vBlood => 'Blood';

  @override
  String get vAllergies => 'Allergies';

  @override
  String get vConditions => 'Conditions';

  @override
  String get vMeds => 'Meds';

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
  String get somethingWrong => 'Something went wrong. Try again?';

  @override
  String get sLanguage => 'App language';

  @override
  String get system => 'System';

  @override
  String get sTheme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get sReminder => '6-month check-in';

  @override
  String get sReminderSub =>
      'A nudge to make sure your cards are still accurate';

  @override
  String get sLock => 'Edit lock';

  @override
  String get sLockSub => 'Fingerprint, face or PIN before editing or exporting';

  @override
  String get sLockUnavailable => 'Set a screen lock on your phone first';

  @override
  String get sSos => 'Emergency number';

  @override
  String sSosSub(String n) {
    return 'Printed on your outputs. Default for your region: $n';
  }

  @override
  String get sBackup => 'Backup';

  @override
  String get passphrase => 'Passphrase (optional)';

  @override
  String get passphraseHint => 'Leave empty for an unencrypted file';

  @override
  String get backupWarn =>
      'Without a passphrase, anyone with the file can read your cards.';

  @override
  String get exportBackup => 'Export backup';

  @override
  String get importBackup => 'Import backup';

  @override
  String importDone(int n) {
    return 'Imported $n cards ✓';
  }

  @override
  String get importFail => 'That file didn\'t work';

  @override
  String get needPass => 'This backup is locked. Enter its passphrase above.';

  @override
  String get wrongPass => 'Wrong passphrase';

  @override
  String get sAbout => 'About';

  @override
  String get privacyLine =>
      'No account. No analytics. No internet permission. Your data never leaves this phone.';

  @override
  String get licences => 'Licences';

  @override
  String get unlockReason => 'Unlock to edit or export your emergency card';

  @override
  String get remChannel => 'Card check-ins';

  @override
  String get remTitle => 'Card check-in ⏰';

  @override
  String remBody(String name) {
    return 'Is $name\'s emergency card still accurate?';
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
  String get layoutQr => 'QR only';

  @override
  String get layoutDetails => 'Show details';

  @override
  String get layoutQrHint =>
      'Your lock screen shows only “In case of emergency” and a QR. Scanning it reveals your details.';

  @override
  String get wpBackground => 'Background';

  @override
  String get stylePhoto => 'My photo';

  @override
  String get styleSage => 'Sage';

  @override
  String get styleRose => 'Rose';

  @override
  String get styleSky => 'Sky';

  @override
  String get addTile => 'Also add to Quick Settings';

  @override
  String get tileLabel => 'Emergency QR';

  @override
  String get tileManual =>
      'Swipe down twice, tap ✎ edit, and drag “Emergency QR” in.';

  @override
  String get qrOpensAs => 'When scanned, open as';

  @override
  String get qrModeLink => 'Clutch page';

  @override
  String get qrModeText => 'Plain text';

  @override
  String get qrModeLinkHint =>
      'Opens a clean Clutch page with tap-to-call buttons. Needs internet on the scanner\'s phone. Your details live only inside the QR, never on a server.';

  @override
  String get qrModeTextHint =>
      'Works with no internet at all, but opens as plain text.';

  @override
  String get widgetTitle => 'Emergency QR widget';

  @override
  String get widgetSub =>
      'Puts your “In case of emergency” QR on your home screen, or your lock screen where your phone allows it. Tap it to show the QR full screen.';

  @override
  String get addWidget => 'Add widget';

  @override
  String get widgetLockHint =>
      'For the lock screen: touch and hold the lock screen → Widgets → Clutch.';

  @override
  String get widgetManual =>
      'Touch and hold your home screen → Widgets → Clutch.';
}
