//
//  UnderlineTextField.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 03/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import UIKit

class UnderlineTextField: UITextField {
    
    // MARK: Properties
    
    private weak var line: CAShapeLayer!
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLine()
    }
    
    // MARK: Configure
    
    private func configure() {
        let line = CAShapeLayer()
        layer.addSublayer(line)
        self.line = line
    }
    
    private func layoutLine() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: frame.size.height))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
        path.close()
        line.path = path.cgPath
        line.strokeColor = isFirstResponder ? tintColor.cgColor : UIColor.lightGray.cgColor
        line.lineWidth = isFirstResponder ? 2.0 : 1.0
    }
}
