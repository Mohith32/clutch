import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale.fromSubtags(languageCode: 'hi', scriptCode: 'Latn'),
    Locale('te'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Clutch'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'comes in clutch when it matters'**
  String get tagline;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved ✓'**
  String get saved;

  /// No description provided for @ob1Title.
  ///
  /// In en, this message translates to:
  /// **'Your emergency info, glanceable.'**
  String get ob1Title;

  /// No description provided for @ob1Body.
  ///
  /// In en, this message translates to:
  /// **'Allergies, blood group and who to call, right on your lock screen. Readable in 2 seconds, no unlock needed.'**
  String get ob1Body;

  /// No description provided for @ob2Title.
  ///
  /// In en, this message translates to:
  /// **'No account. No internet. No cap.'**
  String get ob2Title;

  /// No description provided for @ob2Body.
  ///
  /// In en, this message translates to:
  /// **'Everything stays encrypted on this phone. The app doesn\'t even have permission to go online.'**
  String get ob2Body;

  /// No description provided for @ob3Title.
  ///
  /// In en, this message translates to:
  /// **'For you and the whole fam.'**
  String get ob3Title;

  /// No description provided for @ob3Body.
  ///
  /// In en, this message translates to:
  /// **'Make cards for parents, kids and grandparents. Print wallet cards that work even when the phone doesn\'t.'**
  String get ob3Body;

  /// No description provided for @obCta.
  ///
  /// In en, this message translates to:
  /// **'Make my first card'**
  String get obCta;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Clutch is not a medical device. You\'re responsible for keeping your details accurate.'**
  String get disclaimer;

  /// No description provided for @offlineSticker.
  ///
  /// In en, this message translates to:
  /// **'✦ 100% offline'**
  String get offlineSticker;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'your cards'**
  String get homeTitle;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No cards yet'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Takes about 3 minutes. Only the name is required, everything else is optional.'**
  String get homeEmptyBody;

  /// No description provided for @newCard.
  ///
  /// In en, this message translates to:
  /// **'New card'**
  String get newCard;

  /// No description provided for @makeOutputs.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper, card & QR'**
  String get makeOutputs;

  /// No description provided for @staleBanner.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s card is 6+ months old. Quick check?'**
  String staleBanner(String name);

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}\'s card? This can\'t be undone.'**
  String deleteConfirm(String name);

  /// No description provided for @updatedOn.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String updatedOn(String date);

  /// No description provided for @fam.
  ///
  /// In en, this message translates to:
  /// **'the fam'**
  String get fam;

  /// No description provided for @stepBasics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get stepBasics;

  /// No description provided for @stepMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get stepMedical;

  /// No description provided for @stepContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get stepContacts;

  /// No description provided for @stepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get stepReview;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {n} of 4'**
  String stepOf(int n);

  /// No description provided for @fName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fName;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is the one thing we need'**
  String get nameRequired;

  /// No description provided for @fLanguage.
  ///
  /// In en, this message translates to:
  /// **'Card language'**
  String get fLanguage;

  /// No description provided for @fLanguageSub.
  ///
  /// In en, this message translates to:
  /// **'What responders will read on the wallpaper and card'**
  String get fLanguageSub;

  /// No description provided for @fVibe.
  ///
  /// In en, this message translates to:
  /// **'Card colour'**
  String get fVibe;

  /// No description provided for @fBlood.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get fBlood;

  /// No description provided for @bloodUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get bloodUnknown;

  /// No description provided for @fDonor.
  ///
  /// In en, this message translates to:
  /// **'Organ donor'**
  String get fDonor;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get notSet;

  /// No description provided for @fAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get fAllergies;

  /// No description provided for @fConditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get fConditions;

  /// No description provided for @fMeds.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get fMeds;

  /// No description provided for @medName.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medName;

  /// No description provided for @medDose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get medDose;

  /// No description provided for @addMed.
  ///
  /// In en, this message translates to:
  /// **'Add medication'**
  String get addMed;

  /// No description provided for @fNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes for responders'**
  String get fNotes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Uses an inhaler, carries an EpiPen'**
  String get notesHint;

  /// No description provided for @addItemHint.
  ///
  /// In en, this message translates to:
  /// **'Type and tap +'**
  String get addItemHint;

  /// No description provided for @fContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency contacts'**
  String get fContacts;

  /// No description provided for @contactN.
  ///
  /// In en, this message translates to:
  /// **'Contact {n}'**
  String contactN(int n);

  /// No description provided for @cName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get cName;

  /// No description provided for @cRelation.
  ///
  /// In en, this message translates to:
  /// **'Relation'**
  String get cRelation;

  /// No description provided for @cPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get cPhone;

  /// No description provided for @badPhone.
  ///
  /// In en, this message translates to:
  /// **'That number looks off'**
  String get badPhone;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get addContact;

  /// No description provided for @pickContact.
  ///
  /// In en, this message translates to:
  /// **'Pick from contacts'**
  String get pickContact;

  /// No description provided for @maxContactsNote.
  ///
  /// In en, this message translates to:
  /// **'Up to 3 contacts. The first one goes front and centre.'**
  String get maxContactsNote;

  /// No description provided for @fDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get fDoctor;

  /// No description provided for @doctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s name'**
  String get doctorName;

  /// No description provided for @doctorPhone.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s phone'**
  String get doctorPhone;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Looking good ✨'**
  String get reviewTitle;

  /// No description provided for @reviewBody.
  ///
  /// In en, this message translates to:
  /// **'Saved on this phone only. Next up: wallpaper, wallet card and QR.'**
  String get reviewBody;

  /// No description provided for @relMom.
  ///
  /// In en, this message translates to:
  /// **'Mom'**
  String get relMom;

  /// No description provided for @relDad.
  ///
  /// In en, this message translates to:
  /// **'Dad'**
  String get relDad;

  /// No description provided for @relPartner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get relPartner;

  /// No description provided for @relSibling.
  ///
  /// In en, this message translates to:
  /// **'Sibling'**
  String get relSibling;

  /// No description provided for @relFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get relFriend;

  /// No description provided for @relChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get relChild;

  /// No description provided for @tabWallpaper.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper'**
  String get tabWallpaper;

  /// No description provided for @tabCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get tabCard;

  /// No description provided for @tabQr.
  ///
  /// In en, this message translates to:
  /// **'QR'**
  String get tabQr;

  /// No description provided for @whatShows.
  ///
  /// In en, this message translates to:
  /// **'What shows up'**
  String get whatShows;

  /// No description provided for @wpWarning.
  ///
  /// In en, this message translates to:
  /// **'Heads up: anyone who sees your phone can read your lock screen. Only show what you\'re okay with.'**
  String get wpWarning;

  /// No description provided for @wpStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get wpStyle;

  /// No description provided for @styleLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get styleLight;

  /// No description provided for @styleDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get styleDark;

  /// No description provided for @wpOffset.
  ///
  /// In en, this message translates to:
  /// **'Move it up or down'**
  String get wpOffset;

  /// No description provided for @clockZone.
  ///
  /// In en, this message translates to:
  /// **'clock zone'**
  String get clockZone;

  /// No description provided for @setLock.
  ///
  /// In en, this message translates to:
  /// **'Set as lock screen'**
  String get setLock;

  /// No description provided for @saveToPhotos.
  ///
  /// In en, this message translates to:
  /// **'Save to Photos'**
  String get saveToPhotos;

  /// No description provided for @sharePng.
  ///
  /// In en, this message translates to:
  /// **'Share PNG'**
  String get sharePng;

  /// No description provided for @wpDone.
  ///
  /// In en, this message translates to:
  /// **'Lock screen glow-up done ✨'**
  String get wpDone;

  /// No description provided for @savedToPhotos.
  ///
  /// In en, this message translates to:
  /// **'Saved to Photos ✓'**
  String get savedToPhotos;

  /// No description provided for @iosStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Now set it as your lock screen'**
  String get iosStepsTitle;

  /// No description provided for @iosSteps.
  ///
  /// In en, this message translates to:
  /// **'1. Open Photos and find the Clutch image\n2. Tap Share → Use as Wallpaper\n3. Choose Lock Screen and tap Add'**
  String get iosSteps;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Print / PDF'**
  String get exportPdf;

  /// No description provided for @thisCard.
  ///
  /// In en, this message translates to:
  /// **'Just this card'**
  String get thisCard;

  /// No description provided for @wholeFam.
  ///
  /// In en, this message translates to:
  /// **'All {n} cards'**
  String wholeFam(int n);

  /// No description provided for @pdfHint.
  ///
  /// In en, this message translates to:
  /// **'Print at 100% scale. Cut around each pair, fold down the middle, laminate if you can.'**
  String get pdfHint;

  /// No description provided for @front.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get front;

  /// No description provided for @backSide.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backSide;

  /// No description provided for @qrCount.
  ///
  /// In en, this message translates to:
  /// **'{n}/300 characters'**
  String qrCount(int n);

  /// No description provided for @shareQr.
  ///
  /// In en, this message translates to:
  /// **'Share QR'**
  String get shareQr;

  /// No description provided for @writeNfc.
  ///
  /// In en, this message translates to:
  /// **'Write to NFC tag'**
  String get writeNfc;

  /// No description provided for @nfcHold.
  ///
  /// In en, this message translates to:
  /// **'Hold an NFC tag or sticker to the back of your phone…'**
  String get nfcHold;

  /// No description provided for @nfcDone.
  ///
  /// In en, this message translates to:
  /// **'Written to tag ✨'**
  String get nfcDone;

  /// No description provided for @nfcFail.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t write: {error}'**
  String nfcFail(String error);

  /// No description provided for @vName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get vName;

  /// No description provided for @vBlood.
  ///
  /// In en, this message translates to:
  /// **'Blood'**
  String get vBlood;

  /// No description provided for @vAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get vAllergies;

  /// No description provided for @vConditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get vConditions;

  /// No description provided for @vMeds.
  ///
  /// In en, this message translates to:
  /// **'Meds'**
  String get vMeds;

  /// No description provided for @vContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get vContacts;

  /// No description provided for @vDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get vDoctor;

  /// No description provided for @vDonor.
  ///
  /// In en, this message translates to:
  /// **'Donor'**
  String get vDonor;

  /// No description provided for @vNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get vNotes;

  /// No description provided for @vSos.
  ///
  /// In en, this message translates to:
  /// **'SOS number'**
  String get vSos;

  /// No description provided for @somethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again?'**
  String get somethingWrong;

  /// No description provided for @sLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get sLanguage;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @sTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get sTheme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @sReminder.
  ///
  /// In en, this message translates to:
  /// **'6-month check-in'**
  String get sReminder;

  /// No description provided for @sReminderSub.
  ///
  /// In en, this message translates to:
  /// **'A nudge to make sure your cards are still accurate'**
  String get sReminderSub;

  /// No description provided for @sLock.
  ///
  /// In en, this message translates to:
  /// **'Edit lock'**
  String get sLock;

  /// No description provided for @sLockSub.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint, face or PIN before editing or exporting'**
  String get sLockSub;

  /// No description provided for @sLockUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Set a screen lock on your phone first'**
  String get sLockUnavailable;

  /// No description provided for @sSos.
  ///
  /// In en, this message translates to:
  /// **'Emergency number'**
  String get sSos;

  /// No description provided for @sSosSub.
  ///
  /// In en, this message translates to:
  /// **'Printed on your outputs. Default for your region: {n}'**
  String sSosSub(String n);

  /// No description provided for @sBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get sBackup;

  /// No description provided for @passphrase.
  ///
  /// In en, this message translates to:
  /// **'Passphrase (optional)'**
  String get passphrase;

  /// No description provided for @passphraseHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for an unencrypted file'**
  String get passphraseHint;

  /// No description provided for @backupWarn.
  ///
  /// In en, this message translates to:
  /// **'Without a passphrase, anyone with the file can read your cards.'**
  String get backupWarn;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackup;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get importBackup;

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Imported {n} cards ✓'**
  String importDone(int n);

  /// No description provided for @importFail.
  ///
  /// In en, this message translates to:
  /// **'That file didn\'t work'**
  String get importFail;

  /// No description provided for @needPass.
  ///
  /// In en, this message translates to:
  /// **'This backup is locked. Enter its passphrase above.'**
  String get needPass;

  /// No description provided for @wrongPass.
  ///
  /// In en, this message translates to:
  /// **'Wrong passphrase'**
  String get wrongPass;

  /// No description provided for @sAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sAbout;

  /// No description provided for @privacyLine.
  ///
  /// In en, this message translates to:
  /// **'No account. No analytics. No internet permission. Your data never leaves this phone.'**
  String get privacyLine;

  /// No description provided for @licences.
  ///
  /// In en, this message translates to:
  /// **'Licences'**
  String get licences;

  /// No description provided for @unlockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock to edit or export your emergency card'**
  String get unlockReason;

  /// No description provided for @remChannel.
  ///
  /// In en, this message translates to:
  /// **'Card check-ins'**
  String get remChannel;

  /// No description provided for @remTitle.
  ///
  /// In en, this message translates to:
  /// **'Card check-in ⏰'**
  String get remTitle;

  /// No description provided for @remBody.
  ///
  /// In en, this message translates to:
  /// **'Is {name}\'s emergency card still accurate?'**
  String remBody(String name);

  /// No description provided for @outIce.
  ///
  /// In en, this message translates to:
  /// **'IN CASE OF EMERGENCY'**
  String get outIce;

  /// No description provided for @outMoreInfo.
  ///
  /// In en, this message translates to:
  /// **'MEDICAL INFO'**
  String get outMoreInfo;

  /// No description provided for @outBlood.
  ///
  /// In en, this message translates to:
  /// **'Blood'**
  String get outBlood;

  /// No description provided for @outAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get outAllergies;

  /// No description provided for @outConditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get outConditions;

  /// No description provided for @outMeds.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get outMeds;

  /// No description provided for @outCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get outCall;

  /// No description provided for @outDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get outDoctor;

  /// No description provided for @outDonor.
  ///
  /// In en, this message translates to:
  /// **'Organ donor'**
  String get outDonor;

  /// No description provided for @outNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get outNotes;

  /// No description provided for @outSos.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get outSos;

  /// No description provided for @outUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get outUpdated;

  /// No description provided for @outScan.
  ///
  /// In en, this message translates to:
  /// **'Scan for details'**
  String get outScan;

  /// No description provided for @outDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Details provided by the card holder. Not verified medical advice.'**
  String get outDisclaimer;

  /// No description provided for @wpLayout.
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get wpLayout;

  /// No description provided for @layoutQr.
  ///
  /// In en, this message translates to:
  /// **'QR only'**
  String get layoutQr;

  /// No description provided for @layoutDetails.
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get layoutDetails;

  /// No description provided for @layoutQrHint.
  ///
  /// In en, this message translates to:
  /// **'Your lock screen shows only “In case of emergency” and a QR. Scanning it reveals your details.'**
  String get layoutQrHint;

  /// No description provided for @wpBackground.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get wpBackground;

  /// No description provided for @stylePhoto.
  ///
  /// In en, this message translates to:
  /// **'My photo'**
  String get stylePhoto;

  /// No description provided for @styleSage.
  ///
  /// In en, this message translates to:
  /// **'Sage'**
  String get styleSage;

  /// No description provided for @styleRose.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get styleRose;

  /// No description provided for @styleSky.
  ///
  /// In en, this message translates to:
  /// **'Sky'**
  String get styleSky;

  /// No description provided for @addTile.
  ///
  /// In en, this message translates to:
  /// **'Also add to Quick Settings'**
  String get addTile;

  /// No description provided for @tileLabel.
  ///
  /// In en, this message translates to:
  /// **'Emergency QR'**
  String get tileLabel;

  /// No description provided for @tileManual.
  ///
  /// In en, this message translates to:
  /// **'Swipe down twice, tap ✎ edit, and drag “Emergency QR” in.'**
  String get tileManual;

  /// No description provided for @qrOpensAs.
  ///
  /// In en, this message translates to:
  /// **'When scanned, open as'**
  String get qrOpensAs;

  /// No description provided for @qrModeLink.
  ///
  /// In en, this message translates to:
  /// **'Clutch page'**
  String get qrModeLink;

  /// No description provided for @qrModeText.
  ///
  /// In en, this message translates to:
  /// **'Plain text'**
  String get qrModeText;

  /// No description provided for @qrModeLinkHint.
  ///
  /// In en, this message translates to:
  /// **'Opens a clean Clutch page with tap-to-call buttons. Needs internet on the scanner\'s phone. Your details live only inside the QR, never on a server.'**
  String get qrModeLinkHint;

  /// No description provided for @qrModeTextHint.
  ///
  /// In en, this message translates to:
  /// **'Works with no internet at all, but opens as plain text.'**
  String get qrModeTextHint;

  /// No description provided for @widgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency QR widget'**
  String get widgetTitle;

  /// No description provided for @widgetSub.
  ///
  /// In en, this message translates to:
  /// **'Puts your “In case of emergency” QR on your home screen, or your lock screen where your phone allows it. Tap it to show the QR full screen.'**
  String get widgetSub;

  /// No description provided for @addWidget.
  ///
  /// In en, this message translates to:
  /// **'Add widget'**
  String get addWidget;

  /// No description provided for @widgetLockHint.
  ///
  /// In en, this message translates to:
  /// **'Adds the QR to your home screen. On Pixel and other phones with lock screen widgets, you can add it there too. Samsung only allows its own widgets on the lock screen, so use the QR wallpaper or the Quick Settings tile.'**
  String get widgetLockHint;

  /// No description provided for @widgetManual.
  ///
  /// In en, this message translates to:
  /// **'Touch and hold your home screen → Widgets → Clutch.'**
  String get widgetManual;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'hi':
      {
        switch (locale.scriptCode) {
          case 'Latn':
            return AppLocalizationsHiLatn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
