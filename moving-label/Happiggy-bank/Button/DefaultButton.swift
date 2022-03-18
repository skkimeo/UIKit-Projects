//
//  DefaultButton.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/19.
//

import UIKit

class DefaultButton: UIButton {
    
    /// 버튼 프레임
    private var buttonFrame: CGRect = CGRect(
        x: 0,
        y: 0,
        width: Metric.buttonWidth,
        height: Metric.buttonHeight
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        let frame = CGRect(
            x: 0,
            y: 0,
            width: Metric.buttonWidth,
            height: Metric.buttonHeight
        )
        self.init(frame: frame)
    }
    
    /// 이미지 이름으로 초기화
    init(imageName: String) {
        super.init(frame: buttonFrame)
        
        let buttonImage = UIImage(
            systemName: imageName,
            withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        
        self.setImage(buttonImage, for: .normal)
    }
    
    /// 버튼 제목으로 초기화
    init(buttonTitle: String) {
        super.init(frame: buttonFrame)
        
        self.setTitle(buttonTitle, for: .normal)
        self.setTitleColor(.systemBlue, for: .normal)
        self.setTitleColor(.systemGray, for: .disabled)
        self.setTitleColor(.systemGray, for: .highlighted)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
