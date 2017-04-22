//
//  SwimWorkoutService.swift
//  Swim
//
//  Created by StephenGrinich on 11/30/16.
//  Copyright © 2016 StephenGrinich. All rights reserved.
//

import WatchKit
import os.log;

class SwimWorkoutService: NSObject{

    func getWorkoutFromJSONFilename(filename: String, workoutType: String) -> SwimWorkout {
        let workout: SwimWorkout;
        let json = self.getJSON(filename: filename);
        var workoutSets = [SwimSet]();
        
        for setItem in json {
            let workoutSet = self.createSwimSetFromDictionary(dictionary: setItem);
            workoutSets.append(workoutSet!);
        }
        
        workout = SwimWorkout(sets: workoutSets, filename: filename, workoutType: workoutType);
        return workout;
    }
    
    func createSwimSetFromDictionary(dictionary: [String: Any]) -> SwimSet? {
        guard let total = dictionary["total"] as? Int
                    else{
                        os_log("Unable to init the total for a SwimSet object.", log: OSLog.default, type: .debug);
                        return nil
                }
        
                guard let distance = dictionary["distance"] as? Int
                    else{
                        os_log("Unable to distance the total for a SwimSet object.", log: OSLog.default, type: .debug);
                        return nil
                }
        
                guard let stroke = dictionary["stroke"] as? String
                    else{
                        os_log("Unable to init the stroke for a SwimSet object.", log: OSLog.default, type: .debug);
                        return nil
                }
        
                guard let interval = dictionary["interval"] as? String
                    else{
                        os_log("Unable to init the interval for a SwimSet object.", log: OSLog.default, type: .debug);
                        return nil
                }
        
                guard let notes = dictionary["notes"] as? String
                    else{
                        os_log("Unable to init the notes for a SwimSet object.", log: OSLog.default, type: .debug);
                        return nil
                }
        
                guard let unit = dictionary["unit"] as? String
                    else{
                        os_log("Unable to init the unit for a SwimSet object.", log: OSLog.default, type: .debug);
                        return nil
                }
        
        return SwimSet(total: total, distance: distance, stroke: stroke, interval: interval, notes: notes, unit: unit);
    }
    
    // Should purely be used within watch extension
    func getWorkoutFromJSON(json: [Dictionary<String, Any>], workoutType: String) -> SwimWorkout {
        let workout: SwimWorkout!;
        
        var workoutSets = [SwimSet]();
        
        for setItem in json {
            let workoutSet = self.createSwimSetFromDictionary(dictionary: setItem);
            workoutSets.append(workoutSet!);
        }
        
        workout = SwimWorkout(sets: workoutSets, filename: "noFileNameNeeded", workoutType: workoutType);
        return workout;
    }
    
    func getJSON(filename: String) -> [Dictionary<String, Any>] {
        var json: [Dictionary<String, Any>]?
        if let path = Bundle.main.path(forResource: filename, ofType: "json"), let data = NSData(contentsOfFile: path) {
            do {
                json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Dictionary<String, Any>]
                
                return json!;
                
            } catch {
                print(error)
            }
        }
        
        return json!;
    }
}
