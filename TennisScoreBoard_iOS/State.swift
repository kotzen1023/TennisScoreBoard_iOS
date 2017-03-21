//
//  State.swift
//  TennisScoreBoard_iOS
//
//  Created by SUNUP on 2017/3/16.
//  Copyright © 2017年 RichieShih. All rights reserved.
//

import Foundation

public class State {
    var current_set: UInt8 = 0
    var isServe: Bool
    var isInTiebreak: Bool
    var isFinish: Bool
    var isSecondServe: Bool
    var isInBreakPoint: Bool
    var setsUp: UInt8
    var setSDown: UInt8
    var duration: UInt
    
    var aceCountUp: UInt8
    var aceCountDown: UInt8
    var firstServeUp: UInt16
    var firstServeDown: UInt16
    var firstServeMissUp: UInt16
    var firstServeMissDown: UInt16
    var secondServeUp: UInt16
    var secondServeDown: UInt16
    var breakPointUp: UInt8
    var breakPointDown: UInt8
    var breakPointMissUp: UInt8
    var breakPointMissDown: UInt8
    
    var firstServeWonUp: UInt16
    var firstServeWonDown: UInt16
    var firstServeLostUp: UInt16
    var firstServeLostDown: UInt16
    var secondServeWonUp: UInt16
    var secondServeWonDown: UInt16
    var secondServeLostUp: UInt16
    var secondServeLostDown: UInt16
    
    var doubleFaultUp: UInt8
    var doubleFaultDown: UInt8
    var unforcedErrorUp: UInt16
    var unforcedErrorDown: UInt16
    var forehandWinnerUp: UInt16
    var forehandWinnerDown: UInt16
    var backhandWinnerUp: UInt16
    var backhandWinnerDown: UInt16
    var forehandVolleyUp: UInt16
    var forehandVolleyDown: UInt16
    var backhandVolleyUp: UInt16
    var backhandVolleyDown: UInt16
    var foulToLoseUp: UInt8
    var foulToLoseDown: UInt8
    
    var set_1_game_up: UInt8
    var set_1_game_down: UInt8
    var set_1_point_up: UInt8
    var set_1_point_down: UInt8
    var set_1_tiebreak_point_up: UInt8
    var set_1_tiebreak_point_down: UInt8
    
    var set_2_game_up: UInt8
    var set_2_game_down: UInt8
    var set_2_point_up: UInt8
    var set_2_point_down: UInt8
    var set_2_tiebreak_point_up: UInt8
    var set_2_tiebreak_point_down: UInt8
    
    var set_3_game_up: UInt8
    var set_3_game_down: UInt8
    var set_3_point_up: UInt8
    var set_3_point_down: UInt8
    var set_3_tiebreak_point_up: UInt8
    var set_3_tiebreak_point_down: UInt8
    
    var set_4_game_up: UInt8
    var set_4_game_down: UInt8
    var set_4_point_up: UInt8
    var set_4_point_down: UInt8
    var set_4_tiebreak_point_up: UInt8
    var set_4_tiebreak_point_down: UInt8
    
    var set_5_game_up: UInt8
    var set_5_game_down: UInt8
    var set_5_point_up: UInt8
    var set_5_point_down: UInt8
    var set_5_tiebreak_point_up: UInt8
    var set_5_tiebreak_point_down: UInt8
    
    init() {
        current_set = 0
        isServe = false
        isInTiebreak = false
        isFinish = false
        isSecondServe = false
        isInBreakPoint = false
        setsUp = 0
        setSDown = 0
        duration = 0
        
        aceCountUp = 0
        aceCountDown = 0
        firstServeUp = 0
        firstServeDown = 0
        firstServeMissUp = 0
        firstServeMissDown = 0
        secondServeUp = 0
        secondServeDown = 0
        breakPointUp = 0
        breakPointDown = 0
        breakPointMissUp = 0
        breakPointMissDown = 0
        
        firstServeWonUp = 0
        firstServeWonDown = 0
        firstServeLostUp = 0
        firstServeLostDown = 0
        secondServeWonUp = 0
        secondServeWonDown = 0
        secondServeLostUp = 0
        secondServeLostDown = 0
        
        doubleFaultUp = 0
        doubleFaultDown = 0
        unforcedErrorUp = 0
        unforcedErrorDown = 0
        forehandWinnerUp = 0
        forehandWinnerDown = 0
        backhandWinnerUp = 0
        backhandWinnerDown = 0
        forehandVolleyUp = 0
        forehandVolleyDown = 0
        backhandVolleyUp = 0
        backhandVolleyDown = 0
        foulToLoseUp = 0
        foulToLoseDown = 0
        set_1_game_up = 0
        set_1_game_down = 0
        set_1_point_up = 0
        set_1_point_down = 0
        set_1_tiebreak_point_up = 0
        set_1_tiebreak_point_down = 0
        
        set_2_game_up = 0
        set_2_game_down = 0
        set_2_point_up = 0
        set_2_point_down = 0
        set_2_tiebreak_point_up = 0
        set_2_tiebreak_point_down = 0
        
        set_3_game_up = 0
        set_3_game_down = 0
        set_3_point_up = 0
        set_3_point_down = 0
        set_3_tiebreak_point_up = 0
        set_3_tiebreak_point_down = 0
        
        set_4_game_up = 0
        set_4_game_down = 0
        set_4_point_up = 0
        set_4_point_down = 0
        set_4_tiebreak_point_up = 0
        set_4_tiebreak_point_down = 0
        
        set_5_game_up = 0
        set_5_game_down = 0
        set_5_point_up = 0
        set_5_point_down = 0
        set_5_tiebreak_point_up = 0
        set_5_tiebreak_point_down = 0
    }
    
