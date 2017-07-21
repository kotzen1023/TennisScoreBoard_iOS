//
//  StatisticItem.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/7/20.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import UIKit

class StatisticItem: NSObject {
    var title: NSString!
    var count_up: NSString!
    var count_down: NSString!
    
    func getTitle() -> NSString {
        return title
    }
    
    func setTitle(myTitle: NSString) {
        title = myTitle
    }
    
    func getCount_up() -> NSString {
        return count_up
    }
    
    func setCount_up(myCount_up: NSString) {
        count_up = myCount_up
    }
    
    func getCount_down() -> NSString {
        return count_down
    }
    
    func setCount_down(myCount_down: NSString) {
        count_down = myCount_down
    }
}


