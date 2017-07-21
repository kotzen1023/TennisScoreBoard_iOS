//
//  Statistics.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/7/19.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import UIKit

class Statistics: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var btnBackToPlay: UIButton!

    var set_select: UInt8!
    @IBOutlet weak var lblPlayerDown: UILabel!
    @IBOutlet weak var lblPlayerUp: UILabel!
    
    @IBOutlet weak var statTableView: UITableView!
    var game_select: UInt8!
    var is_tiebreak: Bool!
    var is_deuce: Bool!
    var is_serve: Bool!
    var is_retire: UInt8! = 0
    var playerUp: NSString!
    var playerDown: NSString!
    
    var stack = Deque()
    var forward_stack = Deque()
    
    
    var statList: NSMutableArray = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("------ load setting ------")
        print("playerUp: \(playerUp)")
        print("playerDown: \(playerDown)")
        print("set_select: \(set_select)")
        print("game_select: \(game_select)")
        print("is_tiebreak: \(is_tiebreak)")
        print("is_deuce: \(is_deuce)")
        print("is_serve: \(is_serve)")
        print("is_retire: \(is_retire)")
        print("stack size \(stack.size())")
        print("------ load setting ------")
        // Do any additional setup after loading the view.
        
        lblPlayerUp.text = playerUp! as String
        lblPlayerDown.text = playerDown! as String
        
        if (stack.size() > 0) {
            var current_set: UInt8 = 0
            
            var backState = State()
            backState = stack.peak()
            
            current_set = backState.current_set
            
            
            print("###### load state start ######")
            print("current_set = \(backState.current_set)")
            print("Aces(Up) = \(backState.aceCountUp) Aces(Down) = \(backState.aceCountDown)")
            
            
            
            //ace
            let item1 = StatisticItem()
            item1.setTitle(myTitle: "ACE")
            item1.setCount_up(myCount_up:   String(backState.aceCountUp) as NSString)
            item1.setCount_down(myCount_down: String(backState.aceCountDown) as NSString)
            statList.add(item1)
            //double faults
            let item2 = StatisticItem()
            item2.setTitle(myTitle: "Double Faults")
            item2.setCount_up(myCount_up:   String(backState.doubleFaultUp) as NSString)
            item2.setCount_down(myCount_down: String(backState.doubleFaultDown) as NSString)
            statList.add(item2)
            //Unforced Error
            let item3 = StatisticItem()
            item3.setTitle(myTitle: "Unforced Error")
            item3.setCount_up(myCount_up:   String(backState.unforcedErrorUp) as NSString)
            item3.setCount_down(myCount_down: String(backState.unforcedErrorDown) as NSString)
            statList.add(item3)
            
            //First serve in %
            let item4 = StatisticItem()
            item4.setTitle(myTitle: "1st Serve(%)")
            
            var strUp = String(backState.firstServeUp == 0 ? 0 : Float(backState.firstServeUp-backState.firstServeMissUp)/Float(backState.firstServeUp) * 100) as NSString
            item4.setCount_up(myCount_up: strUp)
            
            var strDown = String(backState.firstServeDown == 0 ? 0 : Float(backState.firstServeDown-backState.firstServeMissDown)/Float(backState.firstServeDown) * 100) as NSString
            
            item4.setCount_down(myCount_down: strDown)
            statList.add(item4)
            
            //First serve won %
            let item5 = StatisticItem()
            item5.setTitle(myTitle: "1st Serve Won(%)")
            
            strUp = String(backState.firstServeWonUp == 0 ? 0 : Float(backState.firstServeWonUp)/Float(backState.firstServeWonUp+backState.firstServeLostUp) * 100) as NSString
            item5.setCount_up(myCount_up: strUp)
            
            strDown = String(backState.firstServeWonDown == 0 ? 0 : Float(backState.firstServeWonDown)/Float(backState.firstServeWonDown+backState.firstServeLostDown) * 100) as NSString
            
            item5.setCount_down(myCount_down: strDown)
            statList.add(item5)
            
            //Second serve in %
            let item6 = StatisticItem()
            item6.setTitle(myTitle: "2nd Serve(%)")
            
            strUp = String(backState.secondServeUp == 0 ? 0 : Float(backState.secondServeUp-UInt16(backState.doubleFaultUp))/Float(backState.secondServeUp) * 100) as NSString
            item6.setCount_up(myCount_up: strUp)
            
            strDown = String(backState.secondServeDown == 0 ? 0 : Float(backState.secondServeDown-UInt16(backState.doubleFaultDown))/Float(backState.secondServeDown) * 100) as NSString
            
            item6.setCount_down(myCount_down: strDown)
            statList.add(item6)
            
            //Second serve won %
            let item7 = StatisticItem()
            item7.setTitle(myTitle: "2nd Serve Won(%)")
            
            strUp = String(backState.secondServeWonUp == 0 ? 0 : Float(backState.secondServeWonUp)/Float(backState.secondServeWonUp+backState.secondServeLostUp) * 100) as NSString
            item7.setCount_up(myCount_up: strUp)
            
            strDown = String(backState.secondServeWonDown == 0 ? 0 : Float(backState.secondServeWonDown)/Float(backState.secondServeWonDown+backState.secondServeLostDown) * 100) as NSString
            
            item7.setCount_down(myCount_down: strDown)
            statList.add(item7)
            
            //winner
            let item8 = StatisticItem()
            item8.setTitle(myTitle: "Winners")
            
            strUp = String(backState.forehandWinnerUp+backState.backhandWinnerUp) as NSString
            item8.setCount_up(myCount_up: strUp)
            
            strDown = String(backState.forehandWinnerDown+backState.backhandWinnerDown) as NSString
            
            item8.setCount_down(myCount_down: strDown)
            statList.add(item8)
            
            //forhand winner
            let item9 = StatisticItem()
            item9.setTitle(myTitle: "Forhand Winners")
            
            strUp = String(backState.forehandWinnerUp) as NSString
            item9.setCount_up(myCount_up: strUp)
            
            strDown = String(backState.forehandWinnerDown) as NSString
            
            item9.setCount_down(myCount_down: strDown)
            statList.add(item9)
            
            //backhand winner
            let item10 = StatisticItem()
            item10.setTitle(myTitle: "Backhand Winners")
            
            strUp = String(backState.backhandWinnerUp) as NSString
            item10.setCount_up(myCount_up: strUp)
            
            strDown = String(backState.backhandWinnerDown) as NSString
            
            item10.setCount_down(myCount_down: strDown)
            statList.add(item10)
            
            //net points
            let item11 = StatisticItem()
            item11.setTitle(myTitle: "Net Points")
            
            strUp = String(backState.forehandVolleyUp+backState.backhandVolleyUp) as NSString
            item11.setCount_up(myCount_up: strUp)
            
            strDown = String(backState.forehandVolleyDown+backState.backhandVolleyDown) as NSString
            
            item11.setCount_down(myCount_down: strDown)
            statList.add(item11)
            //break point won
            
            //total points
            let item13 = StatisticItem()
            item13.setTitle(myTitle: "Total Points")
            
            strUp = String(backState.forehandWinnerUp+backState.backhandWinnerUp+backState.forehandVolleyUp+backState.backhandVolleyUp) as NSString
            item13.setCount_up(myCount_up: strUp)
            
            strDown = String(backState.forehandWinnerDown+backState.backhandWinnerDown+backState.forehandVolleyDown+backState.backhandVolleyDown) as NSString
            
            item13.setCount_down(myCount_down: strDown)
            statList.add(item13)
            
            print("Serve = \(backState.isServe)")
            print("In tiebreak = \(backState.isInTiebreak)")
            print("Finish = \(backState.isFinish)")
            print("Second Serve = \(backState.isSecondServe)")
            print("In break point = \(backState.isInBreakPoint)")
            
            var set_limit: UInt8 = 0
            switch self.set_select {
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
                break
            }
            
            for i in 1...set_limit {
                print("========================================")
                print("[set \(i)]")
                print("[Game : \(backState.getGameUp(set: current_set))/\(backState.getGameDown(set: current_set))]")
                print("[point : \(backState.getPointUp(set: current_set))/\(backState.getPointDown(set: current_set))]")
                print("[tiebreak : \(backState.getTiebreakPointUp(set: current_set))/\(backState.getTiebreakPointDown(set: current_set)))]")
            }
            
            print("###### load state end ######")
            
            //statTableView.reloadData()
            //statTableView.dataSource = self
            //statTableView.delegate = self
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

    @IBAction func onBackClick(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let gameVc = storyBoard.instantiateViewController(withIdentifier: "gameView") as! ViewController
        
        gameVc.set_select = self.set_select
        gameVc.game_select = self.game_select
        gameVc.is_tiebreak = self.is_tiebreak
        gameVc.is_deuce = self.is_deuce
        gameVc.is_serve = self.is_serve
        gameVc.playerUp = self.playerUp
        gameVc.playerDown = self.playerDown
        gameVc.stack = self.stack
        gameVc.forward_stack = self.forward_stack
        
        self.present(gameVc, animated:true, completion:nil)
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        //let gameController = storyBoard.instantiateViewController(withIdentifier: "gameView") as! ViewController
        //self.present(gameController, animated:true, completion:nil)
        
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return statList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: "statCell", for: indexPath) as
            UITableViewCell
            
            let item: StatisticItem = statList.object(at: indexPath.row) as! StatisticItem
            let title: UILabel = cell.viewWithTag(100) as! UILabel
            title.text = item.getTitle() as String
            
            print("cell[\(indexPath.row)] = \(item.getTitle()) count_up = \(item.count_up) count_down = \(item.count_down)" )
            
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
            }
            /*if Int(item.count_up as String)! > 100 ||
                Int(item.count_down as String)! > 100 {
                
                if Int(item.count_up as String)! >=
                    Int(item.count_down as String)! {
                    
                    progress_up.progress = 1.0
                    progress_down.progress = Float(item.count_down as String)!/Float(item.count_up as String)!
                } else {
                    progress_down.progress = Float(item.count_up as String)!/Float(item.count_down as String)!
                    progress_down.progress = 1.0
                }
            
            } else {
                progress_up.progress = Float(item.count_up as String)!/100.0
                progress_down.progress = Float(item.count_down as String)!/100.0
            }*/
            
            
            
            
            
        return cell
    }
}
