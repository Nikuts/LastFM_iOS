//
//  BaseTableViewItem.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 10.09.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewItem<T> {
    let value: T?
    let cellType: TableCellType
    
    init(value: T?, cellId: TableCellType) {
        self.value = value
        self.cellType = cellId
    }
}
