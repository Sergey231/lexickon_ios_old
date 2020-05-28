//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 15.02.2020.
//

import Combine
import CombineCocoa
import UIKit
import TimelaneCombine

public protocol EnumerableTextField {
    var textField: UITextField { get }
}

public class EnumerableTextFieldHelper {
    
    public enum EnumerableTextFieldEvent {
        case nextTextFieldIndex(Int)
        case isLastTextFieldIndex(Int)
        case none
    }
    
    public init(){}
    
    @Published private var enumerableTextFieldEvents: EnumerableTextFieldEvent = .none
    
    public func configureEnumerable(textFields: [EnumerableTextField]) -> Set<AnyCancellable> {
        
        var cancellableSet = Set<AnyCancellable>()
        
        textFields.enumerated().forEach {
            
            let enumerableTextField = textFields[$0.offset]
            enumerableTextField.textField.tag = $0.offset

            enumerableTextField.textField.returnPublisher
                .map {
                    
                    let currentIndex = enumerableTextField.textField.tag
                    let nextIndex = currentIndex + 1
                    
                    if nextIndex < textFields.count {
                        return .nextTextFieldIndex(nextIndex)
                    } else if nextIndex == textFields.count {
                        return .isLastTextFieldIndex(currentIndex)
                    }
                    return .none
                }.lane("⚽️")
                .assign(to: \.enumerableTextFieldEvents, on: self)
                .store(in: &cancellableSet)
        }
        
        $enumerableTextFieldEvents
            .sink { event in
                switch event {
                case .nextTextFieldIndex(let index):
                    textFields[index].textField.becomeFirstResponder()
                case .isLastTextFieldIndex(let index):
                    textFields[index].textField.resignFirstResponder()
                case .none:
                    break
                }
            }
            .store(in: &cancellableSet)
        
        return cancellableSet
    }
}