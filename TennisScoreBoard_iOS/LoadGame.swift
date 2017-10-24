//
//  LoadGame.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/10/24.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import UIKit

class LoadGame: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var fileList: Array<String> = []
    
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
            /*
            let count_up: UILabel = cell.viewWithTag(101) as! UILabel
            count_up.text = item.getCount_up() as String
            
            let count_down: UILabel = cell.viewWithTag(201) as! UILabel
            count_down.text = item.getCount_down() as String
            
            let progress_up: UIProgressView = cell.viewWithTag(102) as! UIProgressView
            
            let progress_down: UIProgressView = cell.viewWithTag(202) as! UIProgressView
            
            if Float(item.count_up as String) != nil &&
                Float(item.count_down as String) != nil {
                
                if Float(item.count_up as String)! > 100 ||
                    Float(item.count_down as String)! > 100 {
                    
                    if Float(item.count_up as String)! >=
                        Float(item.count_down as String)! {
                        
                        progress_up.progress = 1.0
                        progress_down.progress = Float(item.count_down as String)!/Float(item.count_up as String)!
                    } else {
                        progress_down.progress = Float(item.count_up as String)!/Float(item.count_down as String)!
                        progress_down.progress = 1.0
                    }
                    
                } else {
                    progress_up.progress = Float(item.count_up as String)!/100.0
                    progress_down.progress = Float(item.count_down as String)!/100.0
                }
            } else if Float(item.count_up as String) != nil &&
                Float(item.count_down as String) == nil { //down is nil
                
                if Float(item.count_up as String)! > 100 {
                    progress_up.progress = 1.0
                } else {
                    progress_up.progress = Float(item.count_up as String)!/100.0
                }
                progress_down.progress = 0
                
            } else if Float(item.count_up as String) == nil &&
                Float(item.count_down as String) != nil { //up is nil
                
                progress_up.progress = 0
                
                if Float(item.count_down as String)! > 100 {
                    progress_down.progress = 1.0
                } else {
                    progress_down.progress = Float(item.count_down as String)!/100.0
                }
            } else { //both nil
                progress_up.progress = 0
                progress_down.progress = 0
            }*/
            
            
            
            
            
            
            return cell
    }
    
}
