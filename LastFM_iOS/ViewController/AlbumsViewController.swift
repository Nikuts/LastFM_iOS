//
//  AlbumsViewController.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 02.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    internal var tableView: UITableView!
    internal var albums = [AlbumModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        registerCells()
    }

    internal func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
    }
    
    //    MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        return cell
    }
}
