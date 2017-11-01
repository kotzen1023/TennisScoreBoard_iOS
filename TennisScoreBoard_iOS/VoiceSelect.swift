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
    
    
    var voiceList: Array<String> = []
    var productIDs: Array<String> = []
    var productsArray: Array<SKProduct> = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productIDs.removeAll()
        productIDs.append("gbr_man_voice_support")
        productIDs.append("gbr_woman_voice_support")

        voiceList.removeAll()
        voiceList.append("GBR Man Voice (Free)")
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
        
        if indexPath.row == 0 {
            icon.image = UIImage(named: "ic_gbr_flag")!
            
        }
        
        title.text = item as String
        
        print("cell[\(indexPath.row)] = \(item)" )
        
        return cell
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
