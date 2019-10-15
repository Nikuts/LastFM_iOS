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
    
    //    MARK: - Private constants
    private struct Constants {
        static let BASE_URL = "http://ws.audioscrobbler.com/2.0/"
        static let API_KEY = "2b610a43419cab706301a2e2371c348c"
        static let FORMAT = "json"
    }
    
    public static func getArtist(artistName: String, page: Int, completion: @escaping (APIArtistSearchModel?) -> Void) {
       
        let urlString = "\(Constants.BASE_URL)?" +
                            "method=artist.search&" +
                            "artist=\(artistName.replacingOccurrences(of: " ", with: "%20"))&" +
                            "api_key=\(Constants.API_KEY)&" +
                            "page=\(page)&" +
                            "format=\(Constants.FORMAT)"
        
        AF.request(urlString).responseData { response in
            parseResponseData(data: response, completion: completion)
        }
    }
    
    public static func getTopAlbums(mbid: String, page: Int, completion: @escaping (APITopAlbumsSearchModel?) -> Void) {
        let urlString = "\(Constants.BASE_URL)?" +
                            "method=artist.gettopalbums&" +
                            "mbid=\(mbid)&" +
                            "api_key=\(Constants.API_KEY)&" +
                            "page=\(page)&" +
                            "format=\(Constants.FORMAT)"
        
        AF.request(urlString).responseData { response in
            parseResponseData(data: response, completion: completion)
        }
    }
    
    public static func getAlbumInfo(mbid: String, completion: @escaping (APIAlbumInfoResultModel?) -> Void) {
        
        let urlString = "\(Constants.BASE_URL)?" +
            "method=album.getinfo&" +
            "mbid=\(mbid)&" +
            "api_key=\(Constants.API_KEY)&" +
            "format=\(Constants.FORMAT)"
        
        AF.request(urlString).responseData { response in
            parseResponseData(data: response, completion: completion)
        }
    }
    
    private static func parseResponseData<T: Codable>(data: AFDataResponse<Data>, completion: @escaping (T?) -> Void) {
        switch data.result {
            case let .success(value):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: value)
                    
                    completion(result)
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
