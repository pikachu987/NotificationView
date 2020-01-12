//Copyright (c) 2018 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

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

extension NSLayoutConstraint {
    enum Identifier: String {
        case top = "top"
        case bottom = "bottom"
        case leading = "leading"
        case trailing = "trailing"
        case centerX = "centerX"
        case centerY = "centerY"
        case left = "left"
        case right = "right"
        case width = "width"
        case height = "height"
    }
    
    @discardableResult
    func priority(_ rawValue: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(rawValue)
        return self
    }
    
    @discardableResult
    func identifier(_ identifier: String) -> NSLayoutConstraint {
        self.identifier = identifier
        return self
    }
    
    @discardableResult
    func identifier(_ identifier: Identifier) -> NSLayoutConstraint {
        self.identifier = identifier.rawValue
        return self
    }
    
    func equalIdentifier(_ identifier: String) -> Bool {
        guard let value = self.identifier else { return false }
        return value == identifier
    }
    
    func equalIdentifier(_ identifier: Identifier) -> Bool {
        guard let value = self.identifier else { return false }
        return value == identifier.rawValue
    }
}

extension UIView {
    @discardableResult
    func removeConstraint(_ identifier: String) -> NSLayoutConstraint? {
        if let constraint = self.constraints.identifier(identifier) {
            self.removeConstraint(constraint)
            return constraint
        } else {
            return nil
        }
    }
    
    @discardableResult
    func removeConstraint(_ identifier: NSLayoutConstraint.Identifier) -> NSLayoutConstraint? {
        if let constraint = self.constraints.identifier(identifier) {
            self.removeConstraint(constraint)
            return constraint
        } else {
           return nil
       }
    }
    
    func constraints(identifierType: NSLayoutConstraint.Identifier) -> [NSLayoutConstraint] {
        return self.constraints(identifier: identifierType.rawValue)
    }
    
    func constraints(identifier: String) -> [NSLayoutConstraint] {
        let constraint = self.constraints.compactMap { (constraint) -> NSLayoutConstraint? in
            guard let constraintIdentifier = constraint.identifier, constraintIdentifier == identifier else { return nil }
            return constraint
        }
        return constraint
    }
}

extension Array where Element == NSLayoutConstraint {
    func identifier(_ identifier: String) -> NSLayoutConstraint? {
        return self.filter({ $0.equalIdentifier(identifier) }).first
    }
    
    func identifier(_ identifier: NSLayoutConstraint.Identifier) -> NSLayoutConstraint? {
        return self.filter({ $0.equalIdentifier(identifier) }).first
    }
}
