//
//  AlbumDetailViewController.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 05.08.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import UIKit

class AlbumInfoViewController: UIViewController {

    var album : AlbumModel?
    var albumInfo : AlbumInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.album != nil) {
            NetworkProvider.getAlbumInfoByMbid(mbid: album!.mbid) { apiAlbumInfoResultModel in
                if let apiAlbumInfoModel = apiAlbumInfoResultModel?.album {
                    self.albumInfo = APIToBusinessModelMapper.mapAlbumInfo(apiAlbumInfoModel: apiAlbumInfoModel)
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
