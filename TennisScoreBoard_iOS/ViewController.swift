//
//  ViewController.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/2/16.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnOpptAction: UIButton!
    @IBOutlet weak var btnYouAction: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnLoad: UIButton!

    @IBOutlet weak var labelOpptSet: UILabel!
    @IBOutlet weak var labelYouSet: UILabel!
    @IBOutlet weak var labelOpptGame: UILabel!
    @IBOutlet weak var labelYouGame: UILabel!
    @IBOutlet weak var labelOpptPoint: UILabel!
    @IBOutlet weak var labelYouPoint: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnOpptAction.setTitle(NSLocalizedString("game_action", comment: "Action"), for: UIControlState.normal)
        
        btnYouAction.setTitle(NSLocalizedString("game_action", comment: "Action"), for: UIControlState.normal)
        
        btnBack.setTitle(NSLocalizedString("game_back", comment: "Back"), for: UIControlState.normal)
        
        btnReset.setTitle(NSLocalizedString("game_reset", comment: "reset"), for: UIControlState.normal)
        
        btnSave.setTitle(NSLocalizedString("game_save", comment: "Save"), for: UIControlState.normal)
        
        btnLoad.setTitle(NSLocalizedString("game_load", comment: "Load"), for: UIControlState.normal)
        
        labelOpptSet.text = "0"
        labelYouSet.text = "0"
        labelOpptGame.text = "0"
        labelYouGame.text = "0"
        labelOpptPoint.text = "40A"
        labelYouPoint.text = "40A"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

