//
//  PointButton.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/29/24.
//

import UIKit

class PointButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .black
        layer.cornerRadius = 10
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
