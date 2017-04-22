//
//  HomeInterfaceController.swift
//  Swim
//
//  Created by StephenGrinich on 4/9/17.
//  Copyright © 2017 StephenGrinich. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import os.log


class HomeInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var workoutProgramTable: WKInterfaceTable!

    var chosenWorkout: SwimWorkout!;
    
    var workoutProgramList: [SwimWorkout] = [];
    
    var workoutService = SwimWorkoutService();


    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        print("awake home interface controller");
        
        if let workoutList = context as? [SwimWorkout]{
            print("yay")
            self.workoutProgramList = workoutList;
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("will activate home interface controller");
        super.willActivate()
    }
    
    override func didAppear() {
        print("didAppear home interface controller");
        
        self.loadWorkoutProgramTable();
        
        if WCSession.isSupported() {
            let session = WCSession.default();
            session.delegate = self;
            session.activate();
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate();
        
        print("didDeactivate home interface controller");
    }
    
    func loadWorkoutProgramTable() {
        self.workoutProgramTable.setNumberOfRows(self.workoutProgramList.count, withRowType: "workoutProgramRowController")
        
        let rowCount = self.workoutProgramTable.numberOfRows;
        
        for i in (0 ..< rowCount) {
            let row = self.workoutProgramTable.rowController(at: i) as! WorkoutProgramRowController;
            
            row.swimWorkoutLabel.setText(self.workoutProgramList[i].getWorkoutType());
        }}
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        os_log("HomeInterfaceController session func 1", log: OSLog.default, type: .default);
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        os_log("HomeInterfaceController session func 2", log: OSLog.default, type: .default);
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        os_log("HomeInterfaceController session func 3", log: OSLog.default, type: .default);
        
        // TODO: Ideally send object over from iPhone and pick it up here.
        //        NSKeyedUnarchiver.setClass(SwimWorkout.self, forClassName: "SwimWorkout");
        //        NSKeyedUnarchiver.setClass(SwimSet.self, forClassName: "SwimSet");
        //        let unarchiver =  NSKeyedUnarchiver(forReadingWith: messageData);
        //        unarchiver.
        //
        //        do {
        //            let decodedDataObject = try unarchiver.decodeTopLevelObject()
        //
        //            print("Decoded Data Object: ", decodedDataObject);
        //
        //            if let newChosenWorkout = decodedDataObject {
        //                print("success");
        //            } else {
        //                print("failure");
        //            }
        //        } catch {
        //            print("within catch");
        //        }
        //
        
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        os_log("HomeInterfaceController session func 4", log: OSLog.default, type: .default);
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String : Any]) -> Void) {
        os_log("HomeInterfaceController session func 5", log: OSLog.default, type: .default);
        
        
        let receivedObject = message as! Dictionary<String, [Dictionary<String, Any>]>;
        let payloadList = receivedObject["workoutProgramList"]! as [Dictionary<String, Any>];
        
        var receivedWorkoutProgramList: [SwimWorkout] = [];

        for payload in payloadList {
            let workoutJsonObject: [Dictionary<String, Any>] = payload["workoutJsonObject"] as! [Dictionary<String, Any>];
            let workoutType: String = payload["workoutType"] as! String;
            let receivedSwimWorkout = workoutService.getWorkoutFromJSON(json: workoutJsonObject, workoutType: workoutType)
            receivedWorkoutProgramList.append(receivedSwimWorkout);
        }
        
        self.workoutProgramList = receivedWorkoutProgramList;
        self.loadWorkoutProgramTable();
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        
        let payload = ["rowIndex": rowIndex, "workoutProgramList": self.workoutProgramList] as [String : Any]
        return payload;
    }
}

