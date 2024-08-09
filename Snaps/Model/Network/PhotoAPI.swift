//
//  PhotoAPI.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import Foundation
import Alamofire

enum PhotoAPI {
    case search(query: String, page: Int, perPage: Int, orderBy: SortOrder.RawValue)
    case searchColor(query: String, page: Int, perPage: Int, orderBy: SortOrder.RawValue, color: PhotoColor.RawValue)
    case topic(topicID: String)
    case statistics(imageID: String)
    case random
    
    var baseURL: String {
        return "https://api.unsplash.com/"
    }
    
    var endpoint: URL? {
        switch self {
        case .search, .searchColor:
            return URL(string: baseURL + "search/photos")
        case .topic(let topicID):
            return URL(string: baseURL + "topics/\(topicID)/photos")
        case .statistics(let imageID):
            return URL(string: baseURL + "photos/\(imageID)/statistics")
        case .random:
            return URL(string: baseURL + "photos/random")
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .search(let query, let page, let perPage, let orderBy):
            return ["query": query, "page": page, "per_page": perPage, "order_by": orderBy, "client_id": APIKey.unsplashAccessKey]
        case .topic, .statistics:
            return ["client_id": APIKey.unsplashAccessKey]
        case .random:
            return ["count": 10, "client_id": APIKey.unsplashAccessKey]
        case .searchColor(let query, let page, let perPage, let orderBy, let color):
            return ["query": query, "page": page, "per_page": perPage, "order_by": orderBy, "color": color, "client_id": APIKey.unsplashAccessKey]
        }
    }
    
    var header: HTTPHeaders {
        return []
    }
    
    var method: HTTPMethod {
        return .get
    }
}
