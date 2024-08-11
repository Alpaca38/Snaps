//
//  PhotoAPI.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import Foundation
import Alamofire

enum Router {
    case search(query: SearchQuery)
    case searchColor(query: SearchColorQuery)
    case topic(query: TopicQuery)
    case statistics(query: StatisticsQuery)
    case random(query: RandomQuery)
}

extension Router: TargetType {
    var baseURL: String {
        return "https://api.unsplash.com/"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .search, .searchColor:
            "search/photos"
        case .topic(let topicID):
            "topics/\(topicID)/photos"
        case .statistics(let imageID):
            "photos/\(imageID)/statistics"
        case .random:
            "photos/random"
        }
    }
    
    var header: [String : String] {
        [:]
    }
    
    var parameters: String? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .search(let query):
            [
                URLQueryItem(name: "query", value: query.query),
                URLQueryItem(name: "page", value: "\(query.page)"),
                URLQueryItem(name: "per_page", value: "\(query.per_page)"),
                URLQueryItem(name: "order_by", value: query.orderBy),
                URLQueryItem(name: "client_id", value: query.client_id)
            ]
        case .searchColor(let query):
            [
                URLQueryItem(name: "query", value: query.query),
                URLQueryItem(name: "page", value: "\(query.page)"),
                URLQueryItem(name: "per_page", value: "\(query.perPage)"),
                URLQueryItem(name: "order_by", value: query.orderBy),
                URLQueryItem(name: "color", value: query.color),
                URLQueryItem(name: "client_id", value: query.client_id),
            ]
        default:
            nil
        }
    }
    
    var body: Data? {
        switch self {
        case .search(let query):
            let enconder = JSONEncoder()
            return try? enconder.encode(query)
        case .searchColor(let query):
            let enconder = JSONEncoder()
            return try? enconder.encode(query)
        case .topic(let query):
            let enconder = JSONEncoder()
            return try? enconder.encode(query)
        case .statistics(let query):
            let enconder = JSONEncoder()
            return try? enconder.encode(query)
        case .random(let query):
            let enconder = JSONEncoder()
            return try? enconder.encode(query)
        }
    }
}

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

