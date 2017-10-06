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
    
    @IBOutlet weak var btnSet: UIButton!
    @IBOutlet weak var btnGame: UIButton!
    @IBOutlet weak var btnTiebreak: UIButton!
    @IBOutlet weak var btnDeuce: UIButton!
    @IBOutlet weak var btnServe: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    var set_select: UInt8!
    var game_select: UInt8!
    var is_tiebreak: Bool!
    var is_super_tiebreak : Bool!
    var is_deuce: Bool!
    var is_serve: Bool!
    var playerUp: NSString!
    var playerDown: NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelVesus.text = NSLocalizedString("game_setting_versus", comment: "")
        
        textFieldPlayerUp.returnKeyType = UIReturnKeyType.done
        textFieldPlayerUp.delegate = self
        
        textFieldPlayerDown.returnKeyType = UIReturnKeyType.done
        textFieldPlayerDown.delegate = self
        
        textFieldPlayerUp.addTarget(self, action: #selector(SettingController.textFieldPlayerUpDidChange) , for: UIControlEvents.editingChanged)
        
        textFieldPlayerDown.addTarget(self, action: #selector(SettingController.textFieldPlayerDownDidChange) , for: UIControlEvents.editingChanged)
        
        set_select = 0
        self.btnSet.setTitle(NSLocalizedString("game_setting_1_set", comment: ""), for: UIControlState.normal)
        
        game_select = 0
        self.btnGame.setTitle(NSLocalizedString("game_setting_6_games_in_a_set", comment: ""), for: UIControlState.normal)
        
        is_tiebreak = true
        self.btnTiebreak.setTitle(NSLocalizedString("game_setting_tiebreak", comment: ""), for: UIControlState.normal)
        
        is_deuce = true
        self.btnDeuce.setTitle(NSLocalizedString("game_setting_deuce", comment: ""), for: UIControlState.normal)
        
        is_serve = true
        self.btnServe.setTitle(self.textFieldPlayerDown.text!+NSLocalizedString("game_setting_serve_first", comment: ""), for: UIControlState.normal)
        
        self.btnConfirm.setTitle(NSLocalizedString("game_confirm", comment: ""), for: UIControlState.normal)
        
        if playerUp == nil || playerUp == "" {
            playerUp = "Player1"
        }
        
        if playerDown == nil || playerDown == "" {
            playerDown = "Player2"
        }
        textFieldPlayerUp.text = playerUp as String?
        textFieldPlayerDown.text = playerDown as String?
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameVc = segue.destination as? ViewController {
            gameVc.set_select = self.set_select
            gameVc.game_select = self.game_select
            gameVc.is_tiebreak = self.is_tiebreak
            gameVc.is_super_tiebreak = self.is_super_tiebreak
            gameVc.is_deuce = self.is_deuce
            gameVc.is_serve = self.is_serve
            gameVc.playerUp = self.textFieldPlayerUp.text as NSString!
            gameVc.playerDown = self.textFieldPlayerDown.text as NSString!
            
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldPlayerUpDidChange() {
        
        print(textFieldPlayerUp.text ?? "Player1")
        if is_serve == false {
            self.btnServe.setTitle(self.textFieldPlayerUp.text!+NSLocalizedString("game_setting_serve_first", comment: ""), for: UIControlState.normal)
        }
        
    }
    
    func textFieldPlayerDownDidChange() {
        
        print(textFieldPlayerDown.text ?? "Player2")
        
        if is_serve == true {
            self.btnServe.setTitle(self.textFieldPlayerDown.text!+NSLocalizedString("game_setting_serve_first", comment: ""), for: UIControlState.normal)
        }
    }
    //[textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    @IBAction func onSetChange(_ sender: UIButton) {
        print("Set Change")
        
        let setActionSheet = UIAlertController(title: NSLocalizedString("game_setting_set_change", comment: ""), message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let oneSetAction = UIAlertAction(title: NSLocalizedString("game_setting_1_set", comment: ""), style: UIAlertActionStyle.default) { (action) in
            print("1 set")
            self.btnSet.setTitle(NSLocalizedString("game_setting_1_set", comment: ""), for: UIControlState.normal)
            self.set_select = 0
        }
        
        let threeSetAction = UIAlertAction(title: NSLocalizedString("game_setting_3_set", comment: ""), style: UIAlertActionStyle.default) { (action) in
            print("3 sets")
            self.btnSet.setTitle(NSLocalizedString("game_setting_3_set", comment: ""), for: UIControlState.normal)
            self.set_select = 1
        }
        
        let fiveSetAction = UIAlertAction(title: NSLocalizedString("game_setting_5_set", comment: ""), style: UIAlertActionStyle.default) { (action) in
            print("5 sets")
            self.btnSet.setTitle(NSLocalizedString("game_setting_5_set", comment: ""), for: UIControlState.normal)
            self.set_select = 2
        }
        
        // Cancel
        let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
            print("Cancel")
        }
        setActionSheet.addAction(oneSetAction)
        setActionSheet.addAction(threeSetAction)
        setActionSheet.addAction(fiveSetAction)
        setActionSheet.addAction(cancelAction)
        
        self.present(setActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func onChangeGames(_ sender: UIButton) {
        print("Games change")
        
        let gamesSheet = UIAlertController(title: NSLocalizedString("game_setting_game_change", comment: ""), message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let sixGamesInASetAction = UIAlertAction(title: NSLocalizedString("game_setting_6_games_in_a_set", comment: ""), style: UIAlertActionStyle.default) { (action) in
            print("6 games")
            self.btnGame.setTitle(NSLocalizedString("game_setting_6_games_in_a_set", comment: ""), for: UIControlState.normal)
            self.game_select = 0
        }
        
        let fourGamesInASetAction = UIAlertAction(title: NSLocalizedString("game_setting_4_games_in_a_set", comment: ""), style: UIAlertActionStyle.default) { (action) in
            print("4 games")
            self.btnGame.setTitle(NSLocalizedString("game_setting_4_games_in_a_set", comment: ""), for: UIControlState.normal)
            self.game_select = 1
        }
        
        // Cancel
        let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
            print("Cancel")
        }
        
        gamesSheet.addAction(sixGamesInASetAction)
        gamesSheet.addAction(fourGamesInASetAction)
        gamesSheet.addAction(cancelAction)
        
        self.present(gamesSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func onChangeTiebreak(_ sender: UIButton) {
        print("tiebreak change")
         
        let tiebreakSheet = UIAlertController(title: NSLocalizedString("game_setting_choose_tiebreak", comment: ""), message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
         
        let tiebreakAction = UIAlertAction(title: NSLocalizedString("game_setting_tiebreak", comment: ""), style: UIAlertActionStyle.default) { (action) in
            print("tiebreak")
            self.btnTiebreak.setTitle(NSLocalizedString("game_setting_tiebreak", comment: ""), for: UIControlState.normal)
            self.is_tiebreak = true
            self.is_super_tiebreak = false
        }
         
        let decidingGameAction = UIAlertAction(title: NSLocalizedString("game_setting_deciding_game", comment: ""), style: UIAlertActionStyle.default) { (action) in
            print("Deciding Game")
            self.btnTiebreak.setTitle(NSLocalizedString("game_setting_deciding_game", comment: ""), for: UIControlState.normal)
            self.is_tiebreak = false
            self.is_super_tiebreak = false
        }
        
        let superTiereakAction = UIAlertAction(title: NSLocalizedString("game_setting_super_tiebreak", comment: ""), style: UIAlertActionStyle.default) { (action) in
            print("Super Tiebreak")
            self.btnTiebreak.setTitle(NSLocalizedString("game_setting_super_tiebreak", comment: ""), for: UIControlState.normal)
            self.is_tiebreak = true
            self.is_super_tiebreak = true
        }
         
        // Cancel
        let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
        print("Cancel")
        }
        
        tiebreakSheet.addAction(tiebreakAction)
        tiebreakSheet.addAction(decidingGameAction)
        if set_select >= 1 && game_select == 0 {
            tiebreakSheet.addAction(superTiereakAction)
        }
    
        tiebreakSheet.addAction(cancelAction)
        
        
          
        self.present(tiebreakSheet, animated: true, completion: nil)
    }
    
    @IBAction func onDeuceChange(_ sender: UIButton) {
        print("deuce change")
        
        let deuceSheet = UIAlertController(title: NSLocalizedString("game_setting_choose_deuce", comment: ""), message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let deuceAction = UIAlertAction(title: NSLocalizedString("game_setting_deuce", comment: ""), style: UIAlertActionStyle.default) { (action) in
            print("Deuce")
            self.btnDeuce.setTitle(NSLocalizedString("game_setting_deuce", comment: ""), for: UIControlState.normal)
            self.is_deuce = true
        }
        
        let decidingPointAction = UIAlertAction(title: NSLocalizedString("game_setting_deciding_point", comment: ""), style: UIAlertActionStyle.default) { (action) in
            print("Deciding Point")
            
            self.btnDeuce.setTitle(NSLocalizedString("game_setting_deciding_point", comment: ""), for: UIControlState.normal)
            self.is_deuce = false
        }
        
        // Cancel
        let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
            print("Cancel")
        }
        
        deuceSheet.addAction(deuceAction)
        deuceSheet.addAction(decidingPointAction)
        deuceSheet.addAction(cancelAction)
        
        self.present(deuceSheet, animated: true, completion: nil)
    }
    
    @IBAction func onServeChange(_ sender: UIButton) {
        print("serve change")
        
        let serveSheet = UIAlertController(title: NSLocalizedString("game_setting_choose_serve_first", comment: ""), message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let playerUpServeAction = UIAlertAction(title: textFieldPlayerUp.text!+NSLocalizedString("game_setting_serve_first", comment: ""), style: UIAlertActionStyle.default) { (action) in
            print(self.textFieldPlayerUp.text!+NSLocalizedString("game_setting_serve_first", comment: ""))
            self.btnServe.setTitle(self.textFieldPlayerUp.text!+NSLocalizedString("game_setting_serve_first", comment: ""), for: UIControlState.normal)
            self.is_serve = false
        }
        
        let playerDownServeAction = UIAlertAction(title: textFieldPlayerDown.text!+NSLocalizedString("game_setting_serve_first", comment: ""), style: UIAlertActionStyle.default) { (action) in
            print(self.textFieldPlayerDown.text!+NSLocalizedString("game_setting_serve_first", comment: ""))
            self.btnServe.setTitle(self.textFieldPlayerDown.text!+NSLocalizedString("game_setting_serve_first", comment: ""), for: UIControlState.normal)
            self.is_serve = true
        }
        
        // Cancel
        let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
            print("Cancel")
        }
        
        serveSheet.addAction(playerUpServeAction)
        serveSheet.addAction(playerDownServeAction)
        serveSheet.addAction(cancelAction)
        
        self.present(serveSheet, animated: true, completion: nil)
    }
    
    //confirm
    @IBAction func onConfirm(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let gameVc = storyBoard.instantiateViewController(withIdentifier: "gameView") as! ViewController
        
        gameVc.set_select = self.set_select
        gameVc.game_select = self.game_select
        gameVc.is_tiebreak = self.is_tiebreak
        gameVc.is_super_tiebreak = self.is_super_tiebreak
        gameVc.is_deuce = self.is_deuce
        gameVc.is_serve = self.is_serve
        gameVc.playerUp = self.textFieldPlayerUp.text as NSString!
        gameVc.playerDown = self.textFieldPlayerDown.text as NSString!
        //navigationController?.pushViewController(gameVc, animated: true)
        
    }
    
}
