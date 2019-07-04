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
import NotificationView

class ViewController: UIViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var subtitleTextField: UITextField!
    @IBOutlet private weak var bodyTextField: UITextField!
    @IBOutlet private weak var imageSwitch: UISwitch!
    @IBOutlet private weak var themeSwitch: UISwitch!
    @IBOutlet private weak var durationSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.titleTextField.resignFirstResponder()
        self.subtitleTextField.resignFirstResponder()
        self.bodyTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func titleValueChanged(_ sender: UISwitch) {
        self.titleTextField.text = sender.isOn ? "Hi 🤚" : ""
    }
    
    @IBAction private func subtitleValueChanged(_ sender: UISwitch) {
        self.subtitleTextField.text = sender.isOn ? "NotificationView 👍" : ""
    }
    
    @IBAction private func bodyValueChanged(_ sender: UISwitch) {
        self.bodyTextField.text = sender.isOn ? "This is Cool" : ""
    }
    

    @IBAction private func multipleNotificationTap(_ sender: UIButton) {
        guard let title = self.titleTextField.text,
            let subtitle = self.subtitleTextField.text,
            let body = self.bodyTextField.text else { return }
        let image = self.imageSwitch.isOn ? UIImage(named: "image.png") : nil
        let notificationView = NotificationView(title, subtitle: subtitle, body: body, image: image)
        notificationView.delegate = self
        notificationView.hideDuration = TimeInterval(self.durationSlider.value)
        notificationView.theme = self.themeSwitch.isOn ? .default : .dark
        notificationView.show { (state) in
            print("callback: \(state)")
        }
    }
    
    @IBAction private func defaultNotificationTap(_ sender: UIButton) {
        guard let title = self.titleTextField.text,
            let subtitle = self.subtitleTextField.text,
            let body = self.bodyTextField.text else { return }
        let image = self.imageSwitch.isOn ? UIImage(named: "image.png") : nil
        let notificationView = NotificationView.default
        notificationView.title = title
        notificationView.subtitle = subtitle
        notificationView.body = body
        notificationView.image = image
        notificationView.hideDuration = TimeInterval(self.durationSlider.value)
        notificationView.theme = self.themeSwitch.isOn ? .default : .dark
//        notificationView.theme = .custom
//        notificationView.backgroundColor = .red
//        notificationView.appNameLabel.textColor = .blue
//        notificationView.dateLabel.textColor = .blue
//        notificationView.titleLabel.textColor = .blue
//        notificationView.subtitleLabel.textColor = .blue
//        notificationView.bodyLabel.textColor = .blue
        notificationView.delegate = self
        notificationView.show()
    }
}

// MARK: NotificationViewDelegate
extension ViewController: NotificationViewDelegate {
    func notificationViewWillAppear(_ notificationView: NotificationView) {
        print("delegate: notificationViewWillAppear")
    }
    func notificationViewDidAppear(_ notificationView: NotificationView) {
        print("delegate: notificationViewDidAppear")
    }
    func notificationViewWillDisappear(_ notificationView: NotificationView) {
        print("delegate: notificationViewWillDisappear")
    }
    func notificationViewDidDisappear(_ notificationView: NotificationView) {
        print("delegate: notificationViewDidDisappear")
    }
    func notificationViewDidTap(_ notificationView: NotificationView) {
        print("delegate: notificationViewDidTap")
    }
}
