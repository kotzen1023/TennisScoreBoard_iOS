//
//  VoiceListen.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2018/3/5.
//  Copyright © 2018年 RichieShih. All rights reserved.
//

import UIKit
import StoreKit
import AVFoundation


class VoiceListen: UIViewController,UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate , AVAudioPlayerDelegate{
    
    @IBOutlet weak var voiceListenTableView: UITableView!
    
    var voice_select: NSInteger = 0
    var voice_gbr_woman_purchased: Bool = false
    var voiceList: Array<String> = []
    var productIDs: Array<String> = []
    //var purchasedProductID: Array<String> = []
    var productsArray: Array<SKProduct> = []
    //var purchasedArray: Array<Bool> = []
    
    var selectedProductIndex: Int!
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var audioPlayer: AVAudioPlayer?
    var gbr_man_array = [String]()
    var gbr_woman_array = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        productIDs.removeAll()
        productIDs.append("voice_support_gbr_man")
        productIDs.append("voice_support_gbr_woman")
        
        
        showActivityIndicator(uiView: self.view)
        
        requestProductInfo()
        //gbr_man
        gbr_man_array.removeAll()
        gbr_man_array.append(NSString(format: "%@", "gbr_man_0_15.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_0_30.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_0_40.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_15_0.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_15_30.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_15_40.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_30_0.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_30_15.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_30_30.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_30_40.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_40_0.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_40_15.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_40_30.m4a") as String)
        gbr_man_array.append(NSString(format: "%@", "gbr_man_40_40.m4a") as String)
        
        //gbr_woman
        gbr_woman_array.removeAll()
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_0_15.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_0_30.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_0_40.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_15_0.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_15_30.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_15_40.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_30_0.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_30_15.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_30_30.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_30_40.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_40_0.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_40_15.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_40_30.m4a") as String)
        gbr_woman_array.append(NSString(format: "%@", "gbr_woman_40_40.m4a") as String)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 移除觀查者
        //SKPaymentQueue.default().remove(self)
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
    
    @IBAction func onBackClick(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func showActivityIndicator(uiView: UIView) {
        //let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        //let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        //let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40.0, height: 40.0);
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,
                                           y: loadingView.frame.size.height / 2);
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "voiceItemCell", for: indexPath) as
        UITableViewCell
        
        let desc: String = voiceList[indexPath.row]
        //let price = productsArray[indexPath.row].localizedPrice
        let icon: UIImageView = cell.viewWithTag(100) as! UIImageView
        let title: UILabel = cell.viewWithTag(101) as! UILabel
        //let purchase: UILabel = cell.viewWithTag(102) as! UILabel
        
        if indexPath.row == 0 || indexPath.row == 1 {
            icon.image = UIImage(named: "ic_gbr_flag")!
            
        }
        
        title.text = desc as String
        /*if indexPath.row == 0 {
            purchase.text = NSLocalizedString("voice_free", comment: "")
        } else {
            if purchasedArray[indexPath.row] {
                purchase.text = NSLocalizedString("voice_purchased", comment: "")
            } else {
                purchase.text = price as String
            }
        }*/
        
        
        
        
        print("cell[\(indexPath.row)] = \(desc), prize = \(productsArray[indexPath.row].localizedPrice)" )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //var myUserDefaults :UserDefaults!
        //myUserDefaults = UserDefaults.standard
        
        //myUserDefaults.setValue(String(format:"%d", indexPath.row), forKey: "VOICE_SELECT")
        selectedProductIndex = indexPath.row
        
        playCurrentVoice(lang_select: selectedProductIndex)
        /*if purchasedArray[indexPath.row] {
            UserDefaults.standard.set(indexPath.row, forKey: "VOICE_SELECT")  //Integer
            UserDefaults.standard.synchronize();
            
            NotificationCenter.default.post(name: Notification.Name("langChangeInfo"), object: nil)
            
            
            print("set voice = \(indexPath.row)")
        } else {
            if (selectedProductIndex > 0) {
                //showActions()
                showActionSheet(.nonConsumable)
            }
        }*/
    }
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            //let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<NSObject>)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
        
        if response.products.count != 0 {
            voiceList.removeAll();
            var count: NSInteger = 0
            for product in response.products {
                print("productsArray[\(count)]=\(product.localizedDescription), purchased=\(product.price)")
                productsArray.append(product )
                voiceList.append(product.localizedDescription)
                count = count + 1
            }
            
            voiceListenTableView.reloadData()
            
            let indexPath = IndexPath(row: voice_select, section: 0)
            voiceListenTableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
        }
        else {
            print("There are no products.")
        }
        
        hideActivityIndicator(uiView: self.view)
    }
    
    func playCurrentVoice(lang_select: Int) {
        print("[playCurrentVoice start]")
        
        let voiceSelct = Int(arc4random_uniform(UInt32(gbr_man_array.count)))
        
        print("Get random : \(voiceSelct)")
        //var error: NSError
        /*
         NSError *error;
         mediaPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[soundList objectAtIndex:currentSoundsIndex] ofType:nil]] error:&error];         */
        
        switch lang_select {
        case 0: //gbr_man
            
            print("currentSoundsIndex = \(voiceSelct)")
            
            let soundName = gbr_man_array[voiceSelct]
            
            let fullNameArr = soundName.components(separatedBy: ".")
            
            let name    = fullNameArr[0]
            let surname = fullNameArr[1]
            
            if fullNameArr.count == 2 {
                print("name = \(name), surname = \(surname)")
                
                print("play \(name)")
                
                if let asset = NSDataAsset(name: name){
                    
                    do {
                        // Use NSDataAsset's data property to access the audio file stored in Sound.
                        audioPlayer = try AVAudioPlayer(data:asset.data, fileTypeHint:"m4a")
                        audioPlayer?.delegate = self
                        // Play the above sound file.
                        audioPlayer?.play()
                        
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                
            }
            break
        case 1: //gbr_woman
            
            print("currentSoundsIndex = \(voiceSelct)")
            
            let soundName = gbr_woman_array[voiceSelct]
            
            let fullNameArr = soundName.components(separatedBy: ".")
            
            let name    = fullNameArr[0]
            let surname = fullNameArr[1]
            
            if fullNameArr.count == 2 {
                print("name = \(name), surname = \(surname)")
                
                print("play \(name)")
                
                if let asset = NSDataAsset(name: name){
                    
                    do {
                        // Use NSDataAsset's data property to access the audio file stored in Sound.
                        audioPlayer = try AVAudioPlayer(data:asset.data, fileTypeHint:"m4a")
                        audioPlayer?.delegate = self
                        // Play the above sound file.
                        audioPlayer?.play()
                        
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                
            }
            break
        default:
            break
        }
        
        
        
        print("[playCurrentVoice end]")
    }
    
    func stopSound() {
        print("[stop sound start]")
        if (audioPlayer?.isPlaying)! {
            audioPlayer?.stop()
            print("stop playing")
        }
        
        
        //soundArray.removeAll()
        //currentSoundsIndex = 0
        print("[stop sound end]")
        
    }
}
