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

// NotificationTextContainerView
class NotificationTextContainerView: UIView {
    
    // MARK: Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = nil
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = NotificationViewTheme.default.titleColor
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = nil
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = NotificationViewTheme.default.subtitleColor
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = nil
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = NotificationViewTheme.default.bodyColor
        label.numberOfLines = 2
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    // MARK: Private Properties
    private var labelWidth: CGFloat {
        var width = UIScreen.main.bounds.width - (2+12+6)*2
        if self.image != nil { width -= 52 }
        return width
    }
    
    // MARK: Properties
    
    var title: String? {
        set {
            self.titleLabel.text = newValue
            if let newValue = newValue, newValue != "" {
                self.titleLabel.constraints(identifierType: .height).first?.constant = self.titleLabel.height(self.labelWidth)
            } else {
                self.titleLabel.constraints(identifierType: .height).first?.constant = 0
            }
        }
        get {
            return self.titleLabel.text
        }
    }
    
    var subtitle: String? {
        set {
            self.subtitleLabel.text = newValue
            if let newValue = newValue, newValue != "" {
                self.subtitleLabel.constraints(identifierType: .height).first?.constant = self.subtitleLabel.height(self.labelWidth)
            } else {
                self.subtitleLabel.constraints(identifierType: .height).first?.constant = 0
            }
        }
        get {
            return self.subtitleLabel.text
        }
    }
    
    var body: String? {
        set {
            self.bodyLabel.text = newValue
            if let newValue = newValue, newValue != "" {
                self.bodyLabel.constraints(identifierType: .height).first?.constant = self.bodyLabel.height(self.labelWidth)
            } else {
                self.bodyLabel.constraints(identifierType: .height).first?.constant = 0
            }
        }
        get {
            return self.subtitleLabel.text
        }
    }
    
    var image: UIImage? {
        set {
            self.imageView.image = newValue
            self.title = self.titleLabel.text
            self.subtitle = self.subtitleLabel.text
            self.body = self.bodyLabel.text
            if newValue != nil {
                self.imageView.constraints(identifierType: .width).first?.constant = 40
                self.constraints(identifierType: .leading).first?.constant = 12
            } else {
                self.imageView.constraints(identifierType: .width).first?.constant = 0
                self.constraints(identifierType: .leading).first?.constant = 0
            }
        }
        get {
            return self.imageView.image
        }
    }
    
    var height: CGFloat {
        let height = (self.titleLabel.constraints(identifierType: .height).first?.constant ?? 0) +
            (self.subtitleLabel.constraints(identifierType: .height).first?.constant ?? 0) +
            (self.bodyLabel.constraints(identifierType: .height).first?.constant ?? 0)
        let imageHeight: CGFloat = self.image == nil ? 0 : 40
        return max(height, imageHeight)
    }
    
    var theme: NotificationViewTheme = .default {
        willSet {
            if let color = newValue.titleColor {
                self.titleLabel.textColor = color
            }
            if let color = newValue.subtitleColor {
                self.subtitleLabel.textColor = color
            }
            if let color = newValue.bodyColor {
                self.bodyLabel.textColor = color
            }
        }
    }
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initVars()
    }
    
    init() {
        super.init(frame: .zero)
        self.initVars()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAKR: Private Method
    
    private func initVars() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.subtitleLabel)
        self.addSubview(self.bodyLabel)
        self.addSubview(self.imageView)
        
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.titleLabel, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.imageView, attribute: .leading, relatedBy: .equal, toItem: self.titleLabel, attribute: .trailing, multiplier: 1, constant: 12).identifier(.leading),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .top, multiplier: 1, constant: 0)
        ])
        
        self.titleLabel.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 18).priority(900).identifier(.height))
        
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.subtitleLabel, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self.subtitleLabel, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self.subtitleLabel, attribute: .top, multiplier: 1, constant: 0)
        ])
        
        self.subtitleLabel.addConstraint(NSLayoutConstraint(item: self.subtitleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 18).priority(900).identifier(.height))
        
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.bodyLabel, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self.bodyLabel, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.subtitleLabel, attribute: .bottom, relatedBy: .equal, toItem: self.bodyLabel, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.bodyLabel, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        self.bodyLabel.addConstraint(NSLayoutConstraint(item: self.bodyLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 18).priority(900).identifier(.height))
        
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .lessThanOrEqual, toItem: self.imageView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self.imageView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.imageView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.imageView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        self.imageView.addConstraints([
            NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 40).identifier(.width),
            NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40).priority(900)
        ])
        
        self.image = self.imageView.image
    }
}
