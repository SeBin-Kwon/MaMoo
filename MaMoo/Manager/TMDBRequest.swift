//
//  TMDBRequest.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/27/25.
//

import Foundation
import Alamofire

enum TMDBRequest {
    case trending
    case search(value: SearchRequest)
    case detailImage(id: Int)
    case Credit(id: Int)
    
    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }
    
    var header: HTTPHeaders {
        return ["Authorization": APIKey.tmdb]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var endPoint: URL {
        switch self {
        case .trending:
            return URL(string: baseURL + "trending/movie/day?language=ko-KR&page=1")!
        case .search:
            return URL(string: baseURL + "search/movie")!
        case .detailImage(let id):
            return URL(string: baseURL + "movie/\(id)/images")!
        case .Credit(let id):
            return URL(string: baseURL + "movie/\(id)/credits")!
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .search(let value):
            let parameters = ["query": value.query, "page": String(value.page), "include_adult": "false", "language": "ko-KR"]
            return parameters
        case .Credit(let id):
            let parameters = ["language": "ko-KR"]
            return parameters
        default:
            return nil
        }
    }
}
