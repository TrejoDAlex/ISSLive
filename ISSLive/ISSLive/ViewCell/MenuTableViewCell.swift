//
//  MenuTableViewCell.swift
//  ISSLive
//
//  Created by Alex on 07/02/22.
//

import Foundation
import UIKit

final class MenuTableViewCell: UITableViewCell {
    static var identifier: String { return String(describing: self) }
    @IBOutlet private weak var titleLabel: UILabel?
    
    func fillData(title: String) {
        backgroundColor = .clear
        titleLabel?.textColor = .white
        print("title, titleLabel", title, titleLabel)
        titleLabel?.text = title
    }
}
