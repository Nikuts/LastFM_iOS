//
//  NetworkProvider.swift
//  LastFM_iOS
//
//  Created by Nikkuts on 30.07.19.
//  Copyright © 2019 Nikkuts. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import UIKit

class NetworkProvider {
    
    public static func getArtistByName(artistName: String, page: Int, completion: @escaping (APIArtistSearchModel?) -> Void) {
       
        let urlString = "\(BASE_URL)?" +
                            "method=artist.search&" +
                            "artist=\(artistName)&" +
                            "api_key=\(API_KEY)&" +
                            "page=\(page)&" +
                            "format=\(FORMAT)"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case let .success(value):
                do {
                    let decoder = JSONDecoder()
                    let apiArtistSearch = try decoder.decode(APIArtistSearchModel.self, from: value)
                    
                    completion(apiArtistSearch)
                } catch let error {
                    debugPrint(error)
                    completion(nil)
                }
            case let .failure(error):
                debugPrint(error)
                completion(nil)
            }
        }
    }
    
    public static func loadImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        AF.request(imageUrl).responseImage { response in
            switch response.result {
            case .success(_):
                if let image = UIImage(data: response.data!, scale: 1.0) {
                    imageCache.add(image, withIdentifier: imageUrl)
                    completion(image)
                } else {
                    completion(nil)
                }
            case let .failure(error):
                debugPrint(error)
                completion(nil)
            }
        }
    }
    
    //    MARK: Private constants
    private static let BASE_URL = "http://ws.audioscrobbler.com/2.0/"
    private static let API_KEY = "2b610a43419cab706301a2e2371c348c"
    private static let FORMAT = "json"
    
    //    MARK: ImageCache
    private static let imageCache = AutoPurgingImageCache(memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)
}
