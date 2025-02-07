//
//  Observable.swift
//  MaMoo
//
//  Created by Sebin Kwon on 2/7/25.
//

import Foundation

class Observable<T> {
    private var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ completionHandler: @escaping (T) -> Void) {
        completionHandler(value)
        closure = completionHandler
    }
    
    func lazyBind(_ completionHandler: @escaping (T) -> Void) {
        closure = completionHandler
    }
    
}
