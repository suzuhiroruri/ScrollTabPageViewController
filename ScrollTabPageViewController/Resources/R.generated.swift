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
  
  /// This `R.color` struct is generated, and contains static references to 0 color palettes.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 0 files.
  struct file {
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 1 images.
  struct image {
    /// Image `BAScoutDetailAboutScout`.
    static let bAScoutDetailAboutScout = Rswift.ImageResource(bundle: R.hostingBundle, name: "BAScoutDetailAboutScout")
    
    /// `UIImage(named: "BAScoutDetailAboutScout", bundle: ..., traitCollection: ...)`
    static func bAScoutDetailAboutScout(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.bAScoutDetailAboutScout, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 2 nibs.
  struct nib {
    /// Nib `BAScoutDetailBenefitCollectionCell`.
    static let bAScoutDetailBenefitCollectionCell = _R.nib._BAScoutDetailBenefitCollectionCell()
    /// Nib `BAScoutDetailMailView`.
    static let bAScoutDetailMailView = _R.nib._BAScoutDetailMailView()
    
    /// `UINib(name: "BAScoutDetailBenefitCollectionCell", in: bundle)`
    static func bAScoutDetailBenefitCollectionCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.bAScoutDetailBenefitCollectionCell)
    }
    
    /// `UINib(name: "BAScoutDetailMailView", in: bundle)`
    static func bAScoutDetailMailView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.bAScoutDetailMailView)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 1 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `bAScoutDetailBenefitCollectionCell`.
    static let bAScoutDetailBenefitCollectionCell: Rswift.ReuseIdentifier<BAScoutDetailBenefitCollectionCell> = Rswift.ReuseIdentifier(identifier: "bAScoutDetailBenefitCollectionCell")
    
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 1 view controllers.
  struct segue {
    /// This struct is generated for `BAJobListViewController`, and contains static references to 1 segues.
    struct bAJobListViewController {
      /// Segue identifier `BAScoutDetailJobBase`.
      static let bAScoutDetailJobBase: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, BAJobListViewController, BAScoutDetailJobBaseViewController> = Rswift.StoryboardSegueIdentifier(identifier: "BAScoutDetailJobBase")
      
      /// Optionally returns a typed version of segue `BAScoutDetailJobBase`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func bAScoutDetailJobBase(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, BAJobListViewController, BAScoutDetailJobBaseViewController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.bAJobListViewController.bAScoutDetailJobBase, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 5 storyboards.
  struct storyboard {
    /// Storyboard `BAJobList`.
    static let bAJobList = _R.storyboard.bAJobList()
    /// Storyboard `BAScoutDetailJobBase`.
    static let bAScoutDetailJobBase = _R.storyboard.bAScoutDetailJobBase()
    /// Storyboard `BAScoutDetailJobRequirementsViewController`.
    static let bAScoutDetailJobRequirementsViewController = _R.storyboard.bAScoutDetailJobRequirementsViewController()
    /// Storyboard `BAScoutDetailJobSelectionViewController`.
    static let bAScoutDetailJobSelectionViewController = _R.storyboard.bAScoutDetailJobSelectionViewController()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    
    /// `UIStoryboard(name: "BAJobList", bundle: ...)`
    static func bAJobList(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.bAJobList)
    }
    
    /// `UIStoryboard(name: "BAScoutDetailJobBase", bundle: ...)`
    static func bAScoutDetailJobBase(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.bAScoutDetailJobBase)
    }
    
    /// `UIStoryboard(name: "BAScoutDetailJobRequirementsViewController", bundle: ...)`
    static func bAScoutDetailJobRequirementsViewController(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.bAScoutDetailJobRequirementsViewController)
    }
    
    /// `UIStoryboard(name: "BAScoutDetailJobSelectionViewController", bundle: ...)`
    static func bAScoutDetailJobSelectionViewController(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.bAScoutDetailJobSelectionViewController)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
    try nib.validate()
  }
  
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _BAScoutDetailMailView.validate()
    }
    
    struct _BAScoutDetailBenefitCollectionCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = BAScoutDetailBenefitCollectionCell
      
      let bundle = R.hostingBundle
      let identifier = "bAScoutDetailBenefitCollectionCell"
      let name = "BAScoutDetailBenefitCollectionCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> BAScoutDetailBenefitCollectionCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? BAScoutDetailBenefitCollectionCell
      }
      
      fileprivate init() {}
    }
    
    struct _BAScoutDetailMailView: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "BAScoutDetailMailView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> BAScoutDetailMailView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? BAScoutDetailMailView
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "BAScoutDetailAboutScout", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'BAScoutDetailAboutScout' is used in nib 'BAScoutDetailMailView', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try bAScoutDetailJobRequirementsViewController.validate()
      try bAScoutDetailJobSelectionViewController.validate()
      try bAJobList.validate()
    }
    
    struct bAJobList: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let jobList = StoryboardViewControllerResource<BAJobListViewController>(identifier: "JobList")
      let name = "BAJobList"
      
      func jobList(_: Void = ()) -> BAJobListViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: jobList)
      }
      
      static func validate() throws {
        if _R.storyboard.bAJobList().jobList() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'jobList' could not be loaded from storyboard 'BAJobList' as 'BAJobListViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct bAScoutDetailJobBase: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = BAScoutDetailJobBaseViewController
      
      let bundle = R.hostingBundle
      let name = "BAScoutDetailJobBase"
      
      fileprivate init() {}
    }
    
    struct bAScoutDetailJobRequirementsViewController: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = BAScoutDetailJobRequirementsViewController
      
      let bAScoutDetailJobRequirementsViewController = StoryboardViewControllerResource<BAScoutDetailJobRequirementsViewController>(identifier: "BAScoutDetailJobRequirementsViewController")
      let bundle = R.hostingBundle
      let name = "BAScoutDetailJobRequirementsViewController"
      
      func bAScoutDetailJobRequirementsViewController(_: Void = ()) -> BAScoutDetailJobRequirementsViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: bAScoutDetailJobRequirementsViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.bAScoutDetailJobRequirementsViewController().bAScoutDetailJobRequirementsViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'bAScoutDetailJobRequirementsViewController' could not be loaded from storyboard 'BAScoutDetailJobRequirementsViewController' as 'BAScoutDetailJobRequirementsViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct bAScoutDetailJobSelectionViewController: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = BAScoutDetailJobSelectionViewController
      
      let bAScoutDetailJobSelectionViewController = StoryboardViewControllerResource<BAScoutDetailJobSelectionViewController>(identifier: "BAScoutDetailJobSelectionViewController")
      let bundle = R.hostingBundle
      let name = "BAScoutDetailJobSelectionViewController"
      
      func bAScoutDetailJobSelectionViewController(_: Void = ()) -> BAScoutDetailJobSelectionViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: bAScoutDetailJobSelectionViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.bAScoutDetailJobSelectionViewController().bAScoutDetailJobSelectionViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'bAScoutDetailJobSelectionViewController' could not be loaded from storyboard 'BAScoutDetailJobSelectionViewController' as 'BAScoutDetailJobSelectionViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
