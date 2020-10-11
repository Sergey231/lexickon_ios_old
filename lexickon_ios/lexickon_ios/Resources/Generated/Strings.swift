// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// Оокей
  internal static let errorAlertButtonTitle = L10n.tr("Localizable", "Error_alert_button_title")
  /// Ошибка
  internal static let errorAlertTitle = L10n.tr("Localizable", "Error_alert_title")
  /// Войти
  internal static let loginLoginButtonTitle = L10n.tr("Localizable", "Login_login_button_title")
  /// У меня есть аккаунт
  internal static let loginScreenTitle = L10n.tr("Localizable", "Login_screen_title")
  /// Повторите пароль
  internal static let registrationConfirmPasswordTextfield = L10n.tr("Localizable", "Registration_confirm_password_textfield")
  /// Создать аккаут
  internal static let registrationCreateAccountTitle = L10n.tr("Localizable", "Registration_create_account_title")
  /// Email
  internal static let registrationEmailTextfield = L10n.tr("Localizable", "Registration_email_textfield")
  /// Не корректный email
  internal static let registrationIncorrectEmail = L10n.tr("Localizable", "Registration_incorrect_email")
  /// Не корректный имя пользователя
  internal static let registrationIncorrectName = L10n.tr("Localizable", "Registration_incorrect_name")
  /// Имя
  internal static let registrationNameTextfield = L10n.tr("Localizable", "Registration_name_textfield")
  /// Пароль должен содержать цифры
  internal static let registrationPasswordMustContainDigits = L10n.tr("Localizable", "Registration_password_must_contain_digits")
  /// Пароль должен содержать строчные символы
  internal static let registrationPasswordMustContainLowercaseCharacters = L10n.tr("Localizable", "Registration_password_must_contain_lowercase characters")
  /// Пароль должен содержать заглавные символы
  internal static let registrationPasswordMustContainUpercaseCharacters = L10n.tr("Localizable", "Registration_password_must_contain_upercase_characters")
  /// Пароль
  internal static let registrationPasswordTextfield = L10n.tr("Localizable", "Registration_password_textfield")
  /// Пароль слишком длинный
  internal static let registrationPasswordTooLong = L10n.tr("Localizable", "Registration_password_too_long")
  /// Пароль слишком короткий
  internal static let registrationPasswordTooShort = L10n.tr("Localizable", "Registration_password_too_short")
  /// НАЧАТЬ
  internal static let startBeginButtonTitle = L10n.tr("Localizable", "Start_begin_button_title")
  /// СОЗДАТЬ АККАУНТ
  internal static let startCreateAccountButtonTitle = L10n.tr("Localizable", "Start_create_account_button_title")
  /// У МЕНЯ ЕСТЬ АККАУНТ
  internal static let startIHaveAccountButtonTitle = L10n.tr("Localizable", "Start_i_have_account_button_title")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle = Bundle(for: BundleToken.self)
}
// swiftlint:enable convenience_type
