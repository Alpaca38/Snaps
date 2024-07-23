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
    
    var baseURL: String {
        return "https://api.unsplash.com/"
    }
    
    var endpoint: URL? {
        switch self {
        case .search:
            return URL(string: baseURL + "search/photos")
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .search(let query, let page, let perPage, let orderBy):
            return ["query": query, "page": page, "per_page": perPage, "order_by": orderBy, "client_id": APIKey.unsplashAccessKey]
        }
    }
    
    var header: HTTPHeaders {
        return []
    }
    
    var method: HTTPMethod {
        return .get
    }
}
