//
//  SwimSet.swift
//  Swim
//
//  Created by StephenGrinich on 2/8/17.
//  Copyright © 2017 StephenGrinich. All rights reserved.
//

import Foundation;
import os.log;

class SwimSet: NSObject, NSCoding {
    
    let total: Int
    let distance: Int
    let stroke: String
    let interval: String
    let notes: String
    let unit: String
    
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!;
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("SwimSet");
    
    init?(total: Int, distance: Int, stroke: String, interval: String, notes: String, unit: String){
//    init?(dictionary: [String: Any]) {
//        guard let total = dictionary[SwimSetKey.total] as? Int
//            else{
//                os_log("Unable to init the total for a SwimSet object.", log: OSLog.default, type: .debug);
//                return nil
//        }
//        
//        guard let distance = dictionary[SwimSetKey.distance] as? Int
//            else{
//                os_log("Unable to distance the total for a SwimSet object.", log: OSLog.default, type: .debug);
//                return nil
//        }
//        
//        guard let stroke = dictionary[SwimSetKey.stroke] as? String
//            else{
//                os_log("Unable to init the stroke for a SwimSet object.", log: OSLog.default, type: .debug);
//                return nil
//        }
//        
//        guard let interval = dictionary[SwimSetKey.interval] as? String
//            else{
//                os_log("Unable to init the interval for a SwimSet object.", log: OSLog.default, type: .debug);
//                return nil
//        }
//        
//        guard let notes = dictionary[SwimSetKey.notes] as? String
//            else{
//                os_log("Unable to init the notes for a SwimSet object.", log: OSLog.default, type: .debug);
//                return nil
//        }
//        
//        guard let unit = dictionary[SwimSetKey.unit] as? String
//            else{
//                os_log("Unable to init the unit for a SwimSet object.", log: OSLog.default, type: .debug);
//                return nil
//        }
    
        self.total = total;
        self.distance = distance;
        self.stroke = stroke;
        self.interval = interval;
        self.notes = notes;
        self.unit = unit
        
    }
    
    func getTotal() -> String {
        return String(self.total)
    }
    
    func getDisplayDistance() -> String {
        return String(self.distance);
    }
    
    func getDisplayUnit() -> String {
        if (self.unit == "yards") {
            return "y";
        } else {
            return "m";
        }
    }
    
    func getDisplayStroke() -> String {
        return self.stroke;
    }
    
    func getDisplayNote() -> String {
        return self.notes;
    }
    
    func getSecondsFromInterval() -> Int {
        var intervalArray = self.interval.components(separatedBy: ":");
        
        if (intervalArray.count == 1) {
            return 0;
        }
        
        let minutes = Int(intervalArray[0]);
        var seconds = Int(intervalArray[1]);

        seconds = seconds! + (minutes! * 60);
        
        return seconds!;
    }
    
    // MARK: Types
    
    struct SwimSetKey {
        static let total = "total";
        static let distance = "distance";
        static let stroke = "stroke";
        static let interval = "interval";
        static let notes = "notes";
        static let unit = "unit";
    }
    
    // MARK: NSCoding protocol methods
    
    required convenience init?(coder aDecoder: NSCoder){
        
        guard let total = aDecoder.decodeObject(forKey: SwimSetKey.total) as? Int
            else {
                os_log("Unable to decode the total for a SwimSet object.", log: OSLog.default, type: .debug);
                return nil;
        }
        
        guard let distance = aDecoder.decodeObject(forKey: SwimSetKey.distance) as? Int
            else {
                os_log("Unable to decode the distance for a SwimSet object.", log: OSLog.default, type: .debug);
                return nil;
        }
        
        guard let stroke = aDecoder.decodeObject(forKey: SwimSetKey.stroke) as? String
            else {
                os_log("Unable to decode the stroke for a SwimSet object.", log: OSLog.default, type: .debug);
                return nil;
        }
        
        guard let interval = aDecoder.decodeObject(forKey: SwimSetKey.interval) as? String
            else {
                os_log("Unable to decode the interval for a SwimSet object.", log: OSLog.default, type: .debug);
                return nil;
        }
        
        guard let notes = aDecoder.decodeObject(forKey: SwimSetKey.notes) as? String
            else {
                os_log("Unable to decode the notes for a SwimSet object.", log: OSLog.default, type: .debug);
                return nil;
        }
        
        guard let unit = aDecoder.decodeObject(forKey: SwimSetKey.unit) as? String
            else {
                os_log("Unable to decode the unit for a SwimSet object.", log: OSLog.default, type: .debug);
                return nil;
        }
        
        
//        let total = aDecoder.decodeObject(forKey: SwimSetKey.total) as! Int;
//        let distance = aDecoder.decodeObject(forKey: SwimSetKey.distance) as! Int;
//        let stroke = aDecoder.decodeObject(forKey: SwimSetKey.stroke) as! String;
//        let interval = aDecoder.decodeObject(forKey: SwimSetKey.interval) as! String;
//        let notes = aDecoder.decodeObject(forKey: SwimSetKey.notes) as! String;
//        let unit = aDecoder.decodeObject(forKey: SwimSetKey.unit) as! String;
        
//        let setDictionary = [
//            SwimSetKey.total: total,
//            SwimSetKey.distance: distance,
//            SwimSetKey.stroke: stroke,
//            SwimSetKey.interval: interval,
//            SwimSetKey.notes: notes,
//            SwimSetKey.unit: unit
//            ] as [String : Any];

        self.init(total: total, distance: distance, stroke: stroke, interval: interval, notes: notes, unit: unit);

//        self.init(dictionary: setDictionary);
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(total, forKey: SwimSetKey.total);
        aCoder.encode(distance, forKey: SwimSetKey.distance);
        aCoder.encode(stroke, forKey: SwimSetKey.stroke);
        aCoder.encode(interval, forKey: SwimSetKey.interval);
        aCoder.encode(notes, forKey: SwimSetKey.notes);
        aCoder.encode(unit, forKey: SwimSetKey.unit);
    }
}
