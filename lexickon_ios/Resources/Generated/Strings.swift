// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum Localized {
  /// Создать аккаут
  internal static let registrationCreateAccountTitle = Localized.tr("Localizable", "Registration_create_account_title")
  /// Email
  internal static let registrationEmailTextfield = Localized.tr("Localizable", "Registration_email_textfield")
  /// Имя
  internal static let registrationNameTextfield = Localized.tr("Localizable", "Registration_name_textfield")
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
