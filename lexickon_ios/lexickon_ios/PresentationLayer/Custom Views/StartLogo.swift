//
//  StartLogo.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 31.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SwiftUI

final class StartLogo: UIView {
    
    private let logoImageView = UIImageView()
    private let textLogoImageView = UIImageView()
    
    //MARK: init programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    //MAEK: init from XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoImageView.pin
            .size(100)
            .center()
        
        textLogoImageView.pin
            .hCenter()
            .height(80)
            .width(200)
            .below(of: logoImageView)
    }

    private func configureView() {
        createUI()
        configureUI()
    }
    
    private func createUI() {
        addSubviews(
            logoImageView,
            textLogoImageView
        )
    }
    
    private func configureUI() {
        backgroundColor = .gray
        logoImageView.image = Asset.Images.imageLogo.image
        logoImageView.contentMode = .scaleAspectFit
        textLogoImageView.image = Asset.Images.textLogo.image
        textLogoImageView.contentMode = .scaleAspectFit
    }
}

extension StartLogo: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return StartLogo()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct StartLogo_Preview: PreviewProvider {
    static var previews: some View {
        StartLogo()
    }
}
