//
//  Observable.swift
//  SearchToBuy
//
//  Created by Jude Song on 8/13/25.
//

import Foundation

class Observable<T> {
    
    var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func lazyBind(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
    
    func bind(closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
}
