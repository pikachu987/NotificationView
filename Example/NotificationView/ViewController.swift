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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notificationView = NotificationView("가나다라")
        notificationView.delegate = self
        notificationView.show()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: NotificationViewDelegate {
    
}
