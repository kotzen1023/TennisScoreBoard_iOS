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
        print("<push stack size = \(stack.count)>")
    }

    func pop()->State {
        var top: State = State()
        top = stack.lastObject as! State
        stack.removeLastObject()
        print("<pop stack size = \(stack.count)>")
        return top
    }
    
    func peak()->State {
        var top: State = State()
        top = stack.lastObject as! State
        print("<peak stack size = \(stack.count)>")
        return top
    }
    
    
}
