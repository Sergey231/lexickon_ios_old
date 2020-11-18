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
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let fireWordProgress = ColorAsset(name: "fireWordProgress")
    internal static let fireWordProgressBG = ColorAsset(name: "fireWordProgressBG")
    internal static let mainBG = ColorAsset(name: "mainBG")
    internal static let newWordProgress = ColorAsset(name: "newWordProgress")
    internal static let readyWordProgress = ColorAsset(name: "readyWordProgress")
    internal static let readyWordProgressBG = ColorAsset(name: "readyWordProgressBG")
    internal static let waitingWordProgress = ColorAsset(name: "waitingWordProgress")
    internal static let waitingWordProgressBG = ColorAsset(name: "waitingWordProgressBG")
    internal static let whiteAlpha07 = ColorAsset(name: "whiteAlpha_07")
  }
  internal enum Images {
    internal static let backArrow = ImageAsset(name: "BackArrow")
    internal static let imageLogo = ImageAsset(name: "ImageLogo")
    internal static let logoWithoutEyes = ImageAsset(name: "LogoWithoutEyes")
    internal static let textLogo = ImageAsset(name: "TextLogo")
    internal static let art1 = ImageAsset(name: "art1")
    internal static let art2 = ImageAsset(name: "art2")
    internal static let art3 = ImageAsset(name: "art3")
    internal static let background = ImageAsset(name: "background")
    internal static let enter = ImageAsset(name: "enter")
    internal static let splash = ImageAsset(name: "splash")
    internal static let accountIcon = ImageAsset(name: "account_icon")
    internal static let emailIcon = ImageAsset(name: "email_icon")
    internal static let eyeHideIcon = ImageAsset(name: "eye_hide_icon")
    internal static let eyeShowIcon = ImageAsset(name: "eye_show_icon")
    internal static let lockIcon = ImageAsset(name: "lock_icon")
    internal static let bgStart = ImageAsset(name: "bgStart")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
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

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
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

internal extension ImageAsset.Image {
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
