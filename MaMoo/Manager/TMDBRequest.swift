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
//    case search(value: SearchRequest)
//    case detail(id: String)
//    case topic(value: TopicRequest)
    
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
//        case .search:
//            return URL(string: baseURL + "search/photos")!
//        case .detail(let id):
//            return URL(string: baseURL + "photos/\(id)/statistics")!
//        case .topic(let value):
//            return URL(string: baseURL + "topics/\(value.topic)/photos")!
        }
    }
    
//    var parameter: Parameters? {
//        switch self {
//        case .search(let value):
//            let orderBy = value.order ? "latest" : "relevant"
//            var parameters = ["query": value.query, "page": String(value.page), "order_by": orderBy]
//            if let color = value.color {
//                parameters["color"] = color
//            }
//            return parameters
//        case .detail:
//            return nil
//        case .topic(let value):
//            return ["page": String(value.page)]
//        }
//    }
}
