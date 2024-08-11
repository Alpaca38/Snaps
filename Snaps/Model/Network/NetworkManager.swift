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
            let query = SearchQuery(query: searchText, page: page, per_page: 20, orderBy: orderBy, client_id: APIKey.unsplashAccessKey)
            let request = try Router.search(query: query).asURLRequest()
            AF.request(request)
                .responseDecodable(of: Photos.self) { response in
                    switch response.result {
                    case .success(let success):
                        completion(.success(success))
                    case .failure(_):
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
                            print("unknown error")
                        }
                    }
                }
        } catch {
            print(error)
        }
    }
    
    func getPhotoData<T: Decodable>(api: PhotoAPI, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = api.endpoint else { return }
        AF.request(url,
                   method: api.method,
                   parameters: api.parameter,
                   encoding: URLEncoding(destination: .queryString)
        ).responseDecodable(of: responseType) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(_):
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
                    print("unknown error")
                }
            }
        }
    }
}
        
