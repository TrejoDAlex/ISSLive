//
//  Constant.swift
//  ISSLive
//
//  Created by Alex on 2/7/22.
//

import Foundation
import UIKit

struct Constant {
    // MARK: - ISS annotation
    static let issAnnotationTitle = "ISS"
    static let issMarker = "ISSMarker"
    static let issIcon = "spaceStation"
    static let issMarkerColor = UIColor(red: (69.0/255), green: (95.0/255), blue: (170.0/255), alpha: 1.0)
    // MARK: - Map
    static let mapZoom: Double = 4000000
    
    // Contains the values used in the LeftMenu
    struct Menu {
        static let menuId = "ISS"
    }
}
