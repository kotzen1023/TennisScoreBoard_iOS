//
//  ViewController.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/2/16.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import UIKit

enum StateAction {
    case YOU_SERVE
    case OPPT_SERVE
    case YOU_SCORE
    case OPPT_SCORE
    case YOU_RETIRE
    case OPPT_RETIRE
}

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
    @IBOutlet weak var labelTopPlayer: UILabel!
    @IBOutlet weak var labelBottomPlayer: UILabel!
    
    @IBOutlet weak var imgServeUp: UIImageView!
    @IBOutlet weak var imgServeDown: UIImageView!
    @IBOutlet weak var imgWinCheckUp: UIImageView!
    @IBOutlet weak var imgWinCheckDown: UIImageView!
    
    var scrollView: UIScrollView!
    var tableView: UITableView!
    
    var is_action_click: Bool!
    
    var set_select: UInt8!
    var is_tiebreak: Bool!
    var is_deuce: Bool!
    var is_serve: Bool!
    var is_retire: UInt8!
    var playerUp: NSString!
    var playerDown: NSString!
    
    
    var stack = Deque()
    //for caculate
    var is_second_serve:Bool = false
    var is_break_point:Bool = false
    
    var ace_count:UInt8 = 0;
    var double_faults_count:UInt8 = 0;
    var unforced_errors_count:UInt16 = 0;
    var forehand_winner_count:UInt16 = 0;
    var backhand_winner_count:UInt16 = 0;
    var forehand_volley_count:UInt16 = 0;
    var backhand_volley_count:UInt16 = 0;
    var foul_to_lose_count:UInt8 = 0;
    var first_serve_count:UInt16 = 0;
    var first_serve_miss:UInt16 = 0;
    var second_serve_count:UInt16 = 0;
    
    var first_serve_won:UInt16 = 0;
    var first_serve_lost:UInt16 = 0;
    var second_serve_won:UInt16 = 0;
    var second_serve_lost:UInt16 = 0;
    
    var time_use: UInt = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("------ load setting ------")
        print("playerUp: \(playerUp)")
        print("playerDown: \(playerDown)")
        print("set_select: \(set_select)")
        print("is_tiebreak: \(is_tiebreak)")
        print("is_deuce: \(is_deuce)")
        print("is_serve: \(is_serve)")
        print("is_retire: \(is_retire)")
        print("------ load setting ------")
        
        // Do any additional setup after loading the view, typically from a nib.
        
        btnOpptAction.setTitle(NSLocalizedString("game_action", comment: "Action"), for: UIControlState.normal)
        
        btnYouAction.setTitle(NSLocalizedString("game_action", comment: "Action"), for: UIControlState.normal)
        
        btnBack.setTitle(NSLocalizedString("game_back", comment: "Back"), for: UIControlState.normal)
        
        btnReset.setTitle(NSLocalizedString("game_reset", comment: "reset"), for: UIControlState.normal)
        
        btnSave.setTitle(NSLocalizedString("game_save", comment: "Save"), for: UIControlState.normal)
        
        btnLoad.setTitle(NSLocalizedString("game_load", comment: "Load"), for: UIControlState.normal)
      
        labelTopPlayer.text = playerUp as String?
        labelBottomPlayer.text = playerDown as String?
        
        labelOpptSet.text = "0"
        labelYouSet.text = "0"
        labelOpptGame.text = "0"
        labelYouGame.text = "0"
        labelOpptPoint.text = "0"
        labelYouPoint.text = "0"
        
        init_scrollview()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        if is_serve == true {
            imgServeUp.isHidden = true
            imgServeDown.isHidden = false
        } else {
            imgServeUp.isHidden = false
            imgServeDown.isHidden = true
        }
        
        //hide win check
        imgWinCheckUp.isHidden = true
        imgWinCheckDown.isHidden = true
        /*let firststate = State()
        firststate.current_set = 0
        stack.push(obj: firststate)
        print("-------------------------------------------------")
        //
        for i in 0..<stack.size() {
            let item = stack.get(index: i)
            print("stack[\(i)].current_set = \(item.current_set)")
        }
        print("-------------------------------------------------")
        let secondstate = State()
        secondstate.current_set = 1
        stack.push(obj: secondstate)
        //
        for i in 0..<stack.size() {
            let item = stack.get(index: i)
            print("stack[\(i)].current_set = \(item.current_set)")
        }
        print("-----------------pop-----------------------------")
        var top = State()
        top = stack.pop()
        print("pop state: \(top.current_set)")
        for i in 0..<stack.size() {
            let item = stack.get(index: i)
            print("stack[\(i)].current_set = \(item.current_set)")
        }*/
    }
    
    deinit {
        //3
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func deviceOrientationDidChange() {
        //2
        switch UIDevice.current.orientation {
        case .faceDown:
            print("Face down")
        case .faceUp:
            print("Face up")
        case .unknown:
            print("Unknown")
        case .landscapeLeft:
            print("Landscape left")
        case .landscapeRight:
            print("Landscape right")
        case .portrait:
            print("Portrait")
        case .portraitUpsideDown:
            print("Portrait upside down")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingVc = segue.destination as? SettingController {
            settingVc.set_select = self.set_select
            settingVc.is_tiebreak = self.is_tiebreak
            settingVc.is_deuce = self.is_deuce
            settingVc.is_serve = self.is_serve
            settingVc.playerUp = self.playerUp
            settingVc.playerDown = self.playerDown
            
        }
    }
    
    func init_scrollview() {
        //huiView = [[UIScrollView alloc] initWithFrame:CGRectMake(
        //    (self.view.bounds.size.width), self.topLayoutGuide.length-self.navigationController.navigationBar.frame.size.height,
        //    self.view.bounds.size.width,
        //    self.view.bounds.size.height)];
        
        let rect = CGRect(x: self.view.bounds.size.width, y: self.topLayoutGuide.length, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        
        scrollView = UIScrollView.init(frame: rect)
        //huiView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1.0];
        //huiView.alpha=1.0;
        let color = UIColor.init(colorLiteralRed: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1.0)
        scrollView.backgroundColor = color
        self.view.addSubview(scrollView)
        
    }
    
    
    @IBAction func onYouClick(_ sender: UIButton) {
        
        print("[You click]")
        
        // Create the action sheet
        let myActionSheet = UIAlertController(title: labelTopPlayer.text, message: NSLocalizedString("game_action_select", comment: ""), preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if imgServeDown.isHidden == false { //you serve
            if self.is_second_serve == true { //second serve
                print("[second serve]")
                
                // Ace
                let aceAction = UIAlertAction(title: NSLocalizedString("game_action_ace", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Ace")
                    self.second_serve_count = 1
                    self.ace_count = 1
                    self.second_serve_won = 1
                    self.forehand_winner_count = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // double faults
                let doubleFaultAction = UIAlertAction(title: NSLocalizedString("game_action_double_faults", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("double faults")
                    self.second_serve_count = 1
                    self.double_faults_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // unforced error
                let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Unforced Error")
                    self.second_serve_count = 1
                    self.unforced_errors_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // forehand winner
                let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Forehand Winner")
                    self.second_serve_count = 1
                    self.forehand_winner_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // backhand winner
                let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                    self.second_serve_count = 1
                    self.backhand_winner_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // forehand volley
                let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("forehand Volley")
                    self.second_serve_count = 1
                    self.forehand_volley_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // backhand volley
                let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Volley")
                    self.second_serve_count = 1
                    self.backhand_volley_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // foul to lose
                let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                    self.second_serve_count = 1
                    self.foul_to_lose_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // other winner
                let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("other winner")
                    self.second_serve_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // net
                let netAction = UIAlertAction(title: NSLocalizedString("game_action_net_in", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("net")
                    self.second_serve_count = 1
                    self.calculatePoint(action: .YOU_SERVE)
                }
                
                // retire
                let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("retire from game")
                    self.is_retire = 2
                    self.calculatePoint(action: .YOU_RETIRE)
                }
                
                // Cancel
                let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
                    print("Cancel")
                }
                
                // add action buttons to action sheet
                myActionSheet.addAction(aceAction)
                myActionSheet.addAction(doubleFaultAction)
                myActionSheet.addAction(unforceErrorAction)
                myActionSheet.addAction(forehandWinnerAction)
                myActionSheet.addAction(backhandWinnerAction)
                myActionSheet.addAction(forehandVolleyAction)
                myActionSheet.addAction(backhandVolleyAction)
                myActionSheet.addAction(foulToLoseAction)
                myActionSheet.addAction(otherWinnerAction)
                myActionSheet.addAction(netAction)
                myActionSheet.addAction(retireAction)
                myActionSheet.addAction(cancelAction)
            } else { //first serve
                print("[first serve]")
                // Ace
                let aceAction = UIAlertAction(title: NSLocalizedString("game_action_ace", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Ace")
                    self.first_serve_count = 1
                    self.ace_count = 1
                    self.first_serve_won = 1
                    self.forehand_winner_count = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // second serve
                let secondServeAction = UIAlertAction(title: NSLocalizedString("game_action_second_serve", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Second serve")
                    self.first_serve_count = 1
                    self.first_serve_miss = 1
                    self.is_second_serve = true
                    self.calculatePoint(action: .YOU_SERVE)
                }
                
                // unforced error
                let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Unforced Error")
                    self.first_serve_count = 1
                    self.unforced_errors_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // forehand winner
                let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Forehand Winner")
                    self.first_serve_count = 1
                    self.forehand_winner_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // backhand winner
                let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                    self.first_serve_count = 1
                    self.backhand_winner_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // forehand volley
                let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("forehand Volley")
                    self.first_serve_count = 1
                    self.forehand_volley_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // backhand volley
                let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Volley")
                    self.first_serve_count = 1
                    self.backhand_volley_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // foul to lose
                let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                    self.first_serve_count = 1
                    self.foul_to_lose_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // other winner
                let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("other winner")
                    self.first_serve_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // net
                let netAction = UIAlertAction(title: NSLocalizedString("game_action_net_in", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("net")
                    self.first_serve_count = 1
                    self.calculatePoint(action: .YOU_SERVE)
                }
                
                // retire
                let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("retire from game")
                    self.is_retire = 2
                    self.calculatePoint(action: .YOU_RETIRE)
                }
                
                // Cancel
                let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
                    print("Cancel")
                }
                
                // add action buttons to action sheet
                myActionSheet.addAction(aceAction)
                myActionSheet.addAction(secondServeAction)
                myActionSheet.addAction(unforceErrorAction)
                myActionSheet.addAction(forehandWinnerAction)
                myActionSheet.addAction(backhandWinnerAction)
                myActionSheet.addAction(forehandVolleyAction)
                myActionSheet.addAction(backhandVolleyAction)
                myActionSheet.addAction(foulToLoseAction)
                myActionSheet.addAction(otherWinnerAction)
                myActionSheet.addAction(netAction)
                myActionSheet.addAction(retireAction)
                myActionSheet.addAction(cancelAction)
            }
        } else { //oppt serve
            print("[oppt serve]")
            if self.is_second_serve == true {
                print("[second serve]")
                // unforced error
                let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Unforced Error")
                    self.second_serve_count = 1
                    self.unforced_errors_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // forehand winner
                let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Forehand Winner")
                    self.second_serve_count = 1
                    self.forehand_winner_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // backhand winner
                let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                    self.second_serve_count = 1
                    self.backhand_winner_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // forehand volley
                let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("forehand Volley")
                    self.second_serve_count = 1
                    self.forehand_volley_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // backhand volley
                let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Volley")
                    self.second_serve_count = 1
                    self.backhand_volley_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // foul to lose
                let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                    self.second_serve_count = 1
                    self.foul_to_lose_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // other winner
                let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                    self.second_serve_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // retire
                let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("retire from game")
                    self.is_retire = 2
                    self.calculatePoint(action: .YOU_RETIRE)
                }
                
                // Cancel
                let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
                    print("Cancel")
                }
                
                // add action buttons to action sheet
                myActionSheet.addAction(unforceErrorAction)
                myActionSheet.addAction(forehandWinnerAction)
                myActionSheet.addAction(backhandWinnerAction)
                myActionSheet.addAction(forehandVolleyAction)
                myActionSheet.addAction(backhandVolleyAction)
                myActionSheet.addAction(foulToLoseAction)
                myActionSheet.addAction(otherWinnerAction)
                myActionSheet.addAction(retireAction)
                myActionSheet.addAction(cancelAction)
            } else { //first serve
                print("[first serve]")
                // unforced error
                let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Unforced Error")
                    self.first_serve_count = 1
                    self.unforced_errors_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // forehand winner
                let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Forehand Winner")
                    self.first_serve_count = 1
                    self.forehand_winner_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // backhand winner
                let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                    self.first_serve_count = 1
                    self.backhand_winner_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // forehand volley
                let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("forehand Winner")
                    self.first_serve_count = 1
                    self.forehand_volley_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // backhand volley
                let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                    self.first_serve_count = 1
                    self.backhand_volley_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // foul to lose
                let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                    self.first_serve_count = 1
                    self.foul_to_lose_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // other winner
                let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("other winner")
                    self.first_serve_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // retire
                let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("retire from game")
                    self.is_retire = 2
                    self.calculatePoint(action: .YOU_RETIRE)
                }
                
                // Cancel
                let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
                    print("Cancel")
                }
                
                // add action buttons to action sheet
                myActionSheet.addAction(unforceErrorAction)
                myActionSheet.addAction(forehandWinnerAction)
                myActionSheet.addAction(backhandWinnerAction)
                myActionSheet.addAction(forehandVolleyAction)
                myActionSheet.addAction(backhandVolleyAction)
                myActionSheet.addAction(foulToLoseAction)
                myActionSheet.addAction(otherWinnerAction)
                myActionSheet.addAction(retireAction)
                myActionSheet.addAction(cancelAction)
            }
            
            
        }
        
        
        
        
        // support iPads (popover view)
        //myActionSheet.popoverPresentationController?.sourceView = self.showActionSheetButton
        //myActionSheet.popoverPresentationController?.sourceRect = self.showActionSheetButton.bounds
        
        // present the action sheet
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func onOpptClick(_ sender: UIButton) {
        
        print("Oppt click")
        
        // Create the action sheet
        let myActionSheet = UIAlertController(title: labelTopPlayer.text, message: NSLocalizedString("game_action_select", comment: ""), preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if imgServeUp.isHidden == false { //oppt serve
            
            if self.is_second_serve == true {
                
                // Ace
                let aceAction = UIAlertAction(title: NSLocalizedString("game_action_ace", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Ace")
                    self.second_serve_count = 1
                    self.ace_count = 1
                    self.second_serve_won = 1
                    self.forehand_winner_count = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // double faults
                let secondServeAction = UIAlertAction(title: NSLocalizedString("game_action_double_faults", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("double faults")
                    self.second_serve_count = 1
                    self.double_faults_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // unforced error
                let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Unforced Error")
                    self.second_serve_count = 1
                    self.unforced_errors_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // forehand winner
                let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Forehand Winner")
                    self.second_serve_count = 1
                    self.forehand_winner_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // backhand winner
                let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                    self.second_serve_count = 1
                    self.backhand_winner_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // forehand volley
                let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("forehand Winner")
                    self.second_serve_count = 1
                    self.forehand_volley_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // backhand volley
                let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                    self.second_serve_count = 1
                    self.backhand_volley_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // foul to lose
                let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                    self.second_serve_count = 1
                    self.foul_to_lose_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // other winner
                let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("other winner")
                    self.second_serve_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // net
                let netAction = UIAlertAction(title: NSLocalizedString("game_action_net_in", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("net")
                    self.second_serve_count = 1
                    self.calculatePoint(action: .OPPT_SERVE)
                }
                
                // retire
                let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("retire from game")
                    self.is_retire = 1
                    self.calculatePoint(action: .OPPT_RETIRE)
                }
                
                // Cancel
                let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
                    print("Cancel")
                }
                
                // add action buttons to action sheet
                myActionSheet.addAction(aceAction)
                myActionSheet.addAction(secondServeAction)
                myActionSheet.addAction(unforceErrorAction)
                myActionSheet.addAction(forehandWinnerAction)
                myActionSheet.addAction(backhandWinnerAction)
                myActionSheet.addAction(forehandVolleyAction)
                myActionSheet.addAction(backhandVolleyAction)
                myActionSheet.addAction(foulToLoseAction)
                myActionSheet.addAction(otherWinnerAction)
                myActionSheet.addAction(netAction)
                myActionSheet.addAction(retireAction)
                myActionSheet.addAction(cancelAction)
            } else { //first serve
                
                // Ace
                let aceAction = UIAlertAction(title: NSLocalizedString("game_action_ace", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Ace")
                    self.first_serve_count = 1
                    self.ace_count = 1
                    self.first_serve_won = 1
                    self.forehand_winner_count = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // second serve
                let secondServeAction = UIAlertAction(title: NSLocalizedString("game_action_second_serve", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Second serve")
                    self.first_serve_count = 1
                    self.first_serve_miss = 1
                    self.is_second_serve = true
                    self.calculatePoint(action: .OPPT_SERVE)
                }
                
                // unforced error
                let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Unforced Error")
                    self.first_serve_count = 1
                    self.unforced_errors_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // forehand winner
                let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Forehand Winner")
                    self.first_serve_count = 1
                    self.forehand_winner_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // backhand winner
                let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                    self.backhand_winner_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // forehand volley
                let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("forehand Winner")
                    self.first_serve_count = 1
                    self.forehand_volley_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // backhand volley
                let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                    self.first_serve_count = 1
                    self.backhand_volley_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // foul to lose
                let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                    self.foul_to_lose_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // other winner
                let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("other winner")
                    self.first_serve_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // net
                let netAction = UIAlertAction(title: NSLocalizedString("game_action_net_in", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("net")
                    self.first_serve_count = 1
                    self.calculatePoint(action: .OPPT_SERVE)
                }
                
                // retire
                let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("retire from game")
                    self.is_retire = 1
                    self.calculatePoint(action: .OPPT_RETIRE)
                }
                
                // Cancel
                let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
                    print("Cancel")
                }
                
                // add action buttons to action sheet
                myActionSheet.addAction(aceAction)
                myActionSheet.addAction(secondServeAction)
                myActionSheet.addAction(unforceErrorAction)
                myActionSheet.addAction(forehandWinnerAction)
                myActionSheet.addAction(backhandWinnerAction)
                myActionSheet.addAction(forehandVolleyAction)
                myActionSheet.addAction(backhandVolleyAction)
                myActionSheet.addAction(foulToLoseAction)
                myActionSheet.addAction(otherWinnerAction)
                myActionSheet.addAction(netAction)
                myActionSheet.addAction(retireAction)
                myActionSheet.addAction(cancelAction)
            }
            
        } else { //you serve
            if self.is_second_serve == true {
                
                // unforced error
                let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Unforced Error")
                    self.second_serve_count = 1
                    self.unforced_errors_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // forehand winner
                let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Forehand Winner")
                    self.second_serve_count = 1
                    self.forehand_winner_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // backhand winner
                let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                    self.second_serve_count = 1
                    self.backhand_winner_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // forehand volley
                let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("forehand Volley")
                    self.second_serve_count = 1
                    self.forehand_volley_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // backhand volley
                let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Volley")
                    self.second_serve_count = 1
                    self.backhand_volley_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // foul to lose
                let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                    self.second_serve_count = 1
                    self.foul_to_lose_count = 1
                    self.second_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // other winner
                let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("other winner")
                    self.second_serve_count = 1
                    self.second_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // retire
                let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("retire from game")
                    self.is_retire = 1
                    self.calculatePoint(action: .OPPT_RETIRE)
                }
                
                // Cancel
                let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
                    print("Cancel")
                }
                
                // add action buttons to action sheet
                myActionSheet.addAction(unforceErrorAction)
                myActionSheet.addAction(forehandWinnerAction)
                myActionSheet.addAction(backhandWinnerAction)
                myActionSheet.addAction(forehandVolleyAction)
                myActionSheet.addAction(backhandVolleyAction)
                myActionSheet.addAction(foulToLoseAction)
                myActionSheet.addAction(otherWinnerAction)
                myActionSheet.addAction(retireAction)
                myActionSheet.addAction(cancelAction)
            } else { //first serve
                
                // unforced error
                let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Unforced Error")
                    self.first_serve_count = 1
                    self.unforced_errors_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // forehand winner
                let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Forehand Winner")
                    self.first_serve_count = 1
                    self.forehand_winner_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // backhand winner
                let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                    self.first_serve_count = 1
                    self.backhand_winner_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // forehand volley
                let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("forehand Volley")
                    self.first_serve_count = 1
                    self.forehand_volley_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // backhand volley
                let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Volley")
                    self.first_serve_count = 1
                    self.backhand_volley_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // foul to lose
                let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                    self.foul_to_lose_count = 1
                    self.first_serve_won = 1
                    self.calculatePoint(action: .YOU_SCORE)
                }
                
                // other winner
                let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("other winner")
                    self.first_serve_count = 1
                    self.first_serve_lost = 1
                    self.calculatePoint(action: .OPPT_SCORE)
                }
                
                // retire
                let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("retire from game")
                    self.is_retire = 1
                    self.calculatePoint(action: .OPPT_RETIRE)
                }
                
                // Cancel
                let cancelAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
                    print("Cancel")
                }
                
                // add action buttons to action sheet
                myActionSheet.addAction(unforceErrorAction)
                myActionSheet.addAction(forehandWinnerAction)
                myActionSheet.addAction(backhandWinnerAction)
                myActionSheet.addAction(forehandVolleyAction)
                myActionSheet.addAction(backhandVolleyAction)
                myActionSheet.addAction(foulToLoseAction)
                myActionSheet.addAction(otherWinnerAction)
                myActionSheet.addAction(retireAction)
                myActionSheet.addAction(cancelAction)
            }
            
            
        }
        
        // present the action sheet
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    
    func calculatePoint(action: StateAction) {
        print("=== calculatePoint start ===")
        var current_set:UInt8 = 0;
        var set_limit:UInt8 = 0;
        switch set_select {
        case 0:
            set_limit = 1
            break
        case 1:
            set_limit = 3
            break
        case 2:
            set_limit = 5
            break
        default:
            set_limit = 1
        }
        
        
        var new_state = State()
        
        if stack.size() > 0 {
            var current_state = State()
            current_state = stack.peak()
            print("current_state is not nil")
            
            current_set = current_state.current_set
            print("####### current state start #######")
            print("set_select = \(set_select)")
            print("is_tiebreak = \(is_tiebreak)")
            print("is_deuce = \(is_deuce)")
            print("is_serve = \(is_serve)")
            print("second serve = \(is_second_serve)")
            
            print("Ace : up = \(current_state.aceCountUp) down = \(current_state.aceCountDown)")
            print("First serve miss/count : up = \(current_state.firstServeMissUp)/\(current_state.firstServeUp) down = \(current_state.firstServeMissDown)/\(current_state.firstServeDown)")
            print("Second serve miss/count : up = \(current_state.doubleFaultUp)/\(current_state.secondServeUp) down = \(current_state.doubleFaultDown)/\(current_state.secondServeDown)")
            print("==================================================")
            print("Unforced Error : up = \(current_state.unforcedErrorUp) down = \(current_state.unforcedErrorDown)")
            print("Forehand Winner : up = \(current_state.forehandWinnerUp) down = \(current_state.forehandWinnerDown)")
            print("Backhand Winner : up = \(current_state.backhandWinnerUp) down = \(current_state.backhandWinnerDown)")
            print("Forehand Volley : up = \(current_state.forehandVolleyUp) down = \(current_state.forehandVolleyDown)")
            print("Backhand Volley : up = \(current_state.backhandVolleyUp) down = \(current_state.backhandVolleyDown)")
            print("Foul to lose : up = \(current_state.foulToLoseUp) down = \(current_state.foulToLoseDown)")
            
            print("current_set = \(current_state.current_set)")
            print("Serve : \(current_state.isServe)")
            print("In tiebreak: \(current_state.isInTiebreak)")
            print("Finish : \(current_state.isFinish)")
            print("Game : \(current_state.getGameUp(set: current_set))/\(current_state.getGameDown(set: current_set))")
            print("Point : \(current_state.getPointUp(set: current_set))/\(current_state.getGameDown(set: current_set))")
            print("tiebreak : \(current_state.getTiebreakPointUp(set: current_set))/\(current_state.getTiebreakPointDown(set: current_set))")
            print("####### current state end #######")
            
            if current_state.isFinish == true { //game is finish
                print("*** Game is over ***")
                //show game stat
            } else {
                print("*** Game is running ***")
                
                
                var first: UInt16 = 0
                var first_miss: UInt16 = 0
                var second: UInt16 = 0
                print("first_serve_count = \(first_serve_count)")
                print("first_serve_miss = \(first_serve_miss)")
                print("second_serve_count = \(second_serve_count)")
                print("ace count = \(ace_count)")
                print("unforced_errors_count = \(unforced_errors_count)")
                print("foul to lose count = \(foul_to_lose_count)")
                print("double_faults_count = \(double_faults_count)")
                print("forehand_winner_count = \(forehand_winner_count)")
                print("backhand_winner_count = \(backhand_winner_count)")
                print("forehand_volley_count = \(forehand_volley_count)")
                print("backhand_volley_count = \(backhand_volley_count)")
                
                print("first_serve_won = \(first_serve_won)")
                print("first_serve_lost = \(first_serve_lost)")
                print("second_serve_won = \(second_serve_won)")
                print("second_serve_lost = \(second_serve_lost)")
                
                switch action {
                case .YOU_RETIRE:
                    print("=== I retire start ===")
                    first = current_state.firstServeDown + first_serve_count
                    first_miss = current_state.firstServeMissDown + first_serve_miss
                    second = current_state.secondServeDown + second_serve_count
                    
                    new_state.firstServeDown = first
                    new_state.firstServeMissDown = first_miss
                    new_state.secondServeDown = second
                    
                    new_state.current_set = current_state.current_set
                    new_state.isServe = current_state.isServe
                    new_state.isInTiebreak = current_state.isInTiebreak
                    new_state.isFinish = current_state.isFinish
                    
                    if is_second_serve == true {
                        new_state.isSecondServe = true
                        imgServeUp.image = UIImage(named: "ball_red")
                        imgServeDown.image = UIImage(named: "ball_red")
                    } else {
                        new_state.isSecondServe = false
                        imgServeUp.image = UIImage(named: "ball_green")
                        imgServeDown.image = UIImage(named: "ball_green")
                    }
                    
                    new_state.setsUp = current_state.setsUp
                    new_state.setSDown = current_state.setSDown
                    
                    new_state.duration = time_use
                    new_state.isFinish = true
                    
                    imgWinCheckUp.isHidden = false
                    imgWinCheckDown.isHidden = true
                    
                    new_state.aceCountUp = current_state.aceCountUp
                    new_state.aceCountDown = current_state.aceCountDown
                    new_state.firstServeUp = current_state.firstServeUp
                    new_state.firstServeMissUp = current_state.firstServeMissUp
                    new_state.secondServeUp = current_state.secondServeUp
                    new_state.breakPointUp = current_state.breakPointUp
                    new_state.breakPointMissUp = current_state.breakPointMissUp
                    new_state.breakPointDown = current_state.breakPointDown
                    new_state.breakPointMissDown = current_state.breakPointMissDown
                    new_state.firstServeWonUp = current_state.firstServeWonUp
                    new_state.firstServeWonDown = current_state.firstServeWonDown
                    new_state.firstServeLostUp = current_state.firstServeLostUp
                    new_state.firstServeLostDown = current_state.firstServeLostDown
                    new_state.secondServeWonUp = current_state.secondServeWonUp
                    new_state.secondServeWonDown = current_state.secondServeWonDown
                    new_state.secondServeLostUp = current_state.secondServeLostUp
                    new_state.secondServeLostDown = current_state.secondServeLostDown
                    new_state.doubleFaultUp = current_state.doubleFaultUp
                    new_state.doubleFaultDown = current_state.doubleFaultDown
                    new_state.unforcedErrorUp = current_state.unforcedErrorUp
                    new_state.unforcedErrorDown = current_state.unforcedErrorDown
                    new_state.forehandWinnerUp = current_state.forehandWinnerUp
                    new_state.forehandWinnerDown = current_state.forehandWinnerDown
                    new_state.backhandWinnerUp = current_state.backhandWinnerUp
                    new_state.backhandWinnerDown = current_state.backhandWinnerDown
                    new_state.forehandVolleyUp = current_state.forehandVolleyUp
                    new_state.forehandVolleyDown = current_state.forehandVolleyDown
                    new_state.backhandVolleyUp = current_state.backhandVolleyUp
                    new_state.backhandVolleyDown = current_state.backhandVolleyDown
                    new_state.foulToLoseUp = current_state.foulToLoseUp
                    new_state.foulToLoseDown = current_state.foulToLoseDown
                    
                    for i in 1...set_limit {
                        new_state.setGameUp(set: i, game: current_state.getGameUp(set: i))
                        new_state.setGameDown(set: i, game: current_state.getGameDown(set: i))
                        new_state.setPointUp(set: i, point: current_state.getPointUp(set: i))
                        new_state.setPointDown(set: i, point: current_state.getPointDown(set: i))
                        new_state.setTiebreakPointUp(set: i, point: current_state.getTiebreakPointUp(set: i))
                        new_state.setTiebreakPointDown(set: i, point: current_state.getTiebreakPointDown(set: i))
                    }
                    
                    print("=== I retire end ===")
                    break
                case .OPPT_RETIRE:
                    print("=== Oppt retire start ===")
                    
                    first = current_state.firstServeDown + first_serve_count
                    first_miss = current_state.firstServeMissDown + first_serve_miss
                    second = current_state.secondServeDown + second_serve_count
                    
                    new_state.firstServeUp = first
                    new_state.firstServeMissUp = first_miss
                    new_state.secondServeUp = second
                    
                    new_state.current_set = current_state.current_set
                    new_state.isServe = current_state.isServe
                    new_state.isInTiebreak = current_state.isInTiebreak
                    new_state.isFinish = current_state.isFinish
                    
                    if is_second_serve == true {
                        new_state.isSecondServe = true
                        imgServeUp.image = UIImage(named: "ball_red")
                        imgServeDown.image = UIImage(named: "ball_red")
                    } else {
                        new_state.isSecondServe = false
                        imgServeUp.image = UIImage(named: "ball_green")
                        imgServeDown.image = UIImage(named: "ball_green")
                    }
                    
                    new_state.setsUp = current_state.setsUp
                    new_state.setSDown = current_state.setSDown
                    
                    new_state.duration = time_use
                    new_state.isFinish = true
                    
                    imgWinCheckUp.isHidden = true
                    imgWinCheckDown.isHidden = false
                    
                    new_state.aceCountUp = current_state.aceCountUp
                    new_state.aceCountDown = current_state.aceCountDown
                    new_state.firstServeDown = current_state.firstServeDown
                    new_state.firstServeMissDown = current_state.firstServeMissDown
                    new_state.secondServeDown = current_state.secondServeDown
                    new_state.breakPointUp = current_state.breakPointUp
                    new_state.breakPointMissUp = current_state.breakPointMissUp
                    new_state.breakPointDown = current_state.breakPointDown
                    new_state.breakPointMissDown = current_state.breakPointMissDown
                    new_state.firstServeWonUp = current_state.firstServeWonUp
                    new_state.firstServeWonDown = current_state.firstServeWonDown
                    new_state.firstServeLostUp = current_state.firstServeLostUp
                    new_state.firstServeLostDown = current_state.firstServeLostDown
                    new_state.secondServeWonUp = current_state.secondServeWonUp
                    new_state.secondServeWonDown = current_state.secondServeWonDown
                    new_state.secondServeLostUp = current_state.secondServeLostUp
                    new_state.secondServeLostDown = current_state.secondServeLostDown
                    new_state.doubleFaultUp = current_state.doubleFaultUp
                    new_state.doubleFaultDown = current_state.doubleFaultDown
                    new_state.unforcedErrorUp = current_state.unforcedErrorUp
                    new_state.unforcedErrorDown = current_state.unforcedErrorDown
                    new_state.forehandWinnerUp = current_state.forehandWinnerUp
                    new_state.forehandWinnerDown = current_state.forehandWinnerDown
                    new_state.backhandWinnerUp = current_state.backhandWinnerUp
                    new_state.backhandWinnerDown = current_state.backhandWinnerDown
                    new_state.forehandVolleyUp = current_state.forehandVolleyUp
                    new_state.forehandVolleyDown = current_state.forehandVolleyDown
                    new_state.backhandVolleyUp = current_state.backhandVolleyUp
                    new_state.backhandVolleyDown = current_state.backhandVolleyDown
                    new_state.foulToLoseUp = current_state.foulToLoseUp
                    new_state.foulToLoseDown = current_state.foulToLoseDown
                    
                    for i in 1...set_limit {
                        new_state.setGameUp(set: i, game: current_state.getGameUp(set: i))
                        new_state.setGameDown(set: i, game: current_state.getGameDown(set: i))
                        new_state.setPointUp(set: i, point: current_state.getPointUp(set: i))
                        new_state.setPointDown(set: i, point: current_state.getPointDown(set: i))
                        new_state.setTiebreakPointUp(set: i, point: current_state.getTiebreakPointUp(set: i))
                        new_state.setTiebreakPointDown(set: i, point: current_state.getTiebreakPointDown(set: i))
                    }
                    
                    print("=== Oppt retire end ===")
                    break
                case .YOU_SERVE:
                    print("=== I serve start ===")
                    
                    first = current_state.firstServeDown + first_serve_count
                    first_miss = current_state.firstServeMissDown + first_serve_miss
                    second = current_state.secondServeDown + second_serve_count
                    
                    new_state.firstServeDown = first
                    new_state.firstServeMissDown = first_miss
                    new_state.secondServeDown = second
                    
                    new_state.current_set = current_state.current_set
                    new_state.isServe = current_state.isServe
                    new_state.isInTiebreak = current_state.isInTiebreak
                    new_state.isFinish = current_state.isFinish
                    
                    if is_second_serve == true {
                        new_state.isSecondServe = true
                        imgServeUp.image = UIImage(named: "ball_red")
                        imgServeDown.image = UIImage(named: "ball_red")
                    } else {
                        new_state.isSecondServe = false
                        imgServeUp.image = UIImage(named: "ball_green")
                        imgServeDown.image = UIImage(named: "ball_green")
                    }
                    
                    new_state.setsUp = current_state.setsUp
                    new_state.setSDown = current_state.setSDown
                    
                    new_state.duration = time_use
                    
                    new_state.aceCountUp = current_state.aceCountUp
                    new_state.aceCountDown = current_state.aceCountDown
                    new_state.firstServeUp = current_state.firstServeUp
                    new_state.firstServeMissUp = current_state.firstServeMissUp
                    new_state.secondServeUp = current_state.secondServeUp
                    
                    new_state.breakPointUp = current_state.breakPointUp
                    new_state.breakPointMissUp = current_state.breakPointMissUp
                    new_state.breakPointDown = current_state.breakPointDown
                    new_state.breakPointMissDown = current_state.breakPointMissDown
                    new_state.firstServeWonUp = current_state.firstServeWonUp
                    new_state.firstServeWonDown = current_state.firstServeWonDown
                    new_state.firstServeLostUp = current_state.firstServeLostUp
                    new_state.firstServeLostDown = current_state.firstServeLostDown
                    new_state.secondServeWonUp = current_state.secondServeWonUp
                    new_state.secondServeWonDown = current_state.secondServeWonDown
                    new_state.secondServeLostUp = current_state.secondServeLostUp
                    new_state.secondServeLostDown = current_state.secondServeLostDown
                    new_state.doubleFaultUp = current_state.doubleFaultUp
                    new_state.doubleFaultDown = current_state.doubleFaultDown
                    new_state.unforcedErrorUp = current_state.unforcedErrorUp
                    new_state.unforcedErrorDown = current_state.unforcedErrorDown
                    new_state.forehandWinnerUp = current_state.forehandWinnerUp
                    new_state.forehandWinnerDown = current_state.forehandWinnerDown
                    new_state.backhandWinnerUp = current_state.backhandWinnerUp
                    new_state.backhandWinnerDown = current_state.backhandWinnerDown
                    new_state.forehandVolleyUp = current_state.forehandVolleyUp
                    new_state.forehandVolleyDown = current_state.forehandVolleyDown
                    new_state.backhandVolleyUp = current_state.backhandVolleyUp
                    new_state.backhandVolleyDown = current_state.backhandVolleyDown
                    new_state.foulToLoseUp = current_state.foulToLoseUp
                    new_state.foulToLoseDown = current_state.foulToLoseDown
                    
                    for i in 1...set_limit {
                        new_state.setGameUp(set: i, game: current_state.getGameUp(set: i))
                        new_state.setGameDown(set: i, game: current_state.getGameDown(set: i))
                        new_state.setPointUp(set: i, point: current_state.getPointUp(set: i))
                        new_state.setPointDown(set: i, point: current_state.getPointDown(set: i))
                        new_state.setTiebreakPointUp(set: i, point: current_state.getTiebreakPointUp(set: i))
                        new_state.setTiebreakPointDown(set: i, point: current_state.getTiebreakPointDown(set: i))
                    }
                    print("=== I serve end ===")
                    break
                case .OPPT_SERVE:
                    print("=== I serve start ===")
                    
                    first = current_state.firstServeUp + first_serve_count
                    first_miss = current_state.firstServeMissUp + first_serve_miss
                    second = current_state.secondServeUp + second_serve_count
                    
                    new_state.firstServeUp = first
                    new_state.firstServeMissUp = first_miss
                    new_state.secondServeUp = second
                    
                    new_state.current_set = current_state.current_set
                    new_state.isServe = current_state.isServe
                    new_state.isInTiebreak = current_state.isInTiebreak
                    new_state.isFinish = current_state.isFinish
                    
                    if is_second_serve == true {
                        new_state.isSecondServe = true
                        imgServeUp.image = UIImage(named: "ball_red")
                        imgServeDown.image = UIImage(named: "ball_red")
                    } else {
                        new_state.isSecondServe = false
                        imgServeUp.image = UIImage(named: "ball_green")
                        imgServeDown.image = UIImage(named: "ball_green")
                    }
                    
                    new_state.setsUp = current_state.setsUp
                    new_state.setSDown = current_state.setSDown
                    
                    new_state.duration = time_use
                    
                    new_state.aceCountUp = current_state.aceCountUp
                    new_state.aceCountDown = current_state.aceCountDown
                    new_state.firstServeDown = current_state.firstServeDown
                    new_state.firstServeMissDown = current_state.firstServeMissDown
                    new_state.secondServeDown = current_state.secondServeDown
                    
                    new_state.breakPointUp = current_state.breakPointUp
                    new_state.breakPointMissUp = current_state.breakPointMissUp
                    new_state.breakPointDown = current_state.breakPointDown
                    new_state.breakPointMissDown = current_state.breakPointMissDown
                    new_state.firstServeWonUp = current_state.firstServeWonUp
                    new_state.firstServeWonDown = current_state.firstServeWonDown
                    new_state.firstServeLostUp = current_state.firstServeLostUp
                    new_state.firstServeLostDown = current_state.firstServeLostDown
                    new_state.secondServeWonUp = current_state.secondServeWonUp
                    new_state.secondServeWonDown = current_state.secondServeWonDown
                    new_state.secondServeLostUp = current_state.secondServeLostUp
                    new_state.secondServeLostDown = current_state.secondServeLostDown
                    new_state.doubleFaultUp = current_state.doubleFaultUp
                    new_state.doubleFaultDown = current_state.doubleFaultDown
                    new_state.unforcedErrorUp = current_state.unforcedErrorUp
                    new_state.unforcedErrorDown = current_state.unforcedErrorDown
                    new_state.forehandWinnerUp = current_state.forehandWinnerUp
                    new_state.forehandWinnerDown = current_state.forehandWinnerDown
                    new_state.backhandWinnerUp = current_state.backhandWinnerUp
                    new_state.backhandWinnerDown = current_state.backhandWinnerDown
                    new_state.forehandVolleyUp = current_state.forehandVolleyUp
                    new_state.forehandVolleyDown = current_state.forehandVolleyDown
                    new_state.backhandVolleyUp = current_state.backhandVolleyUp
                    new_state.backhandVolleyDown = current_state.backhandVolleyDown
                    new_state.foulToLoseUp = current_state.foulToLoseUp
                    new_state.foulToLoseDown = current_state.foulToLoseDown
                    
                    for i in 1...set_limit {
                        new_state.setGameUp(set: i, game: current_state.getGameUp(set: i))
                        new_state.setGameDown(set: i, game: current_state.getGameDown(set: i))
                        new_state.setPointUp(set: i, point: current_state.getPointUp(set: i))
                        new_state.setPointDown(set: i, point: current_state.getPointDown(set: i))
                        new_state.setTiebreakPointUp(set: i, point: current_state.getTiebreakPointUp(set: i))
                        new_state.setTiebreakPointDown(set: i, point: current_state.getTiebreakPointDown(set: i))
                    }
                    print("=== I serve end ===")
                    break
                case .YOU_SCORE:
                    print("=== I score start ===")
                    new_state.current_set = current_state.current_set
                    new_state.isServe = current_state.isServe
                    new_state.isInTiebreak = current_state.isInTiebreak
                    new_state.isFinish = current_state.isFinish
                    
                    if is_second_serve == true {
                        new_state.isSecondServe = true
                    } else {
                        new_state.isSecondServe = false
                    }
                    
                    new_state.setsUp = current_state.setsUp
                    new_state.setSDown = current_state.setSDown
                    
                    new_state.duration = time_use
                    
                    new_state.aceCountUp = current_state.aceCountUp
                    new_state.aceCountDown = current_state.aceCountDown
                    new_state.firstServeUp = current_state.firstServeUp
                    new_state.firstServeDown = current_state.firstServeDown
                    new_state.breakPointUp = current_state.breakPointUp
                    new_state.breakPointDown = current_state.breakPointDown
                    new_state.breakPointMissUp = current_state.breakPointMissUp
                    new_state.breakPointMissDown = current_state.breakPointMissDown
                    new_state.firstServeWonUp = current_state.firstServeWonUp
                    new_state.firstServeWonDown = current_state.firstServeWonDown
                    new_state.firstServeLostUp = current_state.firstServeLostUp
                    new_state.firstServeLostDown = current_state.firstServeLostDown
                    new_state.secondServeWonUp = current_state.secondServeWonUp
                    new_state.secondServeWonDown = current_state.secondServeWonDown
                    new_state.secondServeLostUp = current_state.secondServeLostUp
                    new_state.secondServeLostDown = current_state.secondServeLostDown
                    new_state.doubleFaultUp = current_state.doubleFaultUp
                    new_state.doubleFaultDown = current_state.doubleFaultDown
                    new_state.unforcedErrorUp = current_state.unforcedErrorUp
                    new_state.unforcedErrorDown = current_state.unforcedErrorDown
                    new_state.forehandWinnerUp  = current_state.forehandWinnerUp
                    new_state.forehandWinnerDown = current_state.forehandWinnerDown
                    new_state.backhandWinnerUp = current_state.backhandWinnerUp
                    new_state.backhandWinnerDown = current_state.backhandWinnerDown
                    new_state.forehandVolleyUp = current_state.forehandVolleyUp
                    new_state.forehandVolleyDown = current_state.forehandVolleyDown
                    new_state.backhandVolleyUp = current_state.backhandVolleyUp
                    new_state.backhandVolleyDown = current_state.backhandVolleyDown
                    new_state.foulToLoseUp = current_state.foulToLoseUp
                    new_state.foulToLoseDown = current_state.foulToLoseDown
                    
                    for i in 1...set_limit {
                        new_state.setGameUp(set: i, game: current_state.getGameUp(set: i))
                        new_state.setGameDown(set: i, game: current_state.getGameDown(set: i))
                        new_state.setPointUp(set: i, point: current_state.getPointUp(set: i))
                        new_state.setPointDown(set: i, point: current_state.getPointDown(set: i))
                        new_state.setTiebreakPointUp(set: i, point: current_state.getTiebreakPointUp(set: i))
                        new_state.setTiebreakPointDown(set: i, point: current_state.getTiebreakPointDown(set: i))
                    }
                    
                    if current_state.isServe == true { //you serve
                        print("You serve")
                        
                        first = current_state.firstServeLostDown + first_serve_count
                        first_miss = current_state.firstServeMissDown + first_serve_miss
                        second = current_state.secondServeDown + second_serve_count
                        
                        new_state.firstServeDown = first
                        new_state.firstServeMissDown = first_miss
                        new_state.secondServeDown = second
                        //win on your own
                        new_state.aceCountDown = new_state.aceCountDown + ace_count
                        new_state.forehandWinnerDown = new_state.forehandWinnerDown + forehand_winner_count
                        new_state.backhandWinnerDown = new_state.backhandWinnerDown + backhand_winner_count
                        new_state.forehandVolleyDown = new_state.forehandVolleyDown + forehand_volley_count
                        new_state.backhandVolleyDown = new_state.backhandVolleyDown + backhand_volley_count
                        //win on oppt lose
                        new_state.unforcedErrorUp = new_state.unforcedErrorUp + unforced_errors_count
                        new_state.foulToLoseUp = new_state.foulToLoseUp + foul_to_lose_count
                        //score on first serve or second serve
                        if is_second_serve {
                            new_state.secondServeWonDown = new_state.secondServeWonDown + second_serve_won
                        } else {
                            new_state.firstServeWonDown = new_state.firstServeWonDown + first_serve_won
                        }
                    } else { //oppt serve
                        print("Oppt serve")
                        first = current_state.firstServeUp + first_serve_count
                        first_miss = current_state.firstServeMissUp + first_serve_miss
                        second = current_state.secondServeUp + second_serve_count
                        
                        new_state.firstServeUp = first
                        new_state.firstServeMissUp = first_miss
                        new_state.secondServeUp = second
                        
                        //win on your own
                        new_state.forehandWinnerDown = new_state.forehandWinnerDown + forehand_winner_count
                        new_state.backhandWinnerDown = new_state.backhandWinnerDown + backhand_winner_count
                        new_state.forehandVolleyDown = new_state.forehandVolleyDown + forehand_volley_count
                        new_state.backhandVolleyDown = new_state.backhandVolleyDown + backhand_volley_count
                        //win on oppt lose
                        new_state.doubleFaultUp = new_state.doubleFaultUp + double_faults_count
                        new_state.unforcedErrorUp = new_state.unforcedErrorUp + unforced_errors_count
                        new_state.foulToLoseUp = new_state.foulToLoseUp + foul_to_lose_count
                        
                        if is_second_serve == true {
                            new_state.secondServeLostUp = new_state.secondServeLostUp + second_serve_lost
                        } else {
                            new_state.firstServeLostUp = new_state.firstServeLostUp + first_serve_lost
                        }
                    }
                    //you score!
                    var point: UInt8 = current_state.getPointDown(set: current_set)
                    point = point + 1
                    print("Your point \(current_state.getPointDown(set: current_set)) change to \(point)")
                    new_state.setPointDown(set: current_set, point: point)
                    
                    checkPoint(new_state: new_state)
                    
                    checkGames(new_state: new_state)
                    //score, reset
                    new_state.isSecondServe = false
                    imgServeUp.image = UIImage(named: "ball_green")
                    imgServeDown.image = UIImage(named: "ball_green")
                    print("=== I score end ===")
                    break
                case .OPPT_SCORE:
                    new_state.current_set = current_state.current_set
                    new_state.isServe = current_state.isServe
                    new_state.isInTiebreak = current_state.isInTiebreak
                    new_state.isFinish = current_state.isFinish
                    
                    if is_second_serve == true {
                        new_state.isSecondServe = true
                    } else {
                        new_state.isSecondServe = false
                    }
                    
                    new_state.setsUp = current_state.setsUp
                    new_state.setSDown = current_state.setSDown
                    
                    new_state.duration = time_use
                    
                    new_state.aceCountUp = current_state.aceCountUp
                    new_state.aceCountDown = current_state.aceCountDown
                    new_state.firstServeUp = current_state.firstServeUp
                    new_state.firstServeDown = current_state.firstServeDown
                    new_state.breakPointUp = current_state.breakPointUp
                    new_state.breakPointDown = current_state.breakPointDown
                    new_state.breakPointMissUp = current_state.breakPointMissUp
                    new_state.breakPointMissDown = current_state.breakPointMissDown
                    new_state.firstServeWonUp = current_state.firstServeWonUp
                    new_state.firstServeWonDown = current_state.firstServeWonDown
                    new_state.firstServeLostUp = current_state.firstServeLostUp
                    new_state.firstServeLostDown = current_state.firstServeLostDown
                    new_state.secondServeWonUp = current_state.secondServeWonUp
                    new_state.secondServeWonDown = current_state.secondServeWonDown
                    new_state.secondServeLostUp = current_state.secondServeLostUp
                    new_state.secondServeLostDown = current_state.secondServeLostDown
                    new_state.doubleFaultUp = current_state.doubleFaultUp
                    new_state.doubleFaultDown = current_state.doubleFaultDown
                    new_state.unforcedErrorUp = current_state.unforcedErrorUp
                    new_state.unforcedErrorDown = current_state.unforcedErrorDown
                    new_state.forehandWinnerUp  = current_state.forehandWinnerUp
                    new_state.forehandWinnerDown = current_state.forehandWinnerDown
                    new_state.backhandWinnerUp = current_state.backhandWinnerUp
                    new_state.backhandWinnerDown = current_state.backhandWinnerDown
                    new_state.forehandVolleyUp = current_state.forehandVolleyUp
                    new_state.forehandVolleyDown = current_state.forehandVolleyDown
                    new_state.backhandVolleyUp = current_state.backhandVolleyUp
                    new_state.backhandVolleyDown = current_state.backhandVolleyDown
                    new_state.foulToLoseUp = current_state.foulToLoseUp
                    new_state.foulToLoseDown = current_state.foulToLoseDown
                    
                    for i in 1...set_limit {
                        new_state.setGameUp(set: i, game: current_state.getGameUp(set: i))
                        new_state.setGameDown(set: i, game: current_state.getGameDown(set: i))
                        new_state.setPointUp(set: i, point: current_state.getPointUp(set: i))
                        new_state.setPointDown(set: i, point: current_state.getPointDown(set: i))
                        new_state.setTiebreakPointUp(set: i, point: current_state.getTiebreakPointUp(set: i))
                        new_state.setTiebreakPointDown(set: i, point: current_state.getTiebreakPointDown(set: i))
                    }
                    
                    if current_state.isServe { //you serve
                        print("You serve")
                        
                        first = current_state.firstServeLostDown + first_serve_count
                        first_miss = current_state.firstServeMissDown + first_serve_miss
                        second = current_state.secondServeDown + second_serve_count
                        
                        new_state.firstServeDown = first
                        new_state.firstServeMissDown = first_miss
                        new_state.secondServeDown = second
                        //win on oppt own
                        
                        new_state.forehandWinnerUp = new_state.forehandWinnerUp + forehand_winner_count
                        new_state.backhandWinnerUp = new_state.backhandWinnerUp + backhand_winner_count
                        new_state.forehandVolleyUp = new_state.forehandVolleyUp + forehand_volley_count
                        new_state.backhandVolleyUp = new_state.backhandVolleyUp + backhand_volley_count
                        //win on your lose
                        new_state.doubleFaultDown = new_state.doubleFaultDown + double_faults_count
                        new_state.unforcedErrorDown = new_state.unforcedErrorDown + unforced_errors_count
                        new_state.foulToLoseDown = new_state.foulToLoseDown + foul_to_lose_count
                        
                        //you serve, oppt scored
                        if is_second_serve {
                            new_state.secondServeLostDown = new_state.secondServeLostDown + second_serve_lost
                        } else {
                            new_state.firstServeLostDown = new_state.firstServeLostDown + first_serve_lost
                        }
                    } else { //oppt serve
                        print("Oppt serve")
                        first = current_state.firstServeUp + first_serve_count
                        first_miss = current_state.firstServeMissUp + first_serve_miss
                        second = current_state.secondServeUp + second_serve_count
                        
                        new_state.firstServeUp = first
                        new_state.firstServeMissUp = first_miss
                        new_state.secondServeUp = second
                        
                        //win on oppt own
                        new_state.aceCountUp = new_state.aceCountUp + ace_count
                        new_state.forehandWinnerUp = new_state.forehandWinnerUp + forehand_winner_count
                        new_state.backhandWinnerUp = new_state.backhandWinnerUp + backhand_winner_count
                        new_state.forehandVolleyUp = new_state.forehandVolleyUp + forehand_volley_count
                        new_state.backhandVolleyUp = new_state.backhandVolleyUp + backhand_volley_count
                        //win on oppt lose
                        new_state.unforcedErrorDown = new_state.unforcedErrorDown + unforced_errors_count
                        new_state.foulToLoseDown = new_state.foulToLoseDown + foul_to_lose_count
                        
                        if is_second_serve == true {
                            new_state.secondServeWonUp = new_state.secondServeWonUp + second_serve_won
                        } else {
                            new_state.firstServeWonUp = new_state.firstServeWonUp + first_serve_won
                        }
                        
                        
                        
                    }
                    
                    //oppt score!
                    var point: UInt8 = current_state.getPointUp(set: current_set)
                    point = point + 1
                    print("Oppt point \(current_state.getPointUp(set: current_set)) change to \(point)")
                    new_state.setPointUp(set: current_set, point: point)
                    
                    checkPoint(new_state: new_state)
                    
                    checkGames(new_state: new_state)
                    //score, reset
                    new_state.isSecondServe = false
                    imgServeUp.image = UIImage(named: "ball_green")
                    imgServeDown.image = UIImage(named: "ball_green")
                    break
                
                } //switch end
                
                print("###### new state start ######")
                print("current_set : \(new_state.current_set)")
                print("serve : \(new_state.isServe)")
                print("In tiebreak : \(new_state.isInTiebreak)")
                print("Finish : \(new_state.isFinish)")
                print("Second serve : \(new_state.isSecondServe)")
                print("Ace : up = \(new_state.aceCountUp) down = \(new_state.aceCountDown)")
                print("Double Faults : up = \(new_state.doubleFaultUp) down = \(new_state.doubleFaultDown)")
                print("First serve miss/count : up = \(new_state.firstServeMissUp)/\(new_state.firstServeUp) down = \(new_state.firstServeMissDown)/\(new_state.firstServeDown)")
                print("Second serve miss/count : up = \(new_state.doubleFaultUp)/\(new_state.secondServeUp) down = \(new_state.doubleFaultDown)/\(new_state.secondServeDown)")
                print("First serve lost/won : up = \(new_state.firstServeLostUp)/\(new_state.firstServeWonUp) down = \(new_state.firstServeLostDown)/\(new_state.firstServeWonDown))")
                print("Second serve lost/won : up = \(new_state.secondServeLostUp)/\(new_state.secondServeWonUp) down = \(new_state.secondServeLostDown)/\(new_state.secondServeWonDown)")
                print("===============================================================================")
                print("Unforeced Error : up = \(new_state.unforcedErrorUp) down = \(new_state.unforcedErrorDown)")
                print("Forehand winner : up = \(new_state.forehandWinnerUp) down = \(new_state.forehandWinnerDown)")
                print("Backhand Winner : up = \(new_state.backhandWinnerUp) down = \(new_state.backhandWinnerDown)")
                print("Forehand Volley : up = \(new_state.forehandVolleyUp) down = \(new_state.forehandVolleyDown)")
                print("Backhand volley : up = \(new_state.backhandVolleyUp) down = \(new_state.backhandVolleyDown)")
                print("Foul to lose : up = \(new_state.foulToLoseUp) down = \(new_state.foulToLoseDown)")
                print("Set up : \(new_state.setsUp)")
                print("Set down : \(new_state.setSDown)")
                print("Duration : \(new_state.duration)")
                
                for i in 1...set_limit {
                    print("=================================================")
                    print("[set \(i)]")
                    print("[Game : \(new_state.getGameUp(set: i))/\(new_state.getGameDown(set: i))]")
                    print("[Point : \(new_state.getPointUp(set: i))/\(new_state.getPointDown(set: i))]")
                    print("[tiebreak : \(new_state.getTiebreakPointUp(set: i))/\(new_state.getTiebreakPointDown(set: i))]")
                }
                print("###### new state end ######")
                
                current_set = new_state.current_set
                
                if new_state.setsUp > 0 || new_state.setSDown > 0 {
                    labelOpptSet.isHidden = false
                    labelYouSet.isHidden = false
                    labelOpptSet.text = String(new_state.setsUp)
                    labelYouSet.text = String(new_state.setSDown)
                } else {
                    labelOpptSet.isHidden = false
                    labelYouSet.isHidden = false
                    labelOpptSet.text = "0"
                    labelYouSet.text = "0"
                }
                
                labelOpptGame.text = String(new_state.getGameUp(set: current_set))
                labelYouGame.text = String(new_state.getGameDown(set: current_set))
                
                if new_state.isFinish {
                    imgServeUp.isHidden = true
                    imgServeDown.isHidden = true
                    
                    if action == .YOU_RETIRE {
                        imgWinCheckUp.isHidden = false
                        imgWinCheckDown.isHidden = true
                    } else if action == .OPPT_RETIRE {
                        imgWinCheckUp.isHidden = true
                        imgWinCheckDown.isHidden = false
                    } else {
                        if new_state.setsUp > new_state.setSDown { //oppt win this match
                            imgWinCheckUp.isHidden = false
                            imgWinCheckDown.isHidden = true
                        } else {
                            imgWinCheckUp.isHidden = true
                            imgWinCheckDown.isHidden = false
                        }
                    }
                    
                    
                } else { //not finish
                    if new_state.isServe == true {
                        imgServeUp.isHidden = true
                        imgServeDown.isHidden = false
                    } else {
                        imgServeUp.isHidden = false
                        imgServeDown.isHidden = true
                    }
                } //end new_state is finish
                
                if new_state.isInTiebreak == false { //not in tiebreak
                    if new_state.getPointUp(set: current_set) == 1 {
                        labelOpptPoint.text = "15"
                    } else if new_state.getPointUp(set: current_set) == 2 {
                        labelOpptPoint.text = "30"
                    } else if new_state.getPointUp(set: current_set) == 3 {
                        labelOpptPoint.text = "40"
                    } else if new_state.getPointUp(set: current_set) == 4 {
                        labelOpptPoint.text = "40A"
                    } else {
                        labelOpptPoint.text = "0"
                    }
                } else {
                    labelOpptPoint.text = String(new_state.getPointUp(set: current_set))
                }
                
                if new_state.isInTiebreak == false { //not in tiebreak
                    if new_state.getPointDown(set: current_set) == 1 {
                        labelYouPoint.text = "15"
                    } else if new_state.getPointDown(set: current_set) == 2 {
                        labelYouPoint.text = "30"
                    } else if new_state.getPointDown(set: current_set) == 3 {
                        labelYouPoint.text = "40"
                    } else if new_state.getPointDown(set: current_set) == 4 {
                        labelYouPoint.text = "40A"
                    } else {
                        labelYouPoint.text = "0"
                    }
                } else {
                    labelYouPoint.text = String(new_state.getPointDown(set: current_set))
                }
                
                stack.push(obj: new_state)
            } //game not finish end
            
        } else { //stack is empty
            print("current_state is nil")
            //var new_state = State()
            
            print("first_serve_count = \(first_serve_count)")
            print("first_serve_miss = \(first_serve_miss)")
            print("second_serve_count = \(second_serve_count)")
            print("first_serve_won = \(first_serve_won)")
            print("first_serve_lost = \(first_serve_lost)")
            print("second_serve_won = \(second_serve_won)")
            print("second_serve_lost = \(second_serve_lost)")
        
            if is_serve == true { //you serve first
                new_state.isServe = true
            } else {
                new_state.isServe = false
            }
            
            if is_second_serve == true {
                new_state.isSecondServe = true
                imgServeUp.image = UIImage(named: "ball_red")
                imgServeDown.image = UIImage(named: "ball_red")
            } else {
                new_state.isSecondServe = false
                imgServeUp.image = UIImage(named: "ball_green")
                imgServeDown.image = UIImage(named: "ball_green")
            }
            
            new_state.current_set = 1
            current_set = new_state.current_set
            new_state.duration = time_use;
            
            switch action {
            case .YOU_RETIRE:
                print("=== I retire start ===")
                new_state.isFinish = true
                imgWinCheckUp.isHidden = false
                print("=== I retire end ===")
                break
            case .OPPT_RETIRE:
                print("=== Oppt retire start ===")
                new_state.isFinish = true
                imgWinCheckDown.isHidden = false
                print("=== Oppt retire end ===")
                break
            case .YOU_SERVE:
                print("=== I serve start ===")
                new_state.firstServeDown = first_serve_count
                new_state.firstServeMissDown = first_serve_miss
                first_serve_count = 0
                first_serve_miss = 0
                print("=== I serve end ===")
                break
            case .OPPT_SERVE:
                print("=== Oppt serve start ===")
                new_state.firstServeUp = first_serve_count
                new_state.firstServeMissUp = first_serve_miss
                first_serve_count = 0
                first_serve_miss = 0
                print("=== Oppt serve end ===")
                break
            case .YOU_SCORE:
                print("=== I score start ===")
                if new_state.isServe == true {
                    print("I serve")
                    new_state.firstServeDown = first_serve_count
                    new_state.firstServeMissDown = first_serve_miss
                    new_state.secondServeDown = second_serve_count
                    //win on your own
                    new_state.aceCountDown = ace_count
                    new_state.forehandWinnerDown = forehand_winner_count
                    new_state.backhandWinnerDown = backhand_winner_count
                    new_state.forehandVolleyDown = forehand_volley_count
                    new_state.backhandVolleyDown = backhand_volley_count
                    //win on oppt lose
                    new_state.unforcedErrorDown = unforced_errors_count
                    new_state.foulToLoseDown = foul_to_lose_count
                    
                    new_state.firstServeWonDown = first_serve_won
                    new_state.firstServeLostDown = first_serve_lost
                    new_state.secondServeWonDown = second_serve_won
                    new_state.secondServeLostDown = second_serve_lost
                    
                } else { //oppt serve
                    print("Oppt serve")
                    new_state.firstServeUp = first_serve_count
                    new_state.firstServeMissUp = first_serve_miss
                    new_state.secondServeUp = second_serve_count
                    //win on your own
                    new_state.forehandWinnerDown = forehand_winner_count
                    new_state.backhandWinnerDown = backhand_winner_count
                    new_state.forehandVolleyDown = forehand_volley_count
                    new_state.backhandVolleyDown = backhand_volley_count
                    //win on oppt lose
                    new_state.doubleFaultUp = double_faults_count
                    new_state.unforcedErrorUp = unforced_errors_count
                    new_state.foulToLoseUp = foul_to_lose_count
                
                    new_state.firstServeWonUp = first_serve_won
                    new_state.firstServeLostUp = first_serve_lost
                    new_state.secondServeWonUp = second_serve_won
                    new_state.secondServeLostUp = second_serve_lost
                }
                
                new_state.setPointDown(set: current_set, point: 1)
                
                print("=== I score end ===")
                break
            case .OPPT_SCORE:
                print("=== Oppt score start ===")
                
                if new_state.isServe == true { //I serve
                    print("I serve")
                    
                    new_state.firstServeDown = first_serve_count
                    new_state.firstServeMissDown = first_serve_miss
                    new_state.secondServeDown = second_serve_count
                    
                    //win on oppt own
                    new_state.forehandWinnerUp = forehand_winner_count
                    new_state.backhandWinnerUp = backhand_winner_count
                    new_state.forehandVolleyUp = forehand_volley_count
                    new_state.backhandVolleyUp = backhand_volley_count
                    //win on you lose
                    new_state.doubleFaultDown = double_faults_count
                    new_state.unforcedErrorDown = unforced_errors_count
                    new_state.foulToLoseDown = foul_to_lose_count
                    
                    new_state.firstServeWonDown = first_serve_won
                    new_state.firstServeLostDown = first_serve_lost
                    new_state.secondServeWonDown = second_serve_won
                    new_state.secondServeLostDown = second_serve_lost
                    
                } else { //oppt serve
                    print("oppt serve")
                    
                    new_state.firstServeUp = first_serve_count
                    new_state.firstServeMissUp = first_serve_miss
                    new_state.secondServeUp = second_serve_count
                    
                    //win on oppt own
                    new_state.aceCountUp = ace_count
                    new_state.forehandWinnerUp = forehand_winner_count
                    new_state.backhandWinnerUp = backhand_winner_count
                    new_state.forehandVolleyUp = forehand_volley_count
                    new_state.backhandVolleyUp = backhand_volley_count
                    //win on you lose
                    new_state.unforcedErrorDown = unforced_errors_count
                    new_state.foulToLoseDown = foul_to_lose_count
                    
                    new_state.firstServeWonUp = first_serve_won
                    new_state.firstServeLostUp = first_serve_lost
                    new_state.secondServeWonUp = second_serve_won
                    new_state.secondServeLostUp = second_serve_lost
                }
                
                new_state.setPointUp(set: current_set, point: 1)
                
                print("=== Oppt score end ===")
                break
            }
        }
        
        stack.push(obj: new_state)
        
        current_set = new_state.current_set
        
        labelOpptGame.text = String(new_state.getGameUp(set: current_set))
        labelYouGame.text = String(new_state.getGameDown(set: current_set))
        
        if (new_state.isServe == true) {
            imgServeUp.isHidden = true
            imgServeDown.isHidden = false
        } else {
            imgServeUp.isHidden = false
            imgServeDown.isHidden = true
        }
        
        
        
        if new_state.isInTiebreak == false {
            switch new_state.getPointUp(set: current_set) {
            case 1:
                labelOpptPoint.text = "15"
                break
            case 2:
                labelOpptPoint.text = "30"
                break
            case 3:
                labelOpptPoint.text = "40"
                break
            case 4:
                labelOpptPoint.text = "40A"
                break
            default:
                labelOpptPoint.text = "0"
            }
        } else {
            labelOpptPoint.text = String(new_state.getPointUp(set: current_set))
        }
        
        if new_state.isInTiebreak == false {
            switch new_state.getPointDown(set: current_set) {
            case 1:
                labelYouPoint.text = "15"
                break
            case 2:
                labelYouPoint.text = "30"
                break
            case 3:
                labelYouPoint.text = "40"
                break
            case 4:
                labelYouPoint.text = "40A"
                break
            default:
                labelYouPoint.text = "0"
            }
        } else {
            labelOpptPoint.text = String(new_state.getPointUp(set: current_set))
        }
        
        
        
        ace_count = 0
        double_faults_count = 0
        unforced_errors_count = 0
        forehand_winner_count = 0
        backhand_winner_count = 0
        forehand_volley_count = 0
        backhand_volley_count = 0
        foul_to_lose_count = 0
        first_serve_count = 0
        first_serve_miss = 0
        second_serve_count = 0
        
        first_serve_won = 0
        first_serve_lost = 0
        second_serve_won = 0
        second_serve_lost = 0
        
        
        print("=== calculatePoint end ===")
    }
    
    func checkPoint(new_state: State) {
        print("=== checkPoint start ===")
        
        var current_set: UInt8 = new_state.current_set
        
        if new_state.isInTiebreak == true {
            print("[In tiebreak]")
            
            var game:UInt8 = 0
            
            if new_state.getPointUp(set: current_set) == 7 && new_state.getPointDown(set: current_set) <= 5 {
                //7 : 0,1,2,3,4,5 => oppt win this game
                //set tiebreak point
                new_state.setTiebreakPointUp(set: current_set, point: new_state.getPointUp(set: current_set))
                new_state.setTiebreakPointDown(set: current_set, point: new_state.getPointDown(set: current_set))
                //set point clean
                new_state.setPointUp(set: current_set, point: 0)
                new_state.setPointDown(set: current_set, point: 0)
                //add to game
                game = new_state.getGameUp(set: current_set)
                game = game + 1
                new_state.setGameUp(set: current_set, game: game)
                //change serve
                if new_state.isServe == true {
                    new_state.isServe = false
                } else {
                    new_state.isServe = true
                }
                
                //leave tiebreak
                new_state.isInTiebreak = false
            } else if new_state.getPointUp(set: current_set) >= 6 &&
                    new_state.getPointDown(set: current_set) >= 6 &&
                new_state.getPointUp(set: current_set) - new_state.getPointDown(set: current_set) == 2 {
                //8:6, 9:7, 10:8 => oppt win this game
                //set tiebreak point
                new_state.setTiebreakPointUp(set: current_set, point: new_state.getPointUp(set: current_set))
                new_state.setTiebreakPointDown(set: current_set, point: new_state.getPointDown(set: current_set))
                //set point clean
                new_state.setPointUp(set: current_set, point: 0)
                new_state.setPointDown(set: current_set, point: 0)
                
                //add to game
                game = new_state.getGameUp(set: current_set)
                game = game + 1
                new_state.setGameUp(set: current_set, game: game)
                //change serve
                if new_state.isServe == true {
                    new_state.isServe = false
                } else {
                    new_state.isServe = true
                }
                
                //leave tiebreak
                new_state.isInTiebreak = false
            } else if new_state.getPointUp(set: current_set) >= 6 &&
                new_state.getPointDown(set: current_set) >= 6 &&
                new_state.getPointDown(set: current_set) - new_state.getPointUp(set: current_set) == 2 {
                //6:8, 7:9, 8:10 => you win this game
                //set tiebreak point
                new_state.setTiebreakPointUp(set: current_set, point: new_state.getPointUp(set: current_set))
                new_state.setTiebreakPointDown(set: current_set, point: new_state.getPointDown(set: current_set))
                //set point clean
                new_state.setPointUp(set: current_set, point: 0)
                new_state.setPointDown(set: current_set, point: 0)
                
                //add to game
                game = new_state.getGameDown(set: current_set)
                game = game + 1
                new_state.setGameDown(set: current_set, game: game)
                //change serve
                if new_state.isServe == true {
                    new_state.isServe = false
                } else {
                    new_state.isServe = true
                }
                
                //leave tiebreak
                new_state.isInTiebreak = false
            } else {
                print("other in tiebreak")
            }
            
            //In tiebreak, player serve twice in turns
            var plus:UInt8 = new_state.getPointUp(set: current_set) + new_state.getPointDown(set: current_set)
            
            if plus%2 == 1 {
                print("===> Points plus become odd, change serve")
                if new_state.isServe == true {
                    new_state.isServe = false
                } else {
                    new_state.isServe = true
                }
            }
            
        } else {
            print("[Not in tiebreak]")
            
            if self.is_deuce == true {
                print("[Game using deuce]")
                var game:UInt8 = 0
                
                if new_state.getPointUp(set: current_set) == 4 && new_state.getPointDown(set: current_set) == 4 { // 40A:40A => 40:40
                    print("40A:40A => 40:40")
                    
                    new_state.setPointUp(set: current_set, point: 3)
                    new_state.setPointDown(set: current_set, point: 3)
                    
                    if is_break_point == true {
                        print("In break point")
                        if new_state.isServe == true { //you serve
                            new_state.breakPointUp = new_state.breakPointUp + 1
                            new_state.breakPointMissUp = new_state.breakPointMissUp + 1
                        } else { //oppt serve
                            new_state.breakPointDown = new_state.breakPointDown + 1
                            new_state.breakPointMissDown = new_state.breakPointMissDown + 1
                        }
                    } else {
                        print("Not in break point")
                    }
                    is_break_point = false
                } else if new_state.getPointUp(set: current_set) == 5 && new_state.getPointDown(set: current_set) == 3 { //40A+ : 40 => oppt win this game
                    print("40A+1 : 40 => oppt win this game")
                    new_state.setPointUp(set: current_set, point: 0)
                    new_state.setPointDown(set: current_set, point: 0)
                    //add to game
                    game = new_state.getGameUp(set: current_set)
                    game = game + 1
                    new_state.setGameUp(set: current_set, game: game)
                    
                    if is_break_point == true {
                        if new_state.isServe == true { //you serve 
                            print("You serve, oppt got this point")
                            new_state.breakPointUp = new_state.breakPointUp + 1
                        } else {
                            print("Oppt serve")
                        }
                    }
                    
                    //change serve
                    if new_state.isServe == true {
                        new_state.isServe = false
                    } else {
                        new_state.isServe = true
                    }
                    is_break_point = false
                } else if new_state.getPointUp(set: current_set) == 3 && new_state.getPointDown(set: current_set) == 5 { //40 : 40A+ => you win this game
                    print("40 : 40A+1 => you win this game")
                    new_state.setPointUp(set: current_set, point: 0)
                    new_state.setPointDown(set: current_set, point: 0)
                    
                    //add to game
                    game = new_state.getGameDown(set: current_set)
                    game = game + 1
                    new_state.setGameDown(set: current_set, game: game)
                    
                    if is_break_point == true {
                        if new_state.isServe == true { //you serve
                            print("You serve")
                        } else {
                            print("Oppt serve, you got this break point")
                            new_state.breakPointDown = new_state.breakPointDown + 1
                        }
                    }
                    
                    //change serve
                    if new_state.isServe == true {
                        new_state.isServe = false
                    } else {
                        new_state.isServe = true
                    }
                    is_break_point = false
                    
                } else if new_state.getPointUp(set: current_set) == 4 && new_state.getPointDown(set: current_set) <= 2 {
                    print("40A : 0, 40A: 15, 40A : 30 => oppt win this game")
                    new_state.setPointUp(set: current_set, point: 0)
                    new_state.setPointDown(set: current_set, point: 0)
                
                    //add to game
                    game = new_state.getGameUp(set: current_set)
                    game = game + 1
                    new_state.setGameUp(set: current_set, game: game)
                    
                    if is_break_point == true {
                        if new_state.isServe == true { //you serve
                            print("You serve, oppt got this point")
                            new_state.breakPointUp = new_state.breakPointUp + 1
                        } else {
                            print("Oppt serve")
                        }
                    }
                    
                    //change serve
                    if new_state.isServe == true {
                        new_state.isServe = false
                    } else {
                        new_state.isServe = true
                    }
                    is_break_point = false
                } else if new_state.getPointUp(set: current_set) <= 2 && new_state.getPointDown(set: current_set) == 4 {
                    print("0 : 40A, 15 : 40A, 30 : 40A => you win this game")
                    new_state.setPointUp(set: current_set, point: 0)
                    new_state.setPointDown(set: current_set, point: 0)
                    
                    //add to game
                    game = new_state.getGameDown(set: current_set)
                    game = game + 1
                    new_state.setGameDown(set: current_set, game: game)
                    
                    if is_break_point == true {
                        if new_state.isServe == true { //you serve
                            print("You serve")
                        } else {
                            print("Oppt serve, you got this break point")
                            new_state.breakPointDown = new_state.breakPointDown + 1
                        }
                    }
                    
                    //change serve
                    if new_state.isServe == true {
                        new_state.isServe = false
                    } else {
                        new_state.isServe = true
                    }
                    is_break_point = false
                } else {
                    print("Points change without arrange")
                    
                    if new_state.getPointUp(set: current_set) == 3 &&
                        new_state.getPointDown(set: current_set) <= 2 &&
                        is_break_point == false { //40:0, 40:15, 40:30
                        
                        if new_state.isServe {
                            print("You serve, Not in break point => In break point")
                            is_break_point = true
                        } else {
                            print("Oppt serve")
                        }
                    } else if new_state.getPointUp(set: current_set) <= 2 &&
                        new_state.getPointDown(set: current_set) == 3 &&
                        is_break_point == false { //0:40, 15:40, 30:40
                        if new_state.isServe {
                            print("You serve")
                        } else {
                            print("Oppt serve, Not in break point => In break point")
                            is_break_point = true
                        }
                    } else if new_state.getPointUp(set: current_set) == 4 &&
                        new_state.getPointDown(set: current_set) == 3 &&
                        is_break_point == false { // 40A : 40
                        
                        if new_state.isServe {
                            print("You serve, Not in break point => In break point")
                            is_break_point = true
                        } else {
                            print("Oppt serve")
                        }
                    } else if new_state.getPointUp(set: current_set) == 3 &&
                        new_state.getPointDown(set: current_set) == 4 &&
                        is_break_point == false { // 40 : 40A
                        
                        if new_state.isServe {
                            print("You serve")
                        } else {
                            print("Oppt serve, Not in break point => In break point")
                            is_break_point = true
                        }
                    } else if new_state.getPointUp(set: current_set) == 3 &&
                        new_state.getPointDown(set: current_set) == 3 { // 40 : 40
                        print("become deuce")
                        if is_break_point == true { //break point => deuce
                            if new_state.isServe == true { //you serve
                                new_state.breakPointUp = new_state.breakPointUp + 1
                                new_state.breakPointMissUp = new_state.breakPointMissUp + 1
                            } else { //oppt serve
                                new_state.breakPointDown = new_state.breakPointDown + 1
                                new_state.breakPointMissDown = new_state.breakPointMissDown + 1
                            }
                        } else {
                            print("not in break point")
                        }
                        is_break_point = false
                    } else { //other point 40:0 => 40:15, 40:15 => 40:30, 0:40 => 15:40, 15:40 => 30:40
                        
                        if is_break_point == true { //in break point situation
                            print("In break point")
                            print("40:0 => 40:15, 40:15 => 40:30, 0:40 => 15:40, 15:40 => 30:40")
                            if new_state.isServe == true { //you serve
                                new_state.breakPointUp = new_state.breakPointUp + 1
                                new_state.breakPointMissUp = new_state.breakPointMissUp + 1
                            } else { //oppt serve
                                new_state.breakPointDown = new_state.breakPointDown + 1
                                new_state.breakPointMissDown = new_state.breakPointMissDown + 1
                            }
                            
                        } else {
                            print("Not in break point")
                        }
                    }
                    
                }
                
            } else {
                print("[Game using deciding point]")
                var game:UInt8 = 0
                
                if new_state.getPointUp(set: current_set) == 4 &&
                    new_state.getPointDown(set: current_set) <= 3 { //40A : 40,30,15,0 => oppt win this game
                    //set point clean
                    new_state.setPointUp(set: current_set, point: 0)
                    new_state.setPointDown(set: current_set, point: 0)
                    //add to game
                    game = new_state.getGameUp(set: current_set)
                    game = game + 1
                    new_state.setGameUp(set: current_set, game: game)
                    //change serve
                    if new_state.isServe { //you serve
                        new_state.isServe = false
                    } else {
                        new_state.isServe = true
                    }
                } else if new_state.getGameUp(set: current_set) <= 3 &&
                    new_state.getGameDown(set: current_set) == 4 { //40,30,15,0 : 40A => you win this game
                    //set point clean
                    //set point clean
                    new_state.setPointUp(set: current_set, point: 0)
                    new_state.setPointDown(set: current_set, point: 0)
                    //add to game
                    game = new_state.getGameDown(set: current_set)
                    game = game + 1
                    new_state.setGameDown(set: current_set, game: game)
                    //change serve
                    if new_state.isServe { //you serve
                        new_state.isServe = false
                    } else {
                        new_state.isServe = true
                    }
                } else {
                    print("points change without arrange")
                }
            }
        }
        
        new_state.isSecondServe = false
        
        print("=== checkPoint end ===")
    }
    
    func checkGames(new_state: State) {
        print("=== checkGame start ===")
        var current_set: UInt8 = new_state.current_set
        var setsWinUp: UInt8 = new_state.setsUp
        var setsWinDown: UInt8 = new_state.setSDown
        
        if is_tiebreak == true { //use tiebreak
            print("[Use tiebreak]")
            
            if new_state.getGameUp(set: current_set) == 6 &&
                new_state.getGameDown(set: current_set) == 6 {
                new_state.isInTiebreak = true //into tiebreak
            } else if new_state.getGameUp(set: current_set) == 7 &&
                new_state.getGameDown(set: current_set) == 5 { //7:5 => oppt win this set
                //set sets win
                setsWinUp = setsWinUp + 1
                new_state.setsUp = setsWinUp
                checkSets(new_state: new_state)
            } else if new_state.getGameUp(set: current_set) == 5 &&
                new_state.getGameDown(set: current_set) == 7 { //5:7 => you win this set
                //set sets win
                setsWinDown = setsWinDown + 1
                new_state.setSDown = setsWinDown
                checkSets(new_state: new_state)
            } else if new_state.getGameUp(set: current_set) == 7 &&
                new_state.getGameDown(set: current_set) == 6 { //7:6 => oppt win this set
                //set sets win
                setsWinUp = setsWinUp + 1
                new_state.setsUp = setsWinUp
                checkSets(new_state: new_state)
            } else if new_state.getGameUp(set: current_set) == 6 &&
                new_state.getGameDown(set: current_set) == 7 { //6:7 => you win this set
                //set sets win
                setsWinDown = setsWinDown + 1
                new_state.setSDown = setsWinDown
                checkSets(new_state: new_state)
            } else if new_state.getGameUp(set: current_set) == 6 &&
                new_state.getGameDown(set: current_set) <= 4 { //6:0,1,2,3,4 => oppt win this set
                //set sets win
                setsWinUp = setsWinUp + 1
                new_state.setsUp = setsWinUp
                checkSets(new_state: new_state)
            } else if new_state.getGameUp(set: current_set) <= 4 &&
                new_state.getGameDown(set: current_set) == 6 { //0,1,2,3,4:6 => you win this set
                //set sets win
                setsWinDown = setsWinDown + 1
                new_state.setSDown = setsWinDown
                checkSets(new_state: new_state)
            }
            
        } else { //use deciding game
            if new_state.getGameUp(set: current_set) == 6 &&
                new_state.getGameDown(set: current_set) <= 5 { //6:5 => oppt win this set
                //set sets win
                setsWinUp = setsWinUp + 1
                new_state.setsUp = setsWinUp
                //checkSets(new_state)
            } else if new_state.getGameUp(set: current_set) <= 5 &&
                new_state.getGameDown(set: current_set) == 6 { //5:6 => oppt win this set
                //set sets win
                setsWinDown = setsWinDown + 1
                new_state.setSDown = setsWinDown
                //checkSets(new_state)
            }
        }
        
        print("=== checkGame end ===")
    }
    
    func checkSets(new_state: State) {
        print("=== check sets start ===")
        var current_set:UInt8 = new_state.current_set
        var setsWinUp:UInt8 = new_state.setsUp
        var setsWinDown:UInt8 = new_state.setSDown
        
        switch set_select {
        case 0:
            if setsWinUp == 1 || setsWinDown == 1 {
                new_state.isFinish = true
                
            }
            break
        case 1:
            if setsWinUp == 2 || setsWinDown == 2 {
                new_state.isFinish = true
            } else {
                current_set = current_set + 1
                new_state.current_set = current_set
            }
            break
        case 2:
            if setsWinUp == 3 || setsWinDown == 3 {
                new_state.isFinish = true
            } else {
                current_set = current_set + 1
                new_state.current_set = current_set
            }
            break
        default:
            if setsWinUp == 1 || setsWinDown == 1 {
                new_state.isFinish = true
                
            }
            break
        }
        
        print("=== check sets end ===")
    }
}

