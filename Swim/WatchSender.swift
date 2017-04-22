//
//  WatchRelay.swift
//  Swim
//
//  Created by StephenGrinich on 4/13/17.
//  Copyright © 2017 StephenGrinich. All rights reserved.
//

import Foundation
import WatchConnectivity
import os.log;


class WatchSender: NSObject {
    
    var session: WCSession!;
    
    func activateSession() {
        if WCSession.isSupported() {
            self.session = WCSession.default();
            self.session.delegate = self;
            self.session.activate();
            os_log("WCSession activated", log: OSLog.default, type: .default);
        } else {
            os_log("WCSession NOT activated", log: OSLog.default, type: .error);
        }
    }
    
    func sendWorkoutProgramList(list: [SwimWorkout]){
        os_log("sendWorkoutProgramList called", log: OSLog.default, type: .default);
        
        var payloadList: [Dictionary<String, Any>] = [];
        
        for workout in list {
            
            let workoutJsonObject: [Dictionary<String, Any>] = SwimWorkoutService().getJSON(filename: workout.filename);
            
            let payload = ["workoutJsonObject": workoutJsonObject, "workoutType": workout.workoutType] as [String : Any];
            
            payloadList.append(payload);
        }
        
        self.session.sendMessage(["workoutProgramList": payloadList], replyHandler: { (response) -> Void in
                        print("WatchSender Response: ", response);
                    }, errorHandler: { (error) in
                        print("WatchSender Error: ", error);
                    });
    }
    
    // keeping this in case need to revert 
//        for workout in list {
//            let json = SwimWorkoutService().getJSON(filename: workout.filename);
//            
//            let payload = ["file": json, "workoutType": workout.workoutType] as [String : Any];
//
//            self.session.sendMessage(["workout": payload], replyHandler: { (response) -> Void in
//                print("WatchSender Response: ", response);
//            }, errorHandler: { (error) in
//                print("WatchSender Error: ", error);
//            });
//        }
//    }

}

extension WatchSender: WCSessionDelegate {
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession) { }
    
    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) { }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if(session.isReachable){
            os_log("WCSession is reachable", log: OSLog.default, type: .default);
        }
        else{
            os_log("WCSession is not reachable", log: OSLog.default, type: .error);
        }
    }
    
}
