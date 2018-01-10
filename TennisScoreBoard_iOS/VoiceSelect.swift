//
//  VoiceSelect.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/10/31.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import UIKit
import StoreKit

class VoiceSelect: UIViewController,UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    
    
    
    @IBOutlet weak var voiceTableView: UITableView!
    
    //var UserDef:UserDefaults!
    var voice_select: NSInteger = 0
    var voiceList: Array<String> = []
    var productIDs: Array<String> = []
    var productsArray: Array<SKProduct> = []
    
    var selectedProductIndex: Int!
    
    var transactionInProgress = false
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //UserDef = UserDefaults.standard
        
        //voice_select = UserDef.string(forKey: "VOICE_SELECT")!
        voice_select = UserDefaults.standard.integer(forKey: "VOICE_SELECT")
        
        print("voice select = \(voice_select)")
        
        productIDs.removeAll()
        productIDs.append("gbr_man_voice_support")
        productIDs.append("gbr_woman_voice_support")

        //voiceList.removeAll()
        //voiceList.append("GBR Man Voice")
        //voiceList.append("GBR Woman Voice")
        // Do any additional setup after loading the view.
        
        showActivityIndicator(uiView: self.view)
        
        requestProductInfo()
        
        SKPaymentQueue.default().add(self)
        
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
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
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
        selectedProductIndex = indexPath.row
        
        if (selectedProductIndex > 0) {
            showActions()
        }
        
        UserDefaults.standard.set(indexPath.row, forKey: "VOICE_SELECT")  //Integer
        UserDefaults.standard.synchronize();
        print("set voice = \(indexPath.row)")
    }
    
    func showActions() {
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: NSLocalizedString("voice_buying_title", comment: ""), message: NSLocalizedString("voice_buying_confirm", comment: ""), preferredStyle: UIAlertControllerStyle.actionSheet)
        
        /*let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.default) { (action) -> Void in
            
        }*/
        let buyAction = UIAlertAction(title: NSLocalizedString("voice_buy", comment: ""), style: UIAlertActionStyle.default) { (action) -> Void in
            
            print("select: \(self.selectedProductIndex)")
            
            if self.productsArray.count > 0 {
                let payment = SKPayment(product: self.productsArray[self.selectedProductIndex] as SKProduct)
                SKPaymentQueue.default().add(payment)
                self.transactionInProgress = true
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("voice_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true, completion: nil)
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
            voiceList.removeAll();
            var count: NSInteger = 0
            for product in response.products {
                print("productsArray[\(count)]=\(product.localizedDescription)")
                productsArray.append(product )
                voiceList.append(product.localizedDescription)
                count = count + 1
            }
            
            voiceTableView.reloadData()
        }
        else {
            print("There are no products.")
        }
        
        hideActivityIndicator(uiView: self.view)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                didBuyColorsCollection(collectionIndex: selectedProductIndex)
                
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
    func didBuyColorsCollection(collectionIndex: Int) {
        if collectionIndex == 0 {
            //btnGreen.hidden = false
            //btnBlue.hidden = false
        }
        else {
            //btnBlack.hidden = false
            //btnGray.hidden = false
        }
    }
}
