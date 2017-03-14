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
    
    var scrollView: UIScrollView!
    var tableView: UITableView!
    
    var is_action_click: Bool!
    
    
    
    
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
        let myActionSheet = UIAlertController(title: "Color", message: "What color would you like?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // blue action button
        let blueAction = UIAlertAction(title: "Blue", style: UIAlertActionStyle.default) { (action) in
            print("Blue action button tapped")
        }
        
        // red action button
        let redAction = UIAlertAction(title: "Red", style: UIAlertActionStyle.default) { (action) in
            print("Red action button tapped")
        }
        
        // yellow action button
        let yellowAction = UIAlertAction(title: "Yellow", style: UIAlertActionStyle.default) { (action) in
            print("Yellow action button tapped")
        }
        
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            print("Cancel action button tapped")
        }
        
        // add action buttons to action sheet
        myActionSheet.addAction(blueAction)
        myActionSheet.addAction(redAction)
        myActionSheet.addAction(yellowAction)
        myActionSheet.addAction(cancelAction)
        
        // support iPads (popover view)
        //myActionSheet.popoverPresentationController?.sourceView = self.showActionSheetButton
        //myActionSheet.popoverPresentationController?.sourceRect = self.showActionSheetButton.bounds
        
        // present the action sheet
        self.present(myActionSheet, animated: true, completion: nil)
    }
}

