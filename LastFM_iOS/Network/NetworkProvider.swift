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
                            "artist=\(artistName.replacingOccurrences(of: " ", with: "%20"))&" +
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
    
    public static func getTopAlbumsByMbid(mbid: String, page: Int, completion: @escaping (APITopAlbumsSearchModel?) -> Void) {
        let urlString = "\(BASE_URL)?" +
                            "method=artist.gettopalbums&" +
                            "mbid=\(mbid)&" +
                            "api_key=\(API_KEY)&" +
                            "page=\(page)&" +
                            "format=\(FORMAT)"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case let .success(value):
                do {
                    let decoder = JSONDecoder()
                    let apiTopAlbumsSearch = try decoder.decode(APITopAlbumsSearchModel.self, from: value)
                    
                    completion(apiTopAlbumsSearch)
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
    
    public static func getAlbumInfoByMbid(mbid: String, completion: @escaping (APIAlbumInfoResultModel?) -> Void) {
        
        let urlString = "\(BASE_URL)?" +
            "method=album.getinfo&" +
            "mbid=\(mbid)&" +
            "api_key=\(API_KEY)&" +
            "format=\(FORMAT)"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case let .success(value):
                do {
                    let decoder = JSONDecoder()
                    let apiAlbumInfoResult = try decoder.decode(APIAlbumInfoResultModel.self, from: value)
                    
                    completion(apiAlbumInfoResult)
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
    
    //    MARK: Private constants
    private static let BASE_URL = "http://ws.audioscrobbler.com/2.0/"
    private static let API_KEY = "2b610a43419cab706301a2e2371c348c"
    private static let FORMAT = "json"
}
