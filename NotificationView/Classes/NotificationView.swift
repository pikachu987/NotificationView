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

/*
 It conveys the state change and touch of the NotificationView.
 */
public protocol NotificationViewDelegate: class {
    // Called when NotificationView is willAppear.
    func notificationViewWillAppear(_ notificationView: NotificationView)
    // Called when NotificationView is didAppear.
    func notificationViewDidAppear(_ notificationView: NotificationView)
    // Called when NotificationView is willDisappear.
    func notificationViewWillDisappear(_ notificationView: NotificationView)
    // Called when NotificationView is didDisappear.
    func notificationViewDidDisappear(_ notificationView: NotificationView)
    // Called when the NotificationView is touched.
    func notificationViewDidTap(_ notificationView: NotificationView)
}

public extension NotificationViewDelegate {
    func notificationViewWillAppear(_ notificationView: NotificationView) { }
    func notificationViewDidAppear(_ notificationView: NotificationView) { }
    func notificationViewWillDisappear(_ notificationView: NotificationView) { }
    func notificationViewDidDisappear(_ notificationView: NotificationView) { }
    func notificationViewDidTap(_ notificationView: NotificationView) { }
}

/*
 NotificationViewState
 */
public enum NotificationViewState {
    case willAppear, didAppear, willDisappear, didDisappear, tap
}

public enum NotificationViewTheme {
    case `default`, dark
    
    var backgroundColor: UIColor {
        return self == .default ? UIColor(white: 253/255, alpha: 0.95) : UIColor(white: 3/255, alpha: 0.95)
    }
    var appNameColor: UIColor {
        return self == .default ? UIColor(white: 80/255, alpha: 1) : UIColor(white: 220/255, alpha: 1)
    }
    var dateColor: UIColor {
        return self == .default ? UIColor(white: 110/255, alpha: 1) : UIColor(white: 180/255, alpha: 1)
    }
    var titleColor: UIColor {
        return self == .default ? UIColor.black : UIColor.white
    }
    var subtitleColor: UIColor {
        return self == .default ? UIColor.black : UIColor.white
    }
    var bodyColor: UIColor {
        return self == .default ? UIColor.black : UIColor.white
    }
}

public class NotificationView: NSObject {
    public weak var delegate: NotificationViewDelegate?
    
    public static let `default` = NotificationView()
    
    public var colorType: NotificationViewTheme = NotificationViewTheme.default {
        willSet {
            self.backgroundColor = self.colorType.backgroundColor
            self.appNameLabel.textColor = self.colorType.appNameColor
            self.dateLabel.textColor = self.colorType.dateColor
            self.titleLabel.textColor = self.colorType.titleColor
            self.subtitleLabel.textColor = self.colorType.subtitleColor
            self.bodyLabel.textColor = self.colorType.bodyColor
        }
    }
    
    public var date: String? {
        set {
            self.dateLabel.text = newValue
        }
        get {
            return self.dateLabel.text
        }
    }
    
    public var title: String? {
        set {
            self.bannerView.textContainerView.title = newValue
        }
        get {
            return self.bannerView.textContainerView.title
        }
    }
    public var subtitle: String? {
        set {
            self.bannerView.textContainerView.subtitle = newValue
        }
        get {
            return self.bannerView.textContainerView.subtitle
        }
    }
    public var body: String? {
        set {
            self.bannerView.textContainerView.body = newValue
        }
        get {
            return self.bannerView.textContainerView.body
        }
    }
    public var image: UIImage? {
        set {
            self.bannerView.textContainerView.image = newValue
        }
        get {
            return self.bannerView.textContainerView.image
        }
    }
    public var param: [AnyHashable : Any]?
    public var identifier = ""
    public var hideDuration: TimeInterval = 7
    
    public var backgroundColor: UIColor? {
        set {
            self.bannerView.containerView.backgroundColor = newValue
        }
        get {
            return self.bannerView.containerView.backgroundColor
        }
    }
    
    public var iconImageView: UIImageView {
        return self.bannerView.iconImageView
    }
    
    public var appNameLabel: UILabel {
        return self.bannerView.appNameLabel
    }
    
