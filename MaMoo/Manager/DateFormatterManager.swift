//
//  DateFormatterManager.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/28/25.
//

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() {}
    
    private let dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yy.MM.dd 가입"
        return format
    }()
    
    func dateFormatted(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
