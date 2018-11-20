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
    
    
    // MARK: Lazy Properties
    
    lazy var containerView: UIView = {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: -2)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 2)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: -2)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 2)
        topConstraint.priority = UILayoutPriority(900)
        bottomConstraint.priority = UILayoutPriority(900)
        self.addConstraints([
            leadingConstraint, trailingConstraint, topConstraint, bottomConstraint
            ])
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        self.containerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: self.containerView, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .leading, multiplier: 1, constant: -10)
        let topConstraint = NSLayoutConstraint(item: self.containerView, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .top, multiplier: 1, constant: -10)
        topConstraint.priority = UILayoutPriority(900)
        self.containerView.addConstraints([
            leadingConstraint, topConstraint
            ])
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 20)
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20)
        heightConstraint.priority = UILayoutPriority(900)
        imageView.addConstraints([widthConstraint, heightConstraint])
        return imageView
    }()
    
    lazy var appNameLabel: UILabel = {
        let label = UILabel()
        self.containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: self.iconImageView, attribute: .trailing, relatedBy: .equal, toItem: label, attribute: .leading, multiplier: 1, constant: -8)
        let centerYConstraint = NSLayoutConstraint(item: self.iconImageView, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1, constant: 0)
        self.containerView.addConstraints([
            leadingConstraint, centerYConstraint
            ])
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "now"
        label.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        self.containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: self.appNameLabel, attribute: .trailing, relatedBy: .equal, toItem: label, attribute: .leading, multiplier: 1, constant: -8)
        let centerYConstraint = NSLayoutConstraint(item: self.appNameLabel, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self.containerView, attribute: .trailing, relatedBy: .equal, toItem: label, attribute: .trailing, multiplier: 1, constant: 8)
        self.containerView.addConstraints([
            leadingConstraint, centerYConstraint, trailingConstraint
            ])
        return label
    }()
    
    lazy var textContainerView: NotificationTextContainerView = {
        let view = NotificationTextContainerView()
        self.containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: self.containerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: -12)
        let trailingConstraint = NSLayoutConstraint(item: self.containerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 12)
        let topConstraint = NSLayoutConstraint(item: self.iconImageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: -8)
        topConstraint.priority = UILayoutPriority(900)
        self.containerView.addConstraints([
            leadingConstraint, trailingConstraint, topConstraint
            ])
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        self.containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self.textContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: -8)
        let centerXConstraint = NSLayoutConstraint(item: self.containerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.containerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 5)
        topConstraint.priority = UILayoutPriority(900)
        bottomConstraint.priority = UILayoutPriority(900)
        self.containerView.addConstraints([
            topConstraint, centerXConstraint, bottomConstraint
            ])
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 35)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 3.5)
        heightConstraint.priority = UILayoutPriority(900)
        view.addConstraints([widthConstraint, heightConstraint])
        return view
    }()
    
    
    // MARK: Properties
    
    var theme: NotificationViewTheme = .default {
        willSet {
            self.containerView.backgroundColor = newValue.backgroundColor
            self.appNameLabel.textColor = newValue.appNameColor
            self.dateLabel.textColor = newValue.dateColor
            self.textContainerView.theme = newValue
        }
    }
    
    var height: CGFloat {
        return self.textContainerView.height + 58.5
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
        return self.superview?.constraints.filter({
            guard let secondItem = $0.secondItem else { return false }
            return $0.firstAttribute == .top && $0.relation == .equal && Unmanaged.passUnretained(self).toOpaque() == Unmanaged.passUnretained(secondItem).toOpaque()
        }).first
    }
    
    private var timer: Timer?
    
    private var hideDuration: TimeInterval = 7
    
    private weak var widthConstraint: NSLayoutConstraint?
    
    private var notificationView: NotificationView?
    
    // MARK: Life Cycle
    init(_ notificationView: NotificationView) {
        self.notificationView = notificationView
        super.init(frame: UIApplication.shared.keyWindow?.frame ?? .zero)
        
        self.backgroundColor = .clear
        
        self.containerView.layer.cornerRadius = 12
        self.containerView.layer.borderWidth = 0.1
        self.containerView.layer.borderColor = UIColor(white: 253/255, alpha: 0.8).cgColor
        
        self.iconImageView.contentMode = .scaleAspectFill
        self.iconImageView.clipsToBounds = true
        self.iconImageView.layer.cornerRadius = 4
        
        self.appNameLabel.font = UIFont.systemFont(ofSize: 14)
        
        self.dateLabel.font = UIFont.systemFont(ofSize: 12)
        self.dateLabel.textAlignment = .right
        
        self.textContainerView.backgroundColor = .clear
        self.theme = notificationView.theme
        
        self.bottomView.backgroundColor = UIColor(white: 215/255, alpha: 1)
        self.bottomView.layer.cornerRadius = 1.5
        
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 560)
        widthConstraint.priority = UILayoutPriority(UIScreen.main.bounds.width > 572 ? 970 : 930)
        self.addConstraint(widthConstraint)
        self.widthConstraint = widthConstraint
        
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
    
    func setEntity(_ hideDuration: TimeInterval) {
        self.hideDuration = hideDuration
        self.iconImageView.image = self.logoImage
        self.appNameLabel.text = self.appName
        
        self.makeShadow()
        
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: hideDuration, target: self, selector: #selector(self.hideAction(_:)), userInfo: nil, repeats: false)
    }
    
    func hide() {
        self.timer?.invalidate()
        self.timer = nil
        self.delegate?.notificationBannerViewWillDisappear(self)
        self.topConstraint?.constant = self.bounds.height
        UIView.animate(withDuration: 0.4, animations: {
            UIApplication.shared.keyWindow?.layoutIfNeeded()
        }) { (_) in
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
            self.widthConstraint?.priority = UILayoutPriority(UIScreen.main.bounds.width > 572 ? 970 : 930)
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
