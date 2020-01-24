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

// NotificationBannerViewDelegate
protocol NotificationBannerViewDelegate: class {
    func notificationBannerViewWillDisappear(_ notificationBannerView: NotificationBannerView)
    func notificationBannerViewDidDisappear(_ notificationBannerView: NotificationBannerView)
    func notificationBannerViewDidTap(_ notificationBannerView: NotificationBannerView)
}


// NotificationBannerView
class NotificationBannerView: UIView {
    
    // MARK: deinit
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    
    // MARK: delegate
    weak var delegate: NotificationBannerViewDelegate?
    
    
    // MARK: UI Properties
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor(white: 253/255, alpha: 0.8).cgColor
        return view
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "now"
        label.setContentHuggingPriority(UILayoutPriority(252), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    let textContainerView: NotificationTextContainerView = {
        let view = NotificationTextContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 215/255, alpha: 1)
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    
    // MARK: Properties
    
    var theme: NotificationViewTheme = .default {
        willSet {
            if let color = newValue.backgroundColor {
                self.containerView.backgroundColor = color
            }
            if let color = newValue.appNameColor {
                self.appNameLabel.textColor = color
            }
            if let color = newValue.dateColor {
                self.dateLabel.textColor = color
            }
            self.textContainerView.theme = newValue
        }
    }
    
    var height: CGFloat {
        return self.textContainerView.height + 18.5 + (self.isHeader ? 40 : 0)
    }
    
    var isHeader: Bool = true {
        didSet {
            self.headerView.constraints(identifierType: .height).first?.constant = self.isHeader ? 40 : 0
        }
    }
    
    private var logoImage: UIImage? = {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last else { return nil }
        return UIImage(named: lastIcon)
    }()
    
    private var appName: String? = {
        return (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? Bundle.main.infoDictionary?["CFBundleName"] as? String
    }()
    
    private var topConstraint: NSLayoutConstraint? {
        return self.superview?.constraints(identifierType: .top).first
    }
    
    private var timer: Timer?
    
    private var hideDuration: TimeInterval = 7
    
    private var notificationView: NotificationView?
    
    // MARK: Life Cycle
    init(_ notificationView: NotificationView) {
        self.notificationView = notificationView
        super.init(frame: UIApplication.shared.keyWindow?.frame ?? .zero)
        
        self.backgroundColor = .clear
        
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.headerView)
        self.containerView.addSubview(self.textContainerView)
        self.containerView.addSubview(self.bottomView)
        
        self.headerView.addSubview(self.iconImageView)
        self.headerView.addSubview(self.appNameLabel)
        self.headerView.addSubview(self.dateLabel)
        
        // container
        
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1, constant: -2),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1, constant: 2),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1, constant: -2).priority(900),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1, constant: 2).priority(900)
        ])
        
        // header
        
        self.containerView.addConstraints([
            NSLayoutConstraint(item: self.containerView, attribute: .leading, relatedBy: .equal, toItem: self.headerView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerView, attribute: .trailing, relatedBy: .equal, toItem: self.headerView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerView, attribute: .top, relatedBy: .equal, toItem: self.headerView, attribute: .top, multiplier: 1, constant: 0)
        ])
        
        self.headerView.addConstraints([
            NSLayoutConstraint(item: self.headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40).identifier(.height)
        ])
        
        // textContainer
        
        self.containerView.addConstraints([
            NSLayoutConstraint(item: self.headerView, attribute: .bottom, relatedBy: .equal, toItem: self.textContainerView, attribute: .top, multiplier: 1, constant: -8),//.priority(900),
            NSLayoutConstraint(item: self.containerView, attribute: .leading, relatedBy: .equal, toItem: self.textContainerView, attribute: .leading, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: self.containerView, attribute: .trailing, relatedBy: .equal, toItem: self.textContainerView, attribute: .trailing, multiplier: 1, constant: 12)
        ])
        
        // bottom
        
        self.containerView.addConstraints([
            NSLayoutConstraint(item: self.textContainerView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomView, attribute: .top, multiplier: 1, constant: -8).priority(900),
            NSLayoutConstraint(item: self.containerView, attribute: .centerX, relatedBy: .equal, toItem: self.bottomView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomView, attribute: .bottom, multiplier: 1, constant: 5).priority(900)
        ])
        
        self.bottomView.addConstraints([
            NSLayoutConstraint(item: self.bottomView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 35),
            NSLayoutConstraint(item: self.bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 3.5).priority(900)
        ])
        
        // icon
        
        self.headerView.addConstraints([
            NSLayoutConstraint(item: self.headerView, attribute: .leading, relatedBy: .equal, toItem: self.iconImageView, attribute: .leading, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: self.headerView, attribute: .top, relatedBy: .equal, toItem: self.iconImageView, attribute: .top, multiplier: 1, constant: -10).priority(900)
        ])
        
        self.iconImageView.addConstraints([
            NSLayoutConstraint(item: self.iconImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: self.iconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20)
        ])
        
        // appName
        
        self.headerView.addConstraints([
            NSLayoutConstraint(item: self.iconImageView, attribute: .trailing, relatedBy: .equal, toItem: self.appNameLabel, attribute: .leading, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: self.iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self.appNameLabel, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        // date
        
        self.headerView.addConstraints([
            NSLayoutConstraint(item: self.appNameLabel, attribute: .trailing, relatedBy: .equal, toItem: self.dateLabel, attribute: .leading, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: self.appNameLabel, attribute: .centerY, relatedBy: .equal, toItem: self.dateLabel, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.headerView, attribute: .trailing, relatedBy: .equal, toItem: self.dateLabel, attribute: .trailing, multiplier: 1, constant: 8)
        ])
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 560).priority(UIScreen.main.bounds.width > 572 ? 970 : 930).identifier(.width))
        
        self.theme = notificationView.theme
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let value = self.topConstraint?.constant else { return }
        let previousLocation = touch.previousLocation(in: self)
        let currentPoint = touch.location(in: self)
        let constant = value + (previousLocation.y - currentPoint.y)
        if constant < -NotificationView.topHeight-10 { return }
        self.topConstraint?.constant = constant
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let value = self.topConstraint?.constant else { return }
        
        if value == -NotificationView.topHeight {
            self.hide()
            self.delegate?.notificationBannerViewDidTap(self)
        } else if value < NotificationView.topHeight/4 {
            self.timer = Timer.scheduledTimer(timeInterval: self.hideDuration, target: self, selector: #selector(self.hideAction(_:)), userInfo: nil, repeats: false)
            self.topConstraint?.constant = -NotificationView.topHeight
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.keyWindow?.layoutIfNeeded()
            })
        } else {
            self.hide()
        }
    }
    
    // MARK: Method
    
    func setEntity(_ hideDuration: TimeInterval, appName: String?, appIcon: UIImage?, date: String?) {
        self.hideDuration = hideDuration
        self.iconImageView.image = appIcon ?? self.logoImage
        self.appNameLabel.text = appName ?? self.appName
        self.dateLabel.text = date ?? "now"
        
        self.makeShadow()
        
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: hideDuration, target: self, selector: #selector(self.hideAction(_:)), userInfo: nil, repeats: false)
    }
    
    func hide(animated: Bool = true) {
        self.timer?.invalidate()
        self.timer = nil
        self.delegate?.notificationBannerViewWillDisappear(self)
        self.topConstraint?.constant = self.bounds.height
        if animated {
            UIView.animate(withDuration: 0.4, animations: {
                UIApplication.shared.keyWindow?.layoutIfNeeded()
            }) { (_) in
                self.delegate?.notificationBannerViewDidDisappear(self)
                self.removeFromSuperview()
                self.notificationView = nil
            }
        } else {
            self.delegate?.notificationBannerViewDidDisappear(self)
            self.removeFromSuperview()
            self.notificationView = nil
        }
    }
    
    
    // MARK: Private Method
    
    @objc private func hideAction(_ sender: Timer) {
        self.hide()
    }
    
    @objc private func orientationDidChange(_ sender: NotificationCenter) {
        DispatchQueue.main.async {
            self.constraints(identifierType: .width).first?.priority = UILayoutPriority(UIScreen.main.bounds.width > 572 ? 970 : 930)
            self.superview?.constraints.filter({
                guard let secondItem = $0.secondItem else { return false }
                return Unmanaged.passUnretained(self).toOpaque() == Unmanaged.passUnretained(secondItem).toOpaque() && $0.firstAttribute == .top
            }).forEach({ (constraint) in
                constraint.constant = -NotificationView.topHeight
            })
        }
        self.makeShadow()
    }
    
    private func makeShadow() {
        self.layer.shadowColor = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.layer.shadowRadius = 12
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }
}
