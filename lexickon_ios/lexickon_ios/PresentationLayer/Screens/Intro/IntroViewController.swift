//
//  IntroViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import PinLayout
import SwiftUI
import CombineCocoa
import UIExtensions
import Combine

final class IntroViewController: UIViewController {
    
    var index = 0
    var image: UIImage!
    var isLast: Bool = false
    var onGoMarvel: CompletionBlock?
    
    private let imageView = UIImageView()
    private let pageControl = UIPageControl()
    private let goMarvelButton = UIButton()
    
    private var cancellableSet = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        imageView.pin
            .all()
                
        pageControl.pin
            .bottom(32)
            .height(40)
            .horizontally(16)
        
        goMarvelButton.pin
            .hCenter()
            .height(66)
            .width(162)
            .above(of: pageControl)
            .margin(16)
    }
    
    private func createUI() {
        view.addSubviews([
            imageView,
            pageControl,
            goMarvelButton
        ])
    }
    
    private func configureUI() {
        DispatchQueue.main.async { [unowned self] in
            self.imageView.image = self.image
        }
        pageControl.numberOfPages = 3
        pageControl.currentPage = index
        goMarvelButton.isHidden = !isLast
        goMarvelButton.setTitle("GO MARVEL", for: .normal)
        // Buttons
        goMarvelButton.tapPublisher.sink { _ in
            self.onGoMarvel?()
        }.store(in: &cancellableSet)
    }
}
