//
//  Constant.swift
//  ISSLive
//
//  Created by Alex on 2/7/22.
//

import Foundation
import UIKit
import MapKit

struct Constant {
    struct Common {
        static let iss = "ISS"
        static let currentLocation = CLLocationCoordinate2D(latitude: 19.01999992, longitude: -98.62333084)
    }
    /// Contains the values used in the MainViewController.
    struct Main {
        static let navId = "Main"
    }
    /// Contains the values used in the MenuViewController.
    struct Menu {
        static let navId = "LeftMenuId"
    }
    /// Contains the values used in HomeViewController.
    struct Home {
        static let issAnnotationTitle = "ISS"
        static let issMarker = "ISSMarker"
        static let issIcon = "spaceStation"
        static let issMarkerColor = UIColor(red: (69.0/255), green: (95.0/255), blue: (170.0/255), alpha: 1.0)
        static let mapZoom: Double = 4000000
        static let navId = "HomeNavId"
        static let entityName = "Location"
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
    }
    /// Contains the values used in LocationsLogViewController.
    struct Logs {
        static let navTitle = "Logs"
        static let navId = "LogsId"
    }
}
