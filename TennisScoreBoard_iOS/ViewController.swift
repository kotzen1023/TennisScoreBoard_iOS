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
    @IBOutlet weak var labelTopPlayer: UILabel!
    @IBOutlet weak var labelBottomPlayer: UILabel!
    
    
    var scrollView: UIScrollView!
    var tableView: UITableView!
    
    var is_action_click: Bool!
    var is_serve: Bool!
    
    
    
    
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
        
        init_scrollview()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        is_serve = true
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
    @IBAction func onOpptClick(_ sender: UIButton) {
        //[UIView animateWithDuration:0.7 animations:^{
        //    huiView.frame = CGRectMake((self.view.bounds.size.width), self.topLayoutGuide.length-self.navigationController.navigationBar.frame.size.height,
        //    self.view.bounds.size.width,
        //    self.view.bounds.size.height);
        //    }];
        
        print("Oppt click")
        
        
        //UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
        //    self.scrollView.frame = CGRect(x: 0, y: 20, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        //}, completion: nil)
        
        
        
        // Create the action sheet
        let myActionSheet = UIAlertController(title: labelTopPlayer.text, message: NSLocalizedString("game_action_select", comment: ""), preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if is_serve  == false { //I serve
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
        } else {
            // Ace
            let aceAction = UIAlertAction(title: NSLocalizedString("game_action_ace", comment: ""), style: UIAlertActionStyle.default) { (action) in
                print("Ace")
            }
            
            // Ace
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
        
        
        // support iPads (popover view)
        //myActionSheet.popoverPresentationController?.sourceView = self.showActionSheetButton
        //myActionSheet.popoverPresentationController?.sourceRect = self.showActionSheetButton.bounds
        
        // present the action sheet
        self.present(myActionSheet, animated: true, completion: nil)
    }
}

