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
        
        print("You click")
        
        // Create the action sheet
        let myActionSheet = UIAlertController(title: labelTopPlayer.text, message: NSLocalizedString("game_action_select", comment: ""), preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if imgServeDown.isHidden == false { //you serve
            if is_second_serve { //second serve
                // Ace
                let aceAction = UIAlertAction(title: NSLocalizedString("game_action_ace", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Ace")
                    
                }
                
                // double faults
                let doubleFaultAction = UIAlertAction(title: NSLocalizedString("game_action_double_faults", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("double faults")
                }
                
                // unforced error
                let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Unforced Error")
                }
                
                // forehand winner
                let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Forehand Winner")
                }
                
                // backhand winner
                let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                }
                
                // forehand volley
                let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("forehand Winner")
                }
                
                // backhand volley
                let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                }
                
                // foul to lose
                let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                }
                
                // other winner
                let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("other winner")
                }
                
                // net
                let netAction = UIAlertAction(title: NSLocalizedString("game_action_net_in", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("net")
                }
                
                // retire
                let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("retire from game")
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
                }
                
                // unforced error
                let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Unforced Error")
                }
                
                // forehand winner
                let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Forehand Winner")
                }
                
                // backhand winner
                let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                }
                
                // forehand volley
                let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("forehand Winner")
                }
                
                // backhand volley
                let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                }
                
                // foul to lose
                let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                }
                
                // other winner
                let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("other winner")
                }
                
                // net
                let netAction = UIAlertAction(title: NSLocalizedString("game_action_net_in", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("net")
                }
                
                // retire
                let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("retire from game")
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
            // unforced error
            let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("Unforced Error")
            }
            
            // forehand winner
            let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("Forehand Winner")
            }
            
            // backhand winner
            let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("Backhand Winner")
            }
            
            // forehand volley
            let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("forehand Winner")
            }
            
            // backhand volley
            let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("Backhand Winner")
            }
            
            // foul to lose
            let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("foul to lose")
            }
            
            // other winner
            let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("foul to lose")
            }
            
            // retire
            let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("retire from game")
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
            
            if is_second_serve == true {
                // Ace
                let aceAction = UIAlertAction(title: NSLocalizedString("game_action_ace", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Ace")
                }
                
                // double faults
                let secondServeAction = UIAlertAction(title: NSLocalizedString("game_action_double_faults", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("double faults")
                }
                
                // unforced error
                let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Unforced Error")
                }
                
                // forehand winner
                let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Forehand Winner")
                }
                
                // backhand winner
                let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                }
                
                // forehand volley
                let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("forehand Winner")
                }
                
                // backhand volley
                let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                }
                
                // foul to lose
                let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                }
                
                // other winner
                let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                }
                
                // net
                let netAction = UIAlertAction(title: NSLocalizedString("game_action_net_in", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("net")
                }
                
                // retire
                let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("retire from game")
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
                }
                
                // second serve
                let secondServeAction = UIAlertAction(title: NSLocalizedString("game_action_second_serve", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Second serve")
                }
                
                // unforced error
                let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Unforced Error")
                }
                
                // forehand winner
                let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Forehand Winner")
                }
                
                // backhand winner
                let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                }
                
                // forehand volley
                let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("forehand Winner")
                }
                
                // backhand volley
                let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("Backhand Winner")
                }
                
                // foul to lose
                let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                }
                
                // other winner
                let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("foul to lose")
                }
                
                // net
                let netAction = UIAlertAction(title: NSLocalizedString("game_action_net_in", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("net")
                }
                
                // retire
                let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                    print("retire from game")
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
            // unforced error
            let unforceErrorAction = UIAlertAction(title: NSLocalizedString("game_action_unforce_error", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("Unforced Error")
            }
            
            // forehand winner
            let forehandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("Forehand Winner")
            }
            
            // backhand winner
            let backhandWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("Backhand Winner")
            }
            
            // forehand volley
            let forehandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_forehand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("forehand Winner")
            }
            
            // backhand volley
            let backhandVolleyAction = UIAlertAction(title: NSLocalizedString("game_action_backhand_volley", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("Backhand Winner")
            }
            
            // foul to lose
            let foulToLoseAction = UIAlertAction(title: NSLocalizedString("game_action_foul_to_lose", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("foul to lose")
            }
            
            // other winner
            let otherWinnerAction = UIAlertAction(title: NSLocalizedString("game_action_other_winner", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("foul to lose")
            }
            
            // retire
            let retireAction = UIAlertAction(title: NSLocalizedString("game_action_retire", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("retire from game")
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
}