    func getGameUp(set: UInt8) -> UInt8 {
        
        var ret: UInt8 = 0
        switch set {
        case 1:
            ret = set_1_game_up
            break
        case 2:
            ret = set_2_game_up
            break
        case 3:
            ret = set_3_game_up
            break
        case 4:
            ret = set_4_game_up
            break
        case 5:
            ret = set_5_game_up
            break
            
        default:
            print("Unknown set")
        }
        
        return ret
    }
    
    func setGameUp(set: UInt8, game: UInt8) {
        switch set {
        case 1:
            set_1_game_up = game
            break
        case 2:
            set_2_game_up = game
            break
        case 3:
            set_3_game_up = game
            break
        case 4:
            set_4_game_up = game
            break
        case 5:
            set_5_game_up = game
            break
            
        default:
            print("Unknown set")
        }
    }
    
    func getGameDown(set: UInt8) -> UInt8 {
        var ret: UInt8 = 0
        switch set {
        case 1:
            ret = set_1_game_down
            break
        case 2:
            ret = set_2_game_down
            break
        case 3:
            ret = set_3_game_down
            break
        case 4:
            ret = set_4_game_down
            break
        case 5:
            ret = set_5_game_down
            break
            
        default:
            print("Unknown set")
        }
        
        return ret
    }
    
    func setGameDown(set: UInt8, game: UInt8) {
        switch set {
        case 1:
            set_1_game_down = game
            break
        case 2:
            set_2_game_down = game
            break
        case 3:
            set_3_game_down = game
            break
        case 4:
            set_4_game_down = game
            break
        case 5:
            set_5_game_down = game
            break
            
        default:
            print("Unknown set")
        }
    }
    
    func getPointUp(set: UInt8)->UInt8 {
        var ret: UInt8 = 0
        switch set {
        case 1:
            ret = set_1_point_up
            break
        case 2:
            ret = set_2_point_up
            break
        case 3:
            ret = set_3_point_up
            break
        case 4:
            ret = set_4_point_up
            break
        case 5:
            ret = set_5_point_up
            break
            
        default:
            print("Unknown set")
        }
        
        return ret
    }
    
    func setPointUp(set: UInt8, point: UInt8) {
        switch set {
        case 1:
            set_1_point_up = point
            break
        case 2:
            set_2_point_up = point
            break
        case 3:
            set_3_point_up = point
            break
        case 4:
            set_4_point_up = point
            break
        case 5:
            set_5_point_up = point
            break
            
        default:
            print("Unknown set")
        }
    }
    
    func getPointDown(set: UInt8)->UInt8 {
        var ret: UInt8 = 0
        switch set {
        case 1:
            ret = set_1_point_down
            break
        case 2:
            ret = set_2_point_down
            break
        case 3:
            ret = set_3_point_down
            break
        case 4:
            ret = set_4_point_down
            break
        case 5:
            ret = set_5_point_down
            break
            
        default:
            print("Unknown set")
        }
        
        return ret
    }
    
    func setPointDown(set: UInt8, point: UInt8) {
        switch set {
        case 1:
            set_1_point_down = point
            break
        case 2:
            set_2_point_down = point
            break
        case 3:
            set_3_point_down = point
            break
        case 4:
            set_4_point_down = point
            break
        case 5:
            set_5_point_down = point
            break
            
        default:
            print("Unknown set")
        }
    }
    
    func getTiebreakPointUp(set: UInt8)->UInt8 {
        var ret: UInt8 = 0
        switch set {
        case 1:
            ret = set_1_tiebreak_point_up
            break
        case 2:
            ret = set_2_tiebreak_point_up
            break
        case 3:
            ret = set_3_tiebreak_point_up
            break
        case 4:
            ret = set_4_tiebreak_point_up
            break
        case 5:
            ret = set_5_tiebreak_point_up
            break
            
        default:
            print("Unknown set")
        }
        
        return ret
    }
    
    func setTiebreakPointUp(set: UInt8, point: UInt8) {
        switch set {
        case 1:
            set_1_tiebreak_point_up = point
            break
        case 2:
            set_2_tiebreak_point_up = point
            break
        case 3:
            set_3_tiebreak_point_up = point
            break
        case 4:
            set_4_tiebreak_point_up = point
            break
        case 5:
            set_5_tiebreak_point_up = point
            break
            
        default:
            print("Unknown set")
        }
    }
    
    func getTiebreakPointDown(set: UInt8)->UInt8 {
        var ret: UInt8 = 0
        switch set {
        case 1:
            ret = set_1_tiebreak_point_down
            break
        case 2:
            ret = set_2_tiebreak_point_down
            break
        case 3:
            ret = set_3_tiebreak_point_down
            break
        case 4:
            ret = set_4_tiebreak_point_down
            break
        case 5:
            ret = set_5_tiebreak_point_down
            break
            
        default:
            print("Unknown set")
        }
        
        return ret
    }
    
    func setTiebreakPointDown(set: UInt8, point: UInt8) {
        switch set {
        case 1:
            set_1_tiebreak_point_down = point
            break
        case 2:
            set_2_tiebreak_point_down = point
            break
        case 3:
            set_3_tiebreak_point_down = point
            break
        case 4:
            set_4_tiebreak_point_down = point
            break
        case 5:
            set_5_tiebreak_point_down = point
            break
            
        default:
            print("Unknown set")
        }
    }
}
