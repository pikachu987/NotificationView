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
    /// Called when NotificationView is willAppear.
    func notificationViewWillAppear(_ notificationView: NotificationView)
    /// Called when NotificationView is didAppear.
    func notificationViewDidAppear(_ notificationView: NotificationView)
    /// Called when NotificationView is willDisappear.
    func notificationViewWillDisappear(_ notificationView: NotificationView)
    /// Called when NotificationView is didDisappear.
    func notificationViewDidDisappear(_ notificationView: NotificationView)
    /// Called when the NotificationView is touched.
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
 Status of the NotificationView.
 */
public enum NotificationViewState {
    case willAppear, didAppear, willDisappear, didDisappear, tap
}

/*
 Theme for NotificationView.
 */
public enum NotificationViewTheme {
    case `default`
    case dark
    case custom
    
    var backgroundColor: UIColor? {
        switch self {
        case .default:
            return UIColor(white: 253/255, alpha: 0.98)
        case .dark:
            return UIColor(white: 3/255, alpha: 0.98)
        default:
            return nil
        }
    }
    var appNameColor: UIColor? {
        switch self {
        case .default:
            return UIColor(white: 80/255, alpha: 1)
        case .dark:
            return UIColor(white: 220/255, alpha: 1)
        default:
            return nil
        }
    }
    var dateColor: UIColor? {
        switch self {
        case .default:
            return UIColor(white: 110/255, alpha: 1)
        case .dark:
            return UIColor(white: 180/255, alpha: 1)
        default:
            return nil
        }
    }
    var titleColor: UIColor? {
        switch self {
        case .default:
            return UIColor.black
        case .dark:
            return UIColor.white
        default:
            return nil
        }
    }
    var subtitleColor: UIColor? {
        switch self {
        case .default:
            return UIColor.black
        case .dark:
            return UIColor.white
        default:
            return nil
        }
    }
    var bodyColor: UIColor? {
        switch self {
        case .default:
            return UIColor.black
        case .dark:
            return UIColor.white
        default:
            return nil
        }
    }
}

public class NotificationView: NSObject {
    
    // MARK: delegate
    
    /// Connect the delegate to detect when the NotificationView touches or changes state
    public weak var delegate: NotificationViewDelegate?
    
    
    // MARK: default
    
    /// The default View for NotificationView. Since it is static, you can call it anywhere.
    public static let `default` = NotificationView()
    
    
    // MARK: Public Properties
    
    /// Theme for NotificationView. There are dark mode and default mode.
    public var theme: NotificationViewTheme = NotificationViewTheme.default {
        willSet {
            self.backgroundColor = self.theme.backgroundColor
            self.appNameLabel.textColor = self.theme.appNameColor
            self.dateLabel.textColor = self.theme.dateColor
            self.titleLabel.textColor = self.theme.titleColor
            self.subtitleLabel.textColor = self.theme.subtitleColor
            self.bodyLabel.textColor = self.theme.bodyColor
        }
    }
    
    public var isHeader: Bool = true {
        didSet {
            self.bannerView.isHeader = self.isHeader
        }
    }
    
    public var date: String?
    public var appName: String?
    public var appIcon: UIImage?
    
    /// The title of the NotificationView.
    public var title: String? {
        set {
            self.bannerView.textContainerView.title = newValue
        }
        get {
            return self.bannerView.textContainerView.title
        }
    }
    
    /// The subtitle of the NotificationView.
    public var subtitle: String? {
        set {
            self.bannerView.textContainerView.subtitle = newValue
        }
        get {
            return self.bannerView.textContainerView.subtitle
        }
    }
    
    /// The body of the NotificationView.
    public var body: String? {
        set {
            self.bannerView.textContainerView.body = newValue
        }
        get {
            return self.bannerView.textContainerView.body
        }
    }
    
    /// The image of the NotificationView.
    public var image: UIImage? {
        set {
            self.bannerView.textContainerView.image = newValue
        }
        get {
            return self.bannerView.textContainerView.image
        }
    }
    
    /// The background color of the NotificationView.
    public var backgroundColor: UIColor? {
        set {
            self.bannerView.containerView.backgroundColor = newValue
        }
        get {
            return self.bannerView.containerView.backgroundColor
        }
    }
    
    /// It is a dictionary that can contain any data.
    public var param: [AnyHashable : Any]?
    
    /// The identifier for the NotificationView.
    public var identifier = ""
    
