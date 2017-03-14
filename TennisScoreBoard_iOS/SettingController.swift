//
//  SettingController.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/3/14.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import UIKit

class SettingController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldPlayerUp: UITextField!
    @IBOutlet weak var textFieldPlayerDown: UITextField!
    @IBOutlet weak var labelVesus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textFieldPlayerUp.returnKeyType = UIReturnKeyType.done
        textFieldPlayerUp.delegate = self
        
        textFieldPlayerDown.returnKeyType = UIReturnKeyType.done
        textFieldPlayerDown.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
