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
import RxCombine
import RxSwift

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
    
    private let enumerableTextFieldEvents = BehaviorSubject<EnumerableTextFieldEvent>(value: .none)
    private var disposables = [Disposable]()
    
    public func configureEnumerable(textFields: [EnumerableTextField]) -> [Disposable] {
        
        textFields.enumerated()
            .forEach ({
                
                let enumerableTextField = textFields[$0.offset]
                enumerableTextField.textField.tag = $0.offset
                
                let disposable = enumerableTextField.textField.returnPublisher
                    .asObservable()
                    .map {
                        
                        let currentIndex = enumerableTextField.textField.tag
                        let nextIndex = currentIndex + 1
                        
                        if nextIndex < textFields.count {
                            return .nextTextFieldIndex(nextIndex)
                        } else if nextIndex == textFields.count {
                            return .isLastTextFieldIndex(currentIndex)
                        }
                        return .none
                    }
                    .subscribe(onNext: {
                        self.enumerableTextFieldEvents.onNext($0)
                    })
                self.disposables.append(disposable)
            })
        
        let enumerableTextFieldDisposable = enumerableTextFieldEvents.asObservable()
            .subscribe(onNext: { event in
                switch event {
                case .nextTextFieldIndex(let index):
                    textFields[index].textField.becomeFirstResponder()
                case .isLastTextFieldIndex(let index):
                    textFields[index].textField.resignFirstResponder()
                case .none:
                    break
                }
            })
            
        disposables.append(enumerableTextFieldDisposable)
        
        return disposables
    }
}
