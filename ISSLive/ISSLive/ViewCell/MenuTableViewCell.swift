//
//  MenuTableViewCell.swift
//  ISSLive
//
//  Created by Alex on 07/02/22.
//

import Foundation
import UIKit

final class MenuTableViewCell: UITableViewCell {
    class var identifier: String { return String(describing: self) }
    @IBOutlet private weak var titleLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .clear
    }
    
    func fillData(title: String) {
        titleLabel?.text = title
    }
}
