//
//  NetworkManager.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    private init() { }
    static let shared = NetworkManager()
    
    func getSearchPhotos(searchText: String, page: Int, orderBy: SortOrder.RawValue, completion: @escaping (Result<Photos, APIError>) -> Void) {
        do {
            let query = SearchQuery(query: searchText, page: page, per_page: 20, orderBy: orderBy)
            let request = try Router.search(query: query).asURLRequest()
            AF.request(request)
                .responseDecodable(of: Photos.self) { response in
                    switch response.result {
                    case .success(let success):
                        completion(.success(success))
                    case .failure(let error):
                        switch response.response?.statusCode {
                        case 400:
                            completion(.failure(.invalidRequestVariables))
                        case 401:
                            completion(.failure(.failedAuthentication))
                        case 403:
                            completion(.failure(.invalidReauest))
                        case 404:
                            completion(.failure(.invalidURL))
                        case 405:
                            completion(.failure(.invalidMethod))
                        case 408:
                            completion(.failure(.networkDelay))
                        case 429:
                            completion(.failure(.requestLimit))
                        case 500:
                            completion(.failure(.serverError))
                        default:
                            print(error)
                        }
                    }
                }
        } catch {
            print(error)
        }
    }
    
    func getSearchColorPhotos(searchText: String, page: Int, orderBy: SortOrder.RawValue, color: PhotoColor.RawValue, completion: @escaping (Result<Photos, APIError>) -> Void) {
        do {
            let query = SearchColorQuery(query: searchText, page: page, perPage: 20, orderBy: orderBy, color: color)
            let request = try Router.searchColor(query: query).asURLRequest()
            AF.request(request)
                .responseDecodable(of: Photos.self) { response in
                    switch response.result {
                    case .success(let success):
                        completion(.success(success))
                    case .failure(let error):
                        switch response.response?.statusCode {
                        case 400:
                            completion(.failure(.invalidRequestVariables))
                        case 401:
                            completion(.failure(.failedAuthentication))
                        case 403:
                            completion(.failure(.invalidReauest))
                        case 404:
                            completion(.failure(.invalidURL))
                        case 405:
                            completion(.failure(.invalidMethod))
                        case 408:
                            completion(.failure(.networkDelay))
                        case 429:
                            completion(.failure(.requestLimit))
                        case 500:
                            completion(.failure(.serverError))
                        default:
                            print(error)
                        }
                    }
                }
        } catch {
            print(error)
        }
    }
    
    func getTopicPhotos(topicID: String, completion: @escaping (Result<[PhotoItem], APIError>) -> Void) {
        do {
            let query = TopicQuery(topicID: topicID)
            let request = try Router.topic(query: query).asURLRequest()
            AF.request(request)
                .responseDecodable(of: [PhotoItem].self) { response in
                    switch response.result {
                    case .success(let success):
                        completion(.success(success))
                    case .failure(let error):
                        switch response.response?.statusCode {
                        case 400:
                            completion(.failure(.invalidRequestVariables))
                        case 401:
                            completion(.failure(.failedAuthentication))
                        case 403:
                            completion(.failure(.invalidReauest))
                        case 404:
                            completion(.failure(.invalidURL))
                        case 405:
                            completion(.failure(.invalidMethod))
                        case 408:
                            completion(.failure(.networkDelay))
                        case 429:
                            completion(.failure(.requestLimit))
                        case 500:
                            completion(.failure(.serverError))
                        default:
                            print(error)
                        }
                    }
                }
        } catch {
            print(error)
        }
    }
    
    func getStatistics(imageID: String, completion: @escaping (Result<Statistics, APIError>) -> Void) {
        do {
            let query = StatisticsQuery(imageID: imageID)
            let request = try Router.statistics(query: query).asURLRequest()
            AF.request(request)
                .responseDecodable(of: Statistics.self) { response in
                    switch response.result {
                    case .success(let success):
                        completion(.success(success))
                    case .failure(let error):
                        switch response.response?.statusCode {
                        case 400:
                            completion(.failure(.invalidRequestVariables))
                        case 401:
                            completion(.failure(.failedAuthentication))
                        case 403:
                            completion(.failure(.invalidReauest))
                        case 404:
                            completion(.failure(.invalidURL))
                        case 405:
                            completion(.failure(.invalidMethod))
                        case 408:
                            completion(.failure(.networkDelay))
                        case 429:
                            completion(.failure(.requestLimit))
                        case 500:
                            completion(.failure(.serverError))
                        default:
                            print(error)
                        }
                    }
                }
        } catch {
            print(error)
        }
    }
    
    func getRandomPhotos(completion: @escaping (Result<[PhotoItem], APIError>) -> Void) {
        do {
            let query = RandomQuery(count: 10)
            let request = try Router.random(query: query).asURLRequest()
            AF.request(request)
                .responseDecodable(of: [PhotoItem].self) { response in
                    switch response.result {
                    case .success(let success):
                        completion(.success(success))
                    case .failure(let error):
                        switch response.response?.statusCode {
                        case 400:
                            completion(.failure(.invalidRequestVariables))
                        case 401:
                            completion(.failure(.failedAuthentication))
                        case 403:
                            completion(.failure(.invalidReauest))
                        case 404:
                            completion(.failure(.invalidURL))
                        case 405:
                            completion(.failure(.invalidMethod))
                        case 408:
                            completion(.failure(.networkDelay))
                        case 429:
                            completion(.failure(.requestLimit))
                        case 500:
                            completion(.failure(.serverError))
                        default:
                            print(error)
                        }
                    }
                }
        } catch {
            print(error)
        }
    }
}
        