    public var dateLabel: UILabel {
        return self.bannerView.dateLabel
    }
    
    public var titleLabel: UILabel {
        return self.bannerView.textContainerView.titleLabel
    }
    
    public var subtitleLabel: UILabel {
        return self.bannerView.textContainerView.subtitleLabel
    }
    
    public var bodyLabel: UILabel {
        return self.bannerView.textContainerView.bodyLabel
    }
    
    public var imageView: UIImageView {
        return self.bannerView.textContainerView.imageView
    }
    
    private let bannerView = NotificationBannerView(frame: UIApplication.shared.keyWindow?.frame ?? .zero)
    
    static var topHeight: CGFloat {
        return max(UIApplication.shared.statusBarFrame.height, 20)
    }
    
    private var handler: ((NotificationViewState) -> Void)?
    
    public override init() {
        super.init()
        self.bannerView.delegate = self
    }
    
    public init(_ title: String, subtitle: String? = nil, body: String? = nil, image: UIImage? = nil, param: [AnyHashable : Any]? = nil, identifier: String = "") {
        super.init()
        self.bannerView.delegate = self
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.image = image
        self.param = param
        self.identifier = identifier
    }
    
    public func show(_ duration: TimeInterval = 0, handler: ((NotificationViewState) -> Void)? = nil) {
        self.handler = handler
        self.bannerView.setEntity(self.hideDuration)
        if self.bannerView.superview != nil { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            guard let window = UIApplication.shared.keyWindow else { return }
            self.delegate?.notificationViewWillAppear(self)
            self.handler?(.willAppear)
            window.addSubview(self.bannerView)
            self.bannerView.translatesAutoresizingMaskIntoConstraints = false
            let leadingConstraint = NSLayoutConstraint(item: window, attribute: .leading, relatedBy: .equal, toItem: self.bannerView, attribute: .leading, multiplier: 1, constant: -6)
            let trailingConstraint = NSLayoutConstraint(item: window, attribute: .trailing, relatedBy: .equal, toItem: self.bannerView, attribute: .trailing, multiplier: 1, constant: 6)
            leadingConstraint.priority = UILayoutPriority(950)
            trailingConstraint.priority = UILayoutPriority(950)
            let centerXConstraint = NSLayoutConstraint(item: window, attribute: .centerX, relatedBy: .equal, toItem: self.bannerView, attribute: .centerX, multiplier: 1, constant: 0)
            
            let topConstraint = NSLayoutConstraint(item: window, attribute: .top, relatedBy: .equal, toItem: self.bannerView, attribute: .top, multiplier: 1, constant: self.bannerView.height)
            topConstraint.priority = UILayoutPriority(950)
            let topLimitConstraint = NSLayoutConstraint(item: window, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.bannerView, attribute: .top, multiplier: 1, constant: -NotificationView.topHeight)
            window.addConstraints([
                leadingConstraint, trailingConstraint, topConstraint, topLimitConstraint, centerXConstraint
                ])
            
            window.layoutIfNeeded()
            topConstraint.constant = -NotificationView.topHeight
            UIView.animate(withDuration: 0.4, animations: {
                window.layoutIfNeeded()
            }, completion: { (_) in
                self.delegate?.notificationViewDidAppear(self)
                self.handler?(.didAppear)
            })
        }
    }
    
    public func hide() {
        self.bannerView.hide()
    }
}

// MARK: BannerViewDelegate
extension NotificationView: NotificationBannerViewDelegate {
    func notificationBannerViewDidDisappear(_ notificationBannerView: NotificationBannerView) {
        self.delegate?.notificationViewDidDisappear(self)
        self.handler?(.didDisappear)
    }
    func notificationBannerViewWillDisappear(_ notificationBannerView: NotificationBannerView) {
        self.delegate?.notificationViewWillDisappear(self)
        self.handler?(.willDisappear)
    }
    func notificationBannerViewDidTap(_ notificationBannerView: NotificationBannerView) {
        self.delegate?.notificationViewDidTap(self)
        self.handler?(.tap)
    }
}
