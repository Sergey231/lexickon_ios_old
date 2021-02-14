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
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public enum Colors {
    public static let color = ColorAsset(name: "Color")
    public static let fireWord = ColorAsset(name: "fireWord")
    public static let fireWordBright = ColorAsset(name: "fireWordBright")
    public static let fireWordPale = ColorAsset(name: "fireWordPale")
    public static let newWord = ColorAsset(name: "newWord")
    public static let newWordBright = ColorAsset(name: "newWordBright")
    public static let readyWord = ColorAsset(name: "readyWord")
    public static let readyWordBright = ColorAsset(name: "readyWordBright")
    public static let readyWordPale = ColorAsset(name: "readyWordPale")
    public static let waitingWord = ColorAsset(name: "waitingWord")
    public static let waitingWordBright = ColorAsset(name: "waitingWordBright")
    public static let waitingWordPale = ColorAsset(name: "waitingWordPale")
    public static let baseText = ColorAsset(name: "baseText")
    public static let homeWordSectionHeaderBG = ColorAsset(name: "homeWordSectionHeaderBG")
    public static let mainBG = ColorAsset(name: "mainBG")
    public static let paleText = ColorAsset(name: "paleText")
    public static let placeholder = ColorAsset(name: "placeholder")
  }
  public enum Images {
    public static let backArrow = ImageAsset(name: "BackArrow")
    public static let imageLogo = ImageAsset(name: "ImageLogo")
    public static let logoWithoutEyes = ImageAsset(name: "LogoWithoutEyes")
    public static let textLogo = ImageAsset(name: "TextLogo")
    public static let art1 = ImageAsset(name: "art1")
    public static let art2 = ImageAsset(name: "art2")
    public static let art3 = ImageAsset(name: "art3")
    public static let background = ImageAsset(name: "background")
    public static let enter = ImageAsset(name: "enter")
    public static let splash = ImageAsset(name: "splash")
    public static let newWordIcon = ImageAsset(name: "NewWordIcon")
    public static let accountIcon = ImageAsset(name: "account_icon")
    public static let emailIcon = ImageAsset(name: "email_icon")
    public static let eyeHideIcon = ImageAsset(name: "eye_hide_icon")
    public static let eyeShowIcon = ImageAsset(name: "eye_show_icon")
    public static let lockIcon = ImageAsset(name: "lock_icon")
    public static let wordMustReapetIcon = ImageAsset(name: "WordMustReapetIcon")
    public enum WordRating {
      public static let arrow = ImageAsset(name: "WordRating/arrow")
      public static let scale = ImageAsset(name: "WordRating/scale")
    }
    public static let addIcon = ImageAsset(name: "addIcon")
    public static let bgStart = ImageAsset(name: "bgStart")
    public static let clear = ImageAsset(name: "clear")
    public static let plusIcon = ImageAsset(name: "plusIcon")
    public static let refresh = ImageAsset(name: "refresh")
    public static let searchIcon = ImageAsset(name: "searchIcon")
    public static let waitingWordIcon = ImageAsset(name: "waitingWordIcon")
  }
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

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

public extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
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
