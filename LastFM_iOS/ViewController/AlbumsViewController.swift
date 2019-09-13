//
//  AlbumsViewController.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 02.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController, UITableViewDelegate {
   
    internal var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = DEFAULT_ROW_HEIGHT
        self.view.addSubview(tableView)
        
        registerCells()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    internal func registerCells() {}
    
    private let DEFAULT_ROW_HEIGHT: CGFloat = 150
}
