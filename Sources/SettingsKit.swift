//
//  SettingsKit.swift
//  About
//
//  Created by Dan Trenz on 2/25/16.
//  Copyright © 2016 Dan Trenz. All rights reserved.
//

import Foundation

/**
*  Protocol for the SettingsKit enum
*/
public protocol SettingsKit: CustomStringConvertible {
    var rawValue: String { get }
}

// SettingsKit enum extension (a/k/a "where the magic happens")
public extension SettingsKit {

  /// Convenience typealias for subscribe() onChange closure
    typealias SettingChangeHandler = (_ newValue: AnyObject?) -> Void

  /// String description of the enum value
    var description: String {
    guard let value = Self.get(self) else { return "nil" }

    return "\(value)"
  }

  /// Local defaults reference
  fileprivate var defaults: UserDefaults { return UserDefaults.standard }


  // MARK: - Static Convenience Methods

  /**
  Fetch the current value for a given setting.

  - Parameter setting: The setting to fetch

  - Returns: The current setting value
  */
    static func get(_ setting: Self) -> AnyObject? {
    return setting.get()
  }

  /**
   Update the value of a given setting.

   - Parameters:
     - setting: The setting to update
     - value:   The value to store for the setting
   */
    static func set<T>(_ setting: Self, _ value: T) {
    setting.set(value)
  }

  /**
   Observe a given setting for changes. The `onChange` closure will be called,
   with the new setting value, whenever the setting value is changed either
   by the user, or progammatically.

   - Parameters:
     - setting:  The setting to observe
     - onChange: The closure to call when the setting's value is updated
   */
    static func subscribe(_ setting: Self, onChange: @escaping SettingChangeHandler) {
    setting.subscribe(onChange)
  }

  // MARK: - Instance Methods

  /**
  Fetch the current value for a given setting.
  
  __This is the instance method that is called by the static convenience method
  in the public API.__
  
  - Returns: The current setting value
  */
  fileprivate func get() -> AnyObject? {
    return defaults.object(forKey: rawValue) as AnyObject?
  }
  
  /**
   Update the value of a given setting.
   
   > This is the instance method that is called by the static convenience method
   in the public API.
   
   - Parameter value: The value to store for the setting
   */
  fileprivate func set<T>(_ value: T) {
    if let boolVal = value as? Bool {
      defaults.set(boolVal, forKey: rawValue)
    } else if let intVal = value as? Int {
      defaults.set(intVal, forKey: rawValue)
    } else {
      defaults.set(value, forKey: rawValue)
    }
  }
  
  
  /**
   Observe a given setting for changes. The `onChange` closure will be called,
   with the new setting value, whenever the setting value is changed either
   by the user, or progammatically.
   
   > This is the instance method that is called by the static convenience method
   in the public API.
   
   - Parameter onChange: The closure to call when the setting's value is updated
   */
  fileprivate func subscribe(_ onChange: @escaping SettingChangeHandler) {
    let center = NotificationCenter.default

    center.addObserver(forName: UserDefaults.didChangeNotification, object: defaults, queue: nil) { (notif) -> Void in
      if let defaults = notif.object as? UserDefaults {
        onChange(defaults.object(forKey: self.rawValue) as AnyObject?)
      }
    }
  }

}
