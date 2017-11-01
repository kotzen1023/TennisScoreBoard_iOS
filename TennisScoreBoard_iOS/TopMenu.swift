//
//  TopMenu.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/10/24.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import UIKit

class TopMenu: UIViewController {

    @IBOutlet weak var btnLoadGame: UIButton!
    @IBOutlet weak var btnlNewGame: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnLoadGame.titleLabel?.numberOfLines = 1
        btnLoadGame.titleLabel?.adjustsFontSizeToFitWidth = true
        btnLoadGame.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        btnlNewGame.titleLabel?.numberOfLines = 1
        btnlNewGame.titleLabel?.adjustsFontSizeToFitWidth = true
        btnlNewGame.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
