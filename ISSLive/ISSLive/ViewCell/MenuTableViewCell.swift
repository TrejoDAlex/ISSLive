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
    @IBOutlet private weak var itemImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        titleLabel?.textColor = .white
    }
    
    func fillData(title: String, image: String) {
        titleLabel?.text = title
        itemImageView?.image = UIImage(named: image)
    }
}
