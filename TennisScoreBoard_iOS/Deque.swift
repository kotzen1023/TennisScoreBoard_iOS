//
//  Deque.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/3/16.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import Foundation

public class Deque {
    var stack = NSMutableArray()
    
    func size()->Int {
        return stack.count
    }
    
    func clear() {
        stack.removeAllObjects()
    }
    
    func get(index: Int)->State {
        return stack.object(at: index) as! State
    }
    
    
    func push(obj: State) {
        stack.add(obj)
    }

    func pop()->State {
        var top = State()
        top = stack.lastObject as! State
        stack.removeLastObject()
        return top
    }
    
    func peak()->State {
        var top = State()
        top = stack.lastObject as! State
        return top
    }
}
