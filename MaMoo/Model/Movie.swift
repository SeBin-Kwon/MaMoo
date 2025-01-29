//
//  Movie.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/27/25.
//

import Foundation

struct Movie: Decodable {
    let page: Int
    let results: [MovieResults]
    let total_pages: Int
    let total_results: Int
}

struct MovieResults: Decodable {
    let id: Int
    let backdrop_path: String
    let title: String
    let overview: String
    let poster_path: String
    let genre_ids: [Int]
    let release_date: String
    let vote_average: Double
}
