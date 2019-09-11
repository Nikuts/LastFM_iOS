//
//  BaseCollectionViewItem.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 10.09.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation
import UIKit

class BaseCollectionViewItem<T> {
    let value: T?
    let cellType: CollectionCellType
    
    init(value: T?, cellId: CollectionCellType) {
        self.value = value
        self.cellType = cellId
    }
}
