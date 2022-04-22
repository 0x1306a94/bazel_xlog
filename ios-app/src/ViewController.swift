//
//  ViewController.swift
//  ttt
//
//  Created by king on 2022/4/22.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "XlogSample"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        LOG(level: .levelDebug, tag: "test", message: "xxxxx")
    }
}
