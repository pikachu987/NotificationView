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
    
    // MARK: Lazy Properties
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: label, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self.imageView, attribute: .leading, relatedBy: .equal, toItem: label, attribute: .trailing, multiplier: 1, constant: 12)
        self.titleTrailingHeightConstriant = trailingConstraint
        self.addConstraints([
            leadingConstraint, trailingConstraint, topConstraint
            ])
        let heightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 18)
        heightConstraint.priority = UILayoutPriority(900)
        self.titleHeightConstriant = heightConstraint
        label.addConstraint(heightConstraint)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: label, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: label, attribute: .trailing, multiplier: 1, constant: 0)
        self.addConstraints([
            leadingConstraint, trailingConstraint, topConstraint
            ])
        let heightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 18)
        heightConstraint.priority = UILayoutPriority(900)
        self.subtitleHeightConstriant = heightConstraint
        label.addConstraint(heightConstraint)
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self.subtitleLabel, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: label, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: label, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([
            leadingConstraint, trailingConstraint, topConstraint, bottomConstraint
            ])
        let heightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 18)
        heightConstraint.priority = UILayoutPriority(900)
        self.bodyHeightConstriant = heightConstraint
        label.addConstraint(heightConstraint)
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .lessThanOrEqual, toItem: imageView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: imageView, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraints([
            topConstraint, bottomConstraint, trailingConstraint, centerYConstraint
            ])
        
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 40)
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40)
        heightConstraint.priority = UILayoutPriority(900)
        imageView.addConstraints([widthConstraint, heightConstraint])
        self.imageWidthHeightConstriant = widthConstraint
        return imageView
    }()
    
    
    // MARK: Private Properties
    
    private var titleHeightConstriant: NSLayoutConstraint?
    
    private var subtitleHeightConstriant: NSLayoutConstraint?
    
    private var bodyHeightConstriant: NSLayoutConstraint?
    
    private var titleTrailingHeightConstriant: NSLayoutConstraint?
    
    private var imageWidthHeightConstriant: NSLayoutConstraint?
    
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
                self.titleHeightConstriant?.constant = self.titleLabel.height(self.labelWidth)
            } else {
                self.titleHeightConstriant?.constant = 0
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
                self.subtitleHeightConstriant?.constant = self.subtitleLabel.height(self.labelWidth)
            } else {
                self.subtitleHeightConstriant?.constant = 0
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
                self.bodyHeightConstriant?.constant = self.bodyLabel.height(self.labelWidth)
            } else {
                self.bodyHeightConstriant?.constant = 0
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
                self.titleTrailingHeightConstriant?.constant = 12
                self.imageWidthHeightConstriant?.constant = 40
            } else {
                self.titleTrailingHeightConstriant?.constant = 0
                self.imageWidthHeightConstriant?.constant = 0
            }
        }
        get {
            return self.imageView.image
        }
    }
    
    var height: CGFloat {
        let height = (self.titleHeightConstriant?.constant ?? 0) +
            (self.subtitleHeightConstriant?.constant ?? 0) +
            (self.bodyHeightConstriant?.constant ?? 0)
        let imageHeight: CGFloat = self.image == nil ? 0 : 40
        return max(height, imageHeight)
    }
    
    var theme: NotificationViewTheme = .default {
        willSet {
            self.titleLabel.textColor = newValue.titleColor
            self.subtitleLabel.textColor = newValue.subtitleColor
            self.bodyLabel.textColor = newValue.bodyColor
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
        self.titleLabel.text = nil
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.titleLabel.textColor = NotificationViewTheme.default.titleColor
        self.subtitleLabel.text = nil
        self.subtitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.subtitleLabel.textColor = NotificationViewTheme.default.subtitleColor
        self.bodyLabel.text = nil
        self.bodyLabel.font = UIFont.systemFont(ofSize: 15)
        self.bodyLabel.textColor = NotificationViewTheme.default.bodyColor
        self.bodyLabel.numberOfLines = 2
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 4
        self.image = self.imageView.image
    }
}
