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
    case goldenHour
    case businessAndWork
    case architectureAndInterior
    case statistics(imageID: String)
    
    var baseURL: String {
        return "https://api.unsplash.com/"
    }
    
    var endpoint: URL? {
        switch self {
        case .search:
            return URL(string: baseURL + "search/photos")
        case .goldenHour:
            return URL(string: baseURL + "topics/golden-hour/photos")
        case .businessAndWork:
            return URL(string: baseURL + "topics/business-work/photos")
        case .architectureAndInterior:
            return URL(string: baseURL + "topics/architecture-interior/photos")
        case .statistics(let imageID):
            return URL(string: baseURL + "photos/\(imageID)/statistics")
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .search(let query, let page, let perPage, let orderBy):
            return ["query": query, "page": page, "per_page": perPage, "order_by": orderBy, "client_id": APIKey.unsplashAccessKey]
        case .goldenHour, .businessAndWork, .architectureAndInterior, .statistics:
            return ["client_id": APIKey.unsplashAccessKey]
        }
    }
    
    var header: HTTPHeaders {
        return []
    }
    
    var method: HTTPMethod {
        return .get
    }
}
