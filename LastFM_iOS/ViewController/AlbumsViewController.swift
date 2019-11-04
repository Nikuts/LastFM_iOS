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
    
    internal struct Constants {
        static let DEFAULT_ROW_HEIGHT: CGFloat = 150
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = Constants.DEFAULT_ROW_HEIGHT
        self.view.addSubview(tableView)
        
        registerCells()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    internal func registerCells() {}
    
    // MARK: - Empty message
    
    internal func showEmptyMessage(message: String?) {
        
        if let unwrappedMessage = message {
        
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            let messageLabel = UILabel(frame: rect)
            messageLabel.text = unwrappedMessage
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
            messageLabel.sizeToFit()

            self.tableView.backgroundView = messageLabel;
        } else {
            self.tableView.backgroundView = nil
        }
        
        self.tableView.separatorStyle = .none;
    }
    
    internal func hideEmptyMessage() {
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
    }
    
    //MARK: - Ins and del of rows
    
    internal func insertRows(indexPaths: [IndexPath]) {
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPaths, with: .automatic)
        self.tableView.endUpdates()
    }
    
    internal func deleteRows(indexPaths: [IndexPath]) {
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: indexPaths, with: .automatic)
        self.tableView.endUpdates()
    }
}
