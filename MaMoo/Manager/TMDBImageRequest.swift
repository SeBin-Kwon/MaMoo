//
//  TMDBImageRequest.swift
//  MaMoo
//
//  Created by Sebin Kwon on 2/12/25.
//

import Foundation

enum TMDBImageRequest {
    case small(path: String)
    case big(path: String)
    
    var baseURL: String {
        return "https://image.tmdb.org/t/p/w"
    }
    
    var endPoint: URL {
        switch self {
        case .big(let path):
            return URL(string: baseURL + "500" + path)!
        case .small(let path):
            return URL(string: baseURL + "92" + path)!
        }
    }
}
