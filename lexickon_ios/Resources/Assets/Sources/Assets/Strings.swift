// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
public enum Str {
  /// Оокей
  public static let errorAlertButtonTitle = Str.tr("Localizable", "Error_alert_button_title")
  /// Ошибка
  public static let errorAlertTitle = Str.tr("Localizable", "Error_alert_title")
  /// Необходимо срочно повторить
  public static let homeFireSectionTitle = Str.tr("Localizable", "Home_fire_section_title")
  /// Новые слова
  public static let homeNewSectionTitle = Str.tr("Localizable", "Home_new_section_title")
  /// Готовы к испытаниям
  public static let homeReadySectionTitle = Str.tr("Localizable", "Home_ready_section_title")
  /// Созревают...
  public static let homeWaitingSectionTitle = Str.tr("Localizable", "Home_waiting_section_title")
  /// Есть в Вашем Lexickon
  public static let inLexickonStateHas = Str.tr("Localizable", "InLexickonState_has")
  /// Нет в Вашем Lexickon
  public static let inLexickonStateHasnt = Str.tr("Localizable", "InLexickonState_hasnt")
  /// Войти
  public static let loginLoginButtonTitle = Str.tr("Localizable", "Login_login_button_title")
  /// У меня есть аккаунт
  public static let loginScreenTitle = Str.tr("Localizable", "Login_screen_title")
  /// Здесь, Вы можете добавить любое, новое слово в ваш Lexickon
  public static let newWrodPlaceholder = Str.tr("Localizable", "NewWrod_placeholder")
  /// Выйти
  public static let profileMainLogoutButtonTitle = Str.tr("Localizable", "Profile_main_logout_button_title")
  /// Повторите пароль
  public static let registrationConfirmPasswordTextfield = Str.tr("Localizable", "Registration_confirm_password_textfield")
  /// Создание аккаута
  public static let registrationCreateAccountTitle = Str.tr("Localizable", "Registration_create_account_title")
  /// Email
  public static let registrationEmailTextfield = Str.tr("Localizable", "Registration_email_textfield")
  /// Введите Email
  public static let registrationEnterEmail = Str.tr("Localizable", "Registration_enter_email")
  /// Ввидите имя
  public static let registrationEnterName = Str.tr("Localizable", "Registration_enter_name")
  /// Придумайте и запомните пароль
  public static let registrationEnterPassword = Str.tr("Localizable", "Registration_enter_password")
  /// Не корректный email
  public static let registrationIncorrectEmail = Str.tr("Localizable", "Registration_incorrect_email")
  /// Не корректный имя пользователя
  public static let registrationIncorrectName = Str.tr("Localizable", "Registration_incorrect_name")
  /// Имя
  public static let registrationNameTextfield = Str.tr("Localizable", "Registration_name_textfield")
  /// Имя слишком кородкое
  public static let registrationNameTooShort = Str.tr("Localizable", "Registration_name_too_short")
  /// Пароль должен содержать цифры
  public static let registrationPasswordMustContainDigits = Str.tr("Localizable", "Registration_password_must_contain_digits")
  /// Пароль должен содержать строчные символы
  public static let registrationPasswordMustContainLowercaseCharacters = Str.tr("Localizable", "Registration_password_must_contain_lowercase characters")
  /// Пароль должен содержать заглавные символы
  public static let registrationPasswordMustContainUpercaseCharacters = Str.tr("Localizable", "Registration_password_must_contain_upercase_characters")
  /// Пароль
  public static let registrationPasswordTextfield = Str.tr("Localizable", "Registration_password_textfield")
  /// Пароль слишком длинный
  public static let registrationPasswordTooLong = Str.tr("Localizable", "Registration_password_too_long")
  /// Пароль слишком короткий
  public static let registrationPasswordTooShort = Str.tr("Localizable", "Registration_password_too_short")
  /// СОЗДАТЬ АККАУНТ
  public static let registrationSubmitButtonTitle = Str.tr("Localizable", "Registration_submit_button_title")
  /// НАЧАТЬ
  public static let startBeginButtonTitle = Str.tr("Localizable", "Start_begin_button_title")
  /// СОЗДАТЬ АККАУНТ
  public static let startCreateAccountButtonTitle = Str.tr("Localizable", "Start_create_account_button_title")
  /// У МЕНЯ ЕСТЬ АККАУНТ
  public static let startIHaveAccountButtonTitle = Str.tr("Localizable", "Start_i_have_account_button_title")
  /// Удалить (%@)
  public static func wordsEditPanelDeleteTitle(_ p1: Any) -> String {
    return Str.tr("Localizable", "WordsEditPanelDeleteTitle", String(describing: p1))
  }
  /// Сбросить прогресс изучения (%@)
  public static func wordsEditPanelLearnTitle(_ p1: Any) -> String {
    return Str.tr("Localizable", "WordsEditPanelLearnTitle", String(describing: p1))
  }
  /// Закрепить (%@)
  public static func wordsEditPanelResetTitle(_ p1: Any) -> String {
    return Str.tr("Localizable", "WordsEditPanelResetTitle", String(describing: p1))
  }
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension Str {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
