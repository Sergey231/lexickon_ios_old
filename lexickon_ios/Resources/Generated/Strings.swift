// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum Localized {
  /// Повторите пароль
  internal static let registrationConfirmPasswordTextfield = Localized.tr("Localizable", "Registration_confirm_password_textfield")
  /// Создать аккаут
  internal static let registrationCreateAccountTitle = Localized.tr("Localizable", "Registration_create_account_title")
  /// Email
  internal static let registrationEmailTextfield = Localized.tr("Localizable", "Registration_email_textfield")
  /// Не корректный email
  internal static let registrationIncorrectEmail = Localized.tr("Localizable", "Registration_incorrect_email")
  /// Не корректный имя пользователя
  internal static let registrationIncorrectName = Localized.tr("Localizable", "Registration_incorrect_name")
  /// Имя
  internal static let registrationNameTextfield = Localized.tr("Localizable", "Registration_name_textfield")
  /// Пароль должен содержать цифры
  internal static let registrationPasswordMustContainDigits = Localized.tr("Localizable", "Registration_password_must_contain_digits")
  /// Пароль должен содержать строчные символы
  internal static let registrationPasswordMustContainLowercaseCharacters = Localized.tr("Localizable", "Registration_password_must_contain_lowercase characters")
  /// Пароль должен содержать заглавные символы
  internal static let registrationPasswordMustContainUpercaseCharacters = Localized.tr("Localizable", "Registration_password_must_contain_upercase_characters")
  /// Пароль
  internal static let registrationPasswordTextfield = Localized.tr("Localizable", "Registration_password_textfield")
  /// Пароль слишком длинный
  internal static let registrationPasswordTooLong = Localized.tr("Localizable", "Registration_password_too_long")
  /// Пароль слишком короткий
  internal static let registrationPasswordTooShort = Localized.tr("Localizable", "Registration_password_too_short")
  /// НАЧАТЬ
  internal static let startBeginButtonTitle = Localized.tr("Localizable", "Start_begin_button_title")
  /// СОЗДАТЬ АККАУНТ
  internal static let startCreateAccountButtonTitle = Localized.tr("Localizable", "Start_create_account_button_title")
  /// У МЕНЯ ЕСТЬ АККАУНТ
  internal static let startIHaveAccountButtonTitle = Localized.tr("Localizable", "Start_i_have_account_button_title")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension Localized {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
