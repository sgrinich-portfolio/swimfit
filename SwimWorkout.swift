//
//  Workout.swift
//  Swim
//
//  Created by StephenGrinich on 2/8/17.
//  Copyright © 2017 StephenGrinich. All rights reserved.
//

import Foundation;
import os.log

class SwimWorkout: NSObject, NSCoding {
    
    let workoutType: String;
    let setList: [SwimSet];
    let setCount: Int;
    var filename: String;
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!;
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("SwimWorkout");
    
    
    init(sets: [SwimSet], filename: String, workoutType: String) {
        self.workoutType = workoutType;
        self.setList = sets;
        self.setCount = sets.count;
        self.filename = filename;
    }
    
    func getFileName() -> String {
        return self.filename;
    }
    
    func getWorkoutType() -> String {
        return self.workoutType;
    }
    
    func getSetList() -> [SwimSet] {
        return self.setList;
    }
    
    func getTotalDistance() -> String {
        var total = 0;
        var unit = "";
        for set in self.setList {
            total = total + set.distance;
            unit = set.unit;
        }
        
        return String(total) + " " + unit + " total";
    }
    
    func getTimeEstimate() -> String {
        var totalSeconds = 0;
        for set in self.setList {
            totalSeconds = totalSeconds + set.getSecondsFromInterval();
        }
        
        return self.secondsToMinutesSecondsString(seconds: totalSeconds);
        
    }
    
    func secondsToMinutesSecondsString (seconds : Int) -> String {
        return String((seconds % 3600) / 60) + ":" + String((seconds % 3600) % 60);
    }
    
    // Mark: Types
    
    struct SwimWorkoutKey {
        static let workoutType = "workoutType";
        static let setList = "setList";
        static let setCount = "setCount";
        static let fileName = "fileName";
    }
    
    // MARK: NSCoding protocol methods
    
    required convenience init?(coder aDecoder: NSCoder){
        
        guard let workoutType = aDecoder.decodeObject(forKey: SwimWorkoutKey.workoutType) as? String
            else {
                os_log("Unable to decode the workoutType for a SwimWorkout object.", log: OSLog.default, type: .debug);
                return nil;
        }
        
        guard let setList = aDecoder.decodeObject(forKey: SwimWorkoutKey.setList) as? [SwimSet]
            else {
                os_log("Unable to decode the setList for a SwimWorkout object.", log: OSLog.default, type: .debug);
                return nil;
        }
        
//        guard let setCount = aDecoder.decodeObject(forKey: SwimWorkoutKey.setCount) as? Int
//            else {
//                os_log("Unable to decode the setCount for a SwimWorkout object.", log: OSLog.default, type: .debug);
//                return nil;
//        }
        
        guard let fileName = aDecoder.decodeObject(forKey: SwimWorkoutKey.fileName) as? String
            else {
                os_log("Unable to decode the fileName for a SwimWorkout object.", log: OSLog.default, type: .debug);
                return nil;
        }
        
        
        //let workoutType = aDecoder.decodeObject(forKey: SwimWorkoutKey.workoutType) as! String;
//        let setList = aDecoder.decodeObject(forKey: SwimWorkoutKey.setList) as! [SwimSet];
       // let setCount = aDecoder.decodeObject(forKey: SwimWorkoutKey.setCount) as! Int;
//        let fileName = aDecoder.decodeObject(forKey: SwimWorkoutKey.fileName) as! String;

        self.init(sets: setList, filename: fileName, workoutType: workoutType);
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(workoutType, forKey: SwimWorkoutKey.workoutType);
        aCoder.encode(setList, forKey: SwimWorkoutKey.setList);
        aCoder.encode(setCount, forKey: SwimWorkoutKey.setCount);
        aCoder.encode(filename, forKey: SwimWorkoutKey.fileName);
    }
    
    

    
    
    
    
}
