//
//  ViewController.swift
//  NotificationView
//
//  Created by pikachu987 on 11/02/2018.
//  Copyright (c) 2018 pikachu987. All rights reserved.
//

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
