//
//  Bundle.ext.swift
//  Omni
//
//  Created by ahmetAltintop on 2.08.2024.
//

import Foundation

extension Bundle {
    static func setLanguage(_ language: String) {
          guard let originalBundle = objc_getClass("NSBundle") as? AnyClass else { return }

          let isValidLanguage = Bundle.main.path(forResource: language, ofType: "lproj") != nil
          let path = Bundle.main.path(forResource: isValidLanguage ? language : "en", ofType: "lproj") ?? ""

          object_setClass(Bundle.main, originalBundle)
          
          if let bundleClass = objc_getClass("NSBundle") as? AnyClass {
              object_setClass(Bundle.main, bundleClass)
              objc_setAssociatedObject(Bundle.main, "language", path, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
          }
      }
}
