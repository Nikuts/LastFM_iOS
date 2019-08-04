//
//  AlbumTableViewCell.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 04.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
