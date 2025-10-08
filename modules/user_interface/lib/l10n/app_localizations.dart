import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @allAppName.
  ///
  /// In en, this message translates to:
  /// **'Tu Aliado'**
  String get allAppName;

  /// No description provided for @messageOfflineMode.
  ///
  /// In en, this message translates to:
  /// **'Hubo un error de conexión'**
  String get messageOfflineMode;

  /// No description provided for @networkErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'No hay conexión a Internet. Asegúrate de que la conexión Wi-Fi o los datos móviles están activados e inténtalo de nuevo.'**
  String get networkErrorMessage;

  /// No description provided for @titleError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get titleError;

  /// No description provided for @messageErrorGeneral.
  ///
  /// In en, this message translates to:
  /// **'Algo ha ido mal al cargar tus datos, por favor inténtalo de nuevo más tarde.'**
  String get messageErrorGeneral;

  /// No description provided for @allClose.
  ///
  /// In en, this message translates to:
  /// **'Cerrar'**
  String get allClose;

  /// No description provided for @allOk.
  ///
  /// In en, this message translates to:
  /// **'Listo'**
  String get allOk;

  /// No description provided for @allAccept.
  ///
  /// In en, this message translates to:
  /// **'Aceptar'**
  String get allAccept;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Error de red'**
  String get networkError;

  /// No description provided for @createProspect.
  ///
  /// In en, this message translates to:
  /// **'Crear prospecto'**
  String get createProspect;

  /// No description provided for @createNewTracking.
  ///
  /// In en, this message translates to:
  /// **'Crear nuevo \n seguimiento'**
  String get createNewTracking;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Iniciar sesión'**
  String get login;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'Nombres'**
  String get firstName;

  /// No description provided for @middleName.
  ///
  /// In en, this message translates to:
  /// **'Segundo nombre'**
  String get middleName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Apellido'**
  String get lastName;

  /// No description provided for @secondLastName.
  ///
  /// In en, this message translates to:
  /// **'Segundo apellido'**
  String get secondLastName;

  /// No description provided for @neighborhood.
  ///
  /// In en, this message translates to:
  /// **'Barrio'**
  String get neighborhood;

  /// No description provided for @typeOfDocument.
  ///
  /// In en, this message translates to:
  /// **'Tipo de documento'**
  String get typeOfDocument;

  /// No description provided for @numberOfDocument.
  ///
  /// In en, this message translates to:
  /// **'Número de documento'**
  String get numberOfDocument;

  /// No description provided for @contactPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Télefono de contacto'**
  String get contactPhoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Fecha'**
  String get date;

  /// No description provided for @prospectusStatus.
  ///
  /// In en, this message translates to:
  /// **'Estado del prospecto'**
  String get prospectusStatus;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comentario'**
  String get comment;

  /// No description provided for @iDAdvisor.
  ///
  /// In en, this message translates to:
  /// **'ID Asesor'**
  String get iDAdvisor;

  /// No description provided for @valueToBeFinanced.
  ///
  /// In en, this message translates to:
  /// **'Valor a financiar'**
  String get valueToBeFinanced;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Dirección'**
  String get address;

  /// No description provided for @iDCompany.
  ///
  /// In en, this message translates to:
  /// **'ID Empresa'**
  String get iDCompany;

  /// No description provided for @addInfo.
  ///
  /// In en, this message translates to:
  /// **'Agrega tu información del prospecto'**
  String get addInfo;

  /// No description provided for @hintTextComment.
  ///
  /// In en, this message translates to:
  /// **'Deje sus notas aquí'**
  String get hintTextComment;

  /// No description provided for @hintTextValueNumber.
  ///
  /// In en, this message translates to:
  /// **'000000'**
  String get hintTextValueNumber;

  /// No description provided for @hintTextEmail.
  ///
  /// In en, this message translates to:
  /// **'usuario@example.com'**
  String get hintTextEmail;

  /// No description provided for @hintTextNumberOfDocument.
  ///
  /// In en, this message translates to:
  /// **'000000000000'**
  String get hintTextNumberOfDocument;

  /// No description provided for @hintTextName.
  ///
  /// In en, this message translates to:
  /// **'Jhon'**
  String get hintTextName;

  /// No description provided for @hintTextLastName.
  ///
  /// In en, this message translates to:
  /// **'Doe'**
  String get hintTextLastName;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Campo obligatorio'**
  String get requiredField;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Número inválido'**
  String get invalidNumber;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Teléfono inválido'**
  String get invalidPhoneNumber;

  /// No description provided for @invalidMail.
  ///
  /// In en, this message translates to:
  /// **'Correo inválido'**
  String get invalidMail;

  /// No description provided for @invalidID.
  ///
  /// In en, this message translates to:
  /// **'ID invalido'**
  String get invalidID;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Monto inválido'**
  String get invalidAmount;

  /// No description provided for @formContainsErrors.
  ///
  /// In en, this message translates to:
  /// **'El formulario contiene errores.'**
  String get formContainsErrors;

  /// No description provided for @prospectusCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Prospecto creado exitosamente'**
  String get prospectusCreatedSuccessfully;

  /// No description provided for @createTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Crear seguimiento'**
  String get createTrackingTitle;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Seleccionar fecha'**
  String get selectDate;

  /// No description provided for @effectiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Efectiva'**
  String get effectiveLabel;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Sí'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @idAdvisor.
  ///
  /// In en, this message translates to:
  /// **'Id asesor'**
  String get idAdvisor;

  /// No description provided for @idCard.
  ///
  /// In en, this message translates to:
  /// **'Cédula'**
  String get idCard;

  /// No description provided for @trackingCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Seguimiento creado exitosamente'**
  String get trackingCreatedSuccessfully;

  /// No description provided for @createTracking.
  ///
  /// In en, this message translates to:
  /// **'Crear seguimiento'**
  String get createTracking;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'Usuario'**
  String get user;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @requiredDate.
  ///
  /// In en, this message translates to:
  /// **'La fecha es obligatoria. Seleccione una opción válida'**
  String get requiredDate;

  String get IncomeValue;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
