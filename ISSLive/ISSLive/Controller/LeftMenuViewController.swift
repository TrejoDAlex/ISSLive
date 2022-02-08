//
//  LeftMenuViewController.swift
//  ISSLive
//
//  Created by Alex on 07/02/22.
//

import Foundation
import UIKit

final class LeftMenuViewController: UIViewController {
    @IBOutlet var leftMenuTableView: UITableView?
    let items: [String] = ["Home",
                           "Astronauts",
                           "Contact"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        leftMenuTableView?.delegate = self
        leftMenuTableView?.dataSource = self
        leftMenuTableView?.backgroundColor = #colorLiteral(red: 0.2365731597, green: 0.5239473581, blue: 0.1610234678, alpha: 1)
        leftMenuTableView?.separatorStyle = .none
        
        // Register TableView Cell
        // leftMenuTableView?.register(MenuTableViewCell(), forCellReuseIdentifier: MenuTableViewCell.identifier)
    }
    

    
}

extension LeftMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("MenuTableViewCell.description()", MenuTableViewCell.description())
        let title = items[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.description()) as? MenuTableViewCell {
            cell.fillData(title: title)
            return cell
        }
        return UITableViewCell()
    }
}

extension LeftMenuViewController: UITableViewDelegate {

}
