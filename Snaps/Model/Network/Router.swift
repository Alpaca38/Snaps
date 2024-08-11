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
        case .topic(let query):
            "topics/\(query.topicID)/photos"
        case .statistics(let query):
            "photos/\(query.imageID)/statistics"
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
                URLQueryItem(name: "client_id", value: query.client_id)
            ]
        case .random(let query):
            [
                URLQueryItem(name: "count", value: "\(query.count)"),
                URLQueryItem(name: "client_id", value: query.client_id)
            ]
        default:
            [
                URLQueryItem(name: "client_id", value: APIKey.unsplashAccessKey)
            ]
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
