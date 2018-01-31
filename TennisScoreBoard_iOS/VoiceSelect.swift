//
//  VoiceSelect.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/10/31.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import UIKit
import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}

class VoiceSelect: UIViewController,UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    
    
    
    @IBOutlet weak var voiceTableView: UITableView!
    
    //var UserDef:UserDefaults!
    var voice_select: NSInteger = 0
    var voice_gbr_woman_purchased: Bool = false
    var voiceList: Array<String> = []
    var productIDs: Array<String> = []
    var productsArray: Array<SKProduct> = []
    var purchasedArray: Array<Bool> = []
    
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
        
        voice_gbr_woman_purchased = UserDefaults.standard.bool(forKey: "voice_support_gbr_woman")
        
        
        print("voice select = \(voice_select)")
        
        productIDs.removeAll()
        productIDs.append("voice_support_gbr_man")
        productIDs.append("voice_support_gbr_woman")

        
        purchasedArray.removeAll()
        purchasedArray.append(true)
        if voice_gbr_woman_purchased {
            purchasedArray.append(true)
        } else {
            //check restore
            purchasedArray.append(false)
        }
        //voiceList.removeAll()
        //voiceList.append("GBR Man Voice")
        //voiceList.append("GBR Woman Voice")
        // Do any additional setup after loading the view.
        
        showActivityIndicator(uiView: self.view)
        
        requestProductInfo()
        
        //SKPaymentQueue.default().add(self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 移除觀查者
        SKPaymentQueue.default().remove(self)
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
    
    func setInitValue() {
        
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
        
        let desc: String = voiceList[indexPath.row]
        let price = productsArray[indexPath.row].localizedPrice
        let icon: UIImageView = cell.viewWithTag(100) as! UIImageView
        let title: UILabel = cell.viewWithTag(101) as! UILabel
        let purchase: UILabel = cell.viewWithTag(102) as! UILabel
        
        if indexPath.row == 0 || indexPath.row == 1 {
            icon.image = UIImage(named: "ic_gbr_flag")!
            
        }
        
        title.text = desc as String
        if indexPath.row == 0 {
            purchase.text = NSLocalizedString("voice_free", comment: "")
        } else {
            if purchasedArray[indexPath.row] {
                purchase.text = NSLocalizedString("voice_purchased", comment: "")
            } else {
                purchase.text = price as String
            }
        }
        
        
        
        
        print("cell[\(indexPath.row)] = \(desc), prize = \(productsArray[indexPath.row].localizedPrice)" )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //var myUserDefaults :UserDefaults!
        //myUserDefaults = UserDefaults.standard
        
        //myUserDefaults.setValue(String(format:"%d", indexPath.row), forKey: "VOICE_SELECT")
        selectedProductIndex = indexPath.row
        
        if purchasedArray[indexPath.row] {
            UserDefaults.standard.set(indexPath.row, forKey: "VOICE_SELECT")  //Integer
            UserDefaults.standard.synchronize();
            
            NotificationCenter.default.post(name: Notification.Name("langChangeInfo"), object: nil)
            
            
            print("set voice = \(indexPath.row)")
        } else {
            if (selectedProductIndex > 0) {
                showActions()
            }
        }
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
            
            if SKPaymentQueue.canMakePayments() {
                SKPaymentQueue.default().add(self)
                
                if self.productsArray.count > 0 {
                    let payment = SKPayment(product: self.productsArray[self.selectedProductIndex] as SKProduct)
                    SKPaymentQueue.default().add(payment)
                    self.transactionInProgress = true
                    
                    self.showActivityIndicator(uiView: self.view)
                }
            }
            
            
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("voice_cancel", comment: ""), style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = self.view
        actionSheetController.popoverPresentationController?.sourceRect = self.loadingView.bounds;
        
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
                print("productsArray[\(count)]=\(product.localizedDescription), purchased=\(product.price)")
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
                
                SKPaymentQueue.default().remove(self)
                
                didBuyColorsCollection(collectionIndex: selectedProductIndex)
                
                hideActivityIndicator(uiView: self.view)
                
                UserDefaults.standard.set(true, forKey: productIDs[self.selectedProductIndex])
                UserDefaults.standard.synchronize()
                
                purchasedArray[self.selectedProductIndex] = true
                
                voiceTableView.reloadData()
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                
                if let error = transaction.error as? SKError {
                    switch error.code {
                    case .paymentCancelled:
                        // 輸入 Apple ID 密碼時取消
                        print("Transaction Cancelled: \(error.localizedDescription)")
                    case .paymentInvalid:
                        print("Transaction paymentInvalid: \(error.localizedDescription)")
                    case .paymentNotAllowed:
                        print("Transaction paymentNotAllowed: \(error.localizedDescription)")
                    default:
                        print("Transaction: \(error.localizedDescription)")
                    }
                }
                
                hideActivityIndicator(uiView: self.view)
                
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
    
    // 提示購買或回復商品的訊息
    func showMessage(_ product: VoiceProduct) {
        var message: String!
        
        switch product {
        case .voice_support_gbr_man:
            message = "buy voice_support_gbr_man success！"
        case .voice_support_gbr_woman:
            message = "buy voice_support_gbr_woman success！"
        case .restore:
            message = "回復成功！"
        }
        
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "是", style: .default, handler: nil)
        
        alertController.addAction(confirm)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 復原購買失敗
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("復原購買失敗...")
        print(error.localizedDescription)
    }
    
    // 回復購買成功(若沒實作該 delegate 會有問題產生)
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("復原購買成功...")
    }
}

enum VoiceProduct {
    case voice_support_gbr_man
    case voice_support_gbr_woman
    case restore
}
