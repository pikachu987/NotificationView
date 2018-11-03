//
//  Extensions+.swift
//  TestA
//
//  Created by Gwanho Kim on 03/11/2018.
//  Copyright © 2018 Gwanho Kim. All rights reserved.
//

import UIKit

extension UILabel {
    func height(_ width: CGFloat) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = self.numberOfLines
        label.text = self.text
        label.font = self.font
        label.sizeToFit()
        return label.frame.height
    }
}
