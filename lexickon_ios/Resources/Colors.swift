// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Colors {
  public static let color = ColorAsset(name: "Color")
  public static let fireWord = ColorAsset(name: "fireWord")
  public static let fireWordBG = ColorAsset(name: "fireWordBG")
  public static let fireWordBright = ColorAsset(name: "fireWordBright")
  public static let fireWordPale = ColorAsset(name: "fireWordPale")
  public static let newWord = ColorAsset(name: "newWord")
  public static let newWordBG = ColorAsset(name: "newWordBG")
  public static let newWordBright = ColorAsset(name: "newWordBright")
  public static let readyWord = ColorAsset(name: "readyWord")
  public static let readyWordBright = ColorAsset(name: "readyWordBright")
  public static let readyWordPale = ColorAsset(name: "readyWordPale")
  public static let waitingWord = ColorAsset(name: "waitingWord")
  public static let waitingWordBG = ColorAsset(name: "waitingWordBG")
  public static let waitingWordBright = ColorAsset(name: "waitingWordBright")
  public static let waitingWordPale = ColorAsset(name: "waitingWordPale")
  public static let baseBG = ColorAsset(name: "baseBG")
  public static let baseText = ColorAsset(name: "baseText")
  public static let gold = ColorAsset(name: "gold")
  public static let mainBG = ColorAsset(name: "mainBG")
  public static let pale = ColorAsset(name: "pale")
  public static let paleText = ColorAsset(name: "paleText")
  public static let placeholder = ColorAsset(name: "placeholder")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
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