    /// The time until the NotificationView is shown and then disappears.
    public var hideDuration: TimeInterval = 7
    
    /// An UIImageView that displays the AppIcon image.
    public var iconImageView: UIImageView {
        return self.bannerView.iconImageView
    }
    
    /// An UILabel that displays the AppName text.
    public var appNameLabel: UILabel {
        return self.bannerView.appNameLabel
    }
    
    /// An UILabel that displays the Date text.
    public var dateLabel: UILabel {
        return self.bannerView.dateLabel
    }
    
    /// An UILabel that displays the Title text.
    public var titleLabel: UILabel {
        return self.bannerView.textContainerView.titleLabel
    }
    
    /// An UILabel that displays the Subtitle text.
    public var subtitleLabel: UILabel {
        return self.bannerView.textContainerView.subtitleLabel
    }
    
    /// An UILabel that displays the Body text.
    public var bodyLabel: UILabel {
        return self.bannerView.textContainerView.bodyLabel
    }
    
    /// An UIImageView that displays the Image.
    public var imageView: UIImageView {
        return self.bannerView.textContainerView.imageView
    }
    
    
    // MARK: Private Properties
    
    /// NotificationBannerView
    private lazy var bannerView: NotificationBannerView = {
        return NotificationBannerView(self)
    }()
    
    /// Callback function passing NotificationViewState
    private var handler: ((NotificationViewState) -> Void)?
    
    /// NotificationView Top Margin Value
    static var topHeight: CGFloat {
        return max(UIApplication.shared.statusBarFrame.height, 20)
    }
    
    
    // MARK: Life Cycle
    
    public override init() {
        super.init()
        self.bannerView.delegate = self
    }
    
    public init(_ title: String?, subtitle: String? = nil, body: String? = nil, image: UIImage? = nil, param: [AnyHashable : Any]? = nil, identifier: String = "") {
        super.init()
        self.bannerView.delegate = self
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.image = image
        self.param = param
        self.identifier = identifier
    }
    
    
    // MARK: Public Method
    
    /**
     A NotificationView is show.
     - Parameters:
     - handler: Callbacks to get NotificationViewState
     */
    public func show(_ handler: ((NotificationViewState) -> Void)? = nil) {
        self.showAfter(0, handler: handler)
    }
    
    /**
     A NotificationView is show.
     - Parameters:
     - duration: Displayed after duration
     - handler: Callbacks to get NotificationViewState
     */
    public func showAfter(_ duration: TimeInterval, handler: ((NotificationViewState) -> Void)? = nil) {
        self.handler = handler
        self.bannerView.theme = self.theme
        self.bannerView.setEntity(self.hideDuration, appName: self.appName, appIcon: self.appIcon, date: self.date)
        if self.bannerView.superview != nil {
            if self.bannerView.frame.origin.y < -10 {
                self.bannerView.hide(animated: false)
            } else {
                return
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            guard let window = UIApplication.shared.keyWindow else { return }
            self.delegate?.notificationViewWillAppear(self)
            self.handler?(.willAppear)
            window.addSubview(self.bannerView)
            self.bannerView.translatesAutoresizingMaskIntoConstraints = false
            
            let topConstraint = NSLayoutConstraint(item: window, attribute: .top, relatedBy: .equal, toItem: self.bannerView, attribute: .top, multiplier: 1, constant: self.bannerView.height).priority(950).identifier(.top)
            window.addConstraints([
                NSLayoutConstraint(item: window, attribute: .leading, relatedBy: .equal, toItem: self.bannerView, attribute: .leading, multiplier: 1, constant: -6).priority(950),
                NSLayoutConstraint(item: window, attribute: .trailing, relatedBy: .equal, toItem: self.bannerView, attribute: .trailing, multiplier: 1, constant: 6).priority(950),
                topConstraint,
                NSLayoutConstraint(item: window, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.bannerView, attribute: .top, multiplier: 1, constant: -NotificationView.topHeight),
                NSLayoutConstraint(item: window, attribute: .centerX, relatedBy: .equal, toItem: self.bannerView, attribute: .centerX, multiplier: 1, constant: 0)
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
    
    /**
     A NotificationView is hide.
     */
    public func hide() {
        self.hideAfter(0)
    }
    
    /**
     A NotificationView is hide.
     - Parameters:
     - duration: After duration, it disappears.
     */
    public func hideAfter(_ duration: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.bannerView.hide()
        }
    }
}

// MARK: NotificationBannerViewDelegate
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
