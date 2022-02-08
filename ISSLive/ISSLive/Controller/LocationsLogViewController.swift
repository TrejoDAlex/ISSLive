//
//  LocationsLogViewController.swift
//  ISSLive
//
//  Created by Alex on 2/7/22.
//

import Foundation
import UIKit
import CoreData

/// Manages the table that displays the ISS locations history.
final class LocationsLogViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var locations: [NSManagedObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
}

extension LocationsLogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowNum = locations?.count else { return 0 }
        return rowNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)
        
        guard let log = locations else { return cell }
        if let latitude = log[indexPath.row].value(forKey: "latitude"),
           let longitude = log[indexPath.row].value(forKey: "longitude") {
            tableView.largeContentTitle = "ISSLive"
            cell.textLabel?.text = "Latitude: \(latitude), Longitude: \(longitude)"
        }
     
        return cell
    }
}
