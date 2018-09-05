//
//  UITableView+helpers.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 03/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import UIKit

extension UITableView {
    func animatedScrollToTop(_ duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.setContentOffset(CGPoint.zero, animated: false)
        })
    }
    
    func focus(on indexPath: IndexPath, duration: TimeInterval = 0.2, delay: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
            self.cellForRow(at: indexPath)?.becomeFirstResponder()
        }, completion: nil)
    }
}
