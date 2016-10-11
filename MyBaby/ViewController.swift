//
//  ViewController.swift
//  MyBaby
//
//  Created by Kelly Li on 16/8/15.
//  Copyright © 2016年 Kelly Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var welcomeUITextField: UITextField!
    @IBOutlet weak var headUIImageView: UIImageView!
    @IBOutlet weak var nameUITextField: UITextField!
    @IBAction func nextAction(_ sender: AnyObject) {
        performSegue(withIdentifier: "showchoiceviewcontroller", sender: self)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "华英英语四级"
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

