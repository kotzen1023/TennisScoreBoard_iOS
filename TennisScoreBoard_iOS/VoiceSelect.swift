//
//  VoiceSelect.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/10/31.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import UIKit
import StoreKit

class VoiceSelect: UIViewController,UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate {
    
    
    
    @IBOutlet weak var voiceTableView: UITableView!
    
    //var UserDef:UserDefaults!
    var voice_select: NSInteger = 0
    var voiceList: Array<String> = []
    var productIDs: Array<String> = []
    var productsArray: Array<SKProduct> = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //UserDef = UserDefaults.standard
        
        //voice_select = UserDef.string(forKey: "VOICE_SELECT")!
        voice_select = UserDefaults.standard.integer(forKey: "VOICE_SELECT")
        
        print("voice select = \(voice_select)")
        
        productIDs.removeAll()
        productIDs.append("gbr_man_voice_support")
        productIDs.append("gbr_woman_voice_support")

        voiceList.removeAll()
        voiceList.append("GBR Man Voice")
        voiceList.append("GBR Woman Voice")
        // Do any additional setup after loading the view.
        
        requestProductInfo()
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
        /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         
         let gameVc = storyBoard.instantiateViewController(withIdentifier: "gameView") as! ViewController
         
         gameVc.saveFileName = self.saveFileName
         gameVc.set_select = self.set_select
         gameVc.game_select = self.game_select
         gameVc.is_tiebreak = self.is_tiebreak
         gameVc.is_super_tiebreak = self.is_super_tiebreak
         gameVc.is_deuce = self.is_deuce
         gameVc.is_serve = self.is_serve
         gameVc.playerUp = self.playerUp
         gameVc.playerDown = self.playerDown
         gameVc.stack = self.stack
         gameVc.forward_stack = self.forward_stack
         
         self.present(gameVc, animated:true, completion:nil)*/
        self.dismiss(animated: true, completion: nil)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "voiceItemCell", for: indexPath) as
        UITableViewCell
        
        let item: String = voiceList[indexPath.row]
        let icon: UIImageView = cell.viewWithTag(100) as! UIImageView
        let title: UILabel = cell.viewWithTag(101) as! UILabel
        
        if indexPath.row == 0 || indexPath.row == 1 {
            icon.image = UIImage(named: "ic_gbr_flag")!
            
        }
        
        title.text = item as String
        
        print("cell[\(indexPath.row)] = \(item)" )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //var myUserDefaults :UserDefaults!
        //myUserDefaults = UserDefaults.standard
        
        //myUserDefaults.setValue(String(format:"%d", indexPath.row), forKey: "VOICE_SELECT")
        
        UserDefaults.standard.set(indexPath.row, forKey: "VOICE_SELECT")  //Integer
        UserDefaults.standard.synchronize();
        print("set voice = \(indexPath.row)")
    }
    
    //purchase
    
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
            for product in response.products {
                productsArray.append(product )
            }
            
            voiceTableView.reloadData()
        }
        else {
            print("There are no products.")
        }
    }
}
