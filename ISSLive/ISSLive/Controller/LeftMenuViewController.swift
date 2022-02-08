//
//  LeftMenuViewController.swift
//  ISSLive
//
//  Created by Alex on 07/02/22.
//

import Foundation
import UIKit

protocol LeftMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

final class LeftMenuViewController: UIViewController {
    @IBOutlet private var leftMenuTableView: UITableView?
    var delegate: LeftMenuViewControllerDelegate?
    private let items: [String] = ["Home",
                                   "Log"]
    private let images: [String] = ["mapIcon",
                                   "logIcon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        leftMenuTableView?.delegate = self
        leftMenuTableView?.dataSource = self
        leftMenuTableView?.backgroundColor = #colorLiteral(red: 0.2857798934, green: 0.6398172975, blue: 0.6006788611, alpha: 1)
        leftMenuTableView?.separatorStyle = .none
        leftMenuTableView?.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        leftMenuTableView?.reloadData()
    }
}

extension LeftMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = items[indexPath.row]
        let image = images[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier,
                                                    for: indexPath) as? MenuTableViewCell {
            cell.fillData(title: title, image: image)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCell(indexPath.row)
    }
}

extension LeftMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
