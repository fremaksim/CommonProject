//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 colors.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 2 files.
  struct file {
    /// Resource file `TelephoneNationalCode.json`.
    static let telephoneNationalCodeJson = Rswift.FileResource(bundle: R.hostingBundle, name: "TelephoneNationalCode", pathExtension: "json")
    /// Resource file `keep.mp4`.
    static let keepMp4 = Rswift.FileResource(bundle: R.hostingBundle, name: "keep", pathExtension: "mp4")
    
    /// `bundle.url(forResource: "TelephoneNationalCode", withExtension: "json")`
    static func telephoneNationalCodeJson(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.telephoneNationalCodeJson
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "keep", withExtension: "mp4")`
    static func keepMp4(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.keepMp4
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 13 images.
  struct image {
    /// Image `IMG_0777`.
    static let img_0777 = Rswift.ImageResource(bundle: R.hostingBundle, name: "IMG_0777")
    /// Image `IMG_0778`.
    static let img_0778 = Rswift.ImageResource(bundle: R.hostingBundle, name: "IMG_0778")
    /// Image `IMG_0779`.
    static let img_0779 = Rswift.ImageResource(bundle: R.hostingBundle, name: "IMG_0779")
    /// Image `IMG_0780`.
    static let img_0780 = Rswift.ImageResource(bundle: R.hostingBundle, name: "IMG_0780")
    /// Image `IMG_0781`.
    static let img_0781 = Rswift.ImageResource(bundle: R.hostingBundle, name: "IMG_0781")
    /// Image `IMG_0782`.
    static let img_0782 = Rswift.ImageResource(bundle: R.hostingBundle, name: "IMG_0782")
    /// Image `LaunchImage`.
    static let launchImage = Rswift.ImageResource(bundle: R.hostingBundle, name: "LaunchImage")
    /// Image `discovery`.
    static let discovery = Rswift.ImageResource(bundle: R.hostingBundle, name: "discovery")
    /// Image `generate`.
    static let generate = Rswift.ImageResource(bundle: R.hostingBundle, name: "generate")
    /// Image `home`.
    static let home = Rswift.ImageResource(bundle: R.hostingBundle, name: "home")
    /// Image `profile`.
    static let profile = Rswift.ImageResource(bundle: R.hostingBundle, name: "profile")
    /// Image `refresh`.
    static let refresh = Rswift.ImageResource(bundle: R.hostingBundle, name: "refresh")
    /// Image `scan_qrcode_icon`.
    static let scan_qrcode_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "scan_qrcode_icon")
    
    /// `UIImage(named: "IMG_0777", bundle: ..., traitCollection: ...)`
    static func img_0777(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.img_0777, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "IMG_0778", bundle: ..., traitCollection: ...)`
    static func img_0778(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.img_0778, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "IMG_0779", bundle: ..., traitCollection: ...)`
    static func img_0779(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.img_0779, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "IMG_0780", bundle: ..., traitCollection: ...)`
    static func img_0780(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.img_0780, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "IMG_0781", bundle: ..., traitCollection: ...)`
    static func img_0781(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.img_0781, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "IMG_0782", bundle: ..., traitCollection: ...)`
    static func img_0782(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.img_0782, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "LaunchImage", bundle: ..., traitCollection: ...)`
    static func launchImage(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.launchImage, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "discovery", bundle: ..., traitCollection: ...)`
    static func discovery(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.discovery, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "generate", bundle: ..., traitCollection: ...)`
    static func generate(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.generate, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "home", bundle: ..., traitCollection: ...)`
    static func home(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "profile", bundle: ..., traitCollection: ...)`
    static func profile(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.profile, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "refresh", bundle: ..., traitCollection: ...)`
    static func refresh(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.refresh, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "scan_qrcode_icon", bundle: ..., traitCollection: ...)`
    static func scan_qrcode_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.scan_qrcode_icon, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 0 nibs.
  struct nib {
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 0 reuse identifiers.
  struct reuseIdentifier {
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 0 view controllers.
  struct segue {
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      // There are no resources to validate
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R {
  struct nib {
    fileprivate init() {}
  }
  
  struct storyboard {
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let name = "Main"
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
