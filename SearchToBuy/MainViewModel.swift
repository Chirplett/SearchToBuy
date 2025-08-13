//
//  MainViewModel.swift
//  SearchToBuy
//
//  Created by Jude Song on 8/13/25.
//

import Foundation

class MainViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        var text: Observable<String?> = Observable("")
    }
    
    struct Output {
        var textSuccess = Observable("")
        var textFail = Observable("")
    }
    
    init() {
        input = Input()
        output = Output()
        
        transform()
        
    }

//    init() {
//        
//        inputText.bind { _ in
//            self.submit()
//        }
//        
//    }
//    
    private func transform() {
        
        input.text.bind {_ in 
            self.submit()
        }
        
    }
    
    func submit() {
        
        guard let typedText = input.text.value, typedText.count >= 2 else {
            output.textFail.value = "두 글자 이상 입력해 주세요."
            return
        }
        output.textSuccess.value = typedText
    }
    
    
    
    
}
