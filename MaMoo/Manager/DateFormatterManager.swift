//
//  DateFormatterManager.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/28/25.
//

import Foundation

final class DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() {}
    
    private let dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yy.MM.dd"
        return format
    }()
    
    func dateFormatted(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func dateChanged(_ str: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date ?? Date())
    }
}
