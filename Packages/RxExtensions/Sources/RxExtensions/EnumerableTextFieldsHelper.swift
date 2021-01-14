//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 15.02.2020.
//

import UIKit
import RxSwift

public protocol EnumerableTextField {
    var textField: UITextField { get }
}

public class EnumerableTextFieldHelper: NSObject {
    
    public enum EnumerableTextFieldEvent {
        case nextTextFieldIndex(Int)
        case isLastTextFieldIndex(Int)
        case none
    }
    
    public override init(){}
    
    private let enumerableTextFieldEvents = BehaviorSubject<EnumerableTextFieldEvent>(value: .none)
    private var disposables = [Disposable]()
    
    public func configureEnumerable(
        textFields: [EnumerableTextField],
        canSubmit: Observable<Bool> = .just(true),
        returnKeyForSubmit: UIReturnKeyType = .join
    ) -> [Disposable] {
        
        textFields.enumerated()
            .forEach ({
                
                let enumerableTextField = textFields[$0.offset]
                enumerableTextField.textField.tag = $0.offset
                
                let disposable = enumerableTextField.textField.rx.returnDidTap
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
        
        let enumerableTextFieldDisposable = Observable.combineLatest(
            enumerableTextFieldEvents.asObservable(),
            canSubmit.startWith(false).asObservable()
        ) { (event: $0, canSubmit: $1) }
            .subscribe(onNext: {
                
                if !$0.canSubmit {
                    switch $0.event {
                    case .nextTextFieldIndex(let index):
                        textFields[index].textField.becomeFirstResponder()
                    case .isLastTextFieldIndex(let index):
                        textFields[index].textField.resignFirstResponder()
                    case .none:
                        break
                    }
                }
            })
        
        let setEnableReturnKeyDisposable = canSubmit
            .subscribe(onNext: {
                if $0 {
                    textFields.forEach { textField in
                        textField.textField.returnKeyType = returnKeyForSubmit
                    }
                } else {
                    textFields.forEach { textField in
                        let isLastTf = textField.textField.tag == (textFields.count - 1)
                        textField.textField.returnKeyType = isLastTf
                            ? returnKeyForSubmit
                            : .next
                    }
                }
            })
        
        disposables.append(contentsOf: [
            enumerableTextFieldDisposable,
            setEnableReturnKeyDisposable
        ])
        
        return disposables
    }
}
