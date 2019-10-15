//
//  LoadingTableViewCell.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 09.09.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
    }
}
