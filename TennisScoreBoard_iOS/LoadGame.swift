//
//  LoadGame.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/10/24.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import UIKit

class LoadGame: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var loadTableView: UITableView!
    
    
    var fileList: Array<String> = []
    var selectFileName: String = ""
    var selectFileIndex: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentDirectory = paths[0]
        
        let manager = FileManager.default
        
        do {
            fileList = try manager.contentsOfDirectory(atPath: documentDirectory)
            
            if fileList.count > 0 {
                print(fileList)
            } else {
                print("No text file")
            }
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameVc = segue.destination as? ViewController {
            gameVc.saveFileName = self.selectFileName
            
        }
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: "fileItemCell", for: indexPath) as
            UITableViewCell
            
            let item: String = fileList[indexPath.row]
            let title: UILabel = cell.viewWithTag(100) as! UILabel
            title.text = item as String
            
            print("cell[\(indexPath.row)] = \(item)" )
            
            return cell
    }
    
    @objc func tableView(_ tableView: UITableView,
                         didSelectRowAt indexPath: IndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRow(
            at: indexPath, animated: true)
        
        selectFileName = fileList[indexPath.row]
        selectFileIndex = indexPath.row
        print("選擇的是 \(selectFileName)")
        
        let header = NSLocalizedString("game_record_file", comment: "")
        let title = header + selectFileName
        
        let alert: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let yesBtn: UIAlertAction = UIAlertAction(title: NSLocalizedString("game_record_load", comment: ""), style: UIAlertActionStyle.default, handler: {action in self.yesLoad()})
        
        let deleteBtn: UIAlertAction = UIAlertAction(title: NSLocalizedString("game_record_delete", comment: ""), style: UIAlertActionStyle.default, handler: {action in self.yesDelete()})
        
        let noBtn: UIAlertAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.default, handler: nil)
        
        
        
        alert.addAction(yesBtn)
        alert.addAction(deleteBtn)
        alert.addAction(noBtn)
        
        
        
        self.present(alert, animated: true, completion: nil)
        
        //self.performSegue(withIdentifier: "fileSelectSegue", sender: self)
        
        
        
        
    }
    
    func yesLoad () {
        self.performSegue(withIdentifier: "fileSelectSegue", sender: self)
    }
    
    
    func yesDelete () {
        print("selectFileName = \(selectFileName)")
        
        let header = NSLocalizedString("game_record_delete", comment: "")
        let title = header + selectFileName
        
        let alert: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let yesBtn: UIAlertAction = UIAlertAction(title: NSLocalizedString("game_confirm", comment: ""), style: UIAlertActionStyle.default, handler: {action in self.deleteFile()})
        let noBtn: UIAlertAction = UIAlertAction(title: NSLocalizedString("game_cancel", comment: ""), style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(yesBtn);
        alert.addAction(noBtn);
        
        //alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
        //    textField.placeholder = "Search"
        //})
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func deleteFile () {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(selectFileName)"
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        //remove from filelist
        fileList.remove(at: selectFileIndex)
        
        loadTableView.reloadData()
    }
}
