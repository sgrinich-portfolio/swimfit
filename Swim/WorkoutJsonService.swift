//
//  WorkoutJsonService.swift
//  Swim
//
//  Created by StephenGrinich on 12/19/16.
//  Copyright © 2016 StephenGrinich. All rights reserved.
//

import WatchKit

class WorkoutJsonService: NSObject{
    func getJSON() -> [Dictionary<String, Any>] {
        var json: [Dictionary<String, Any>]?
        if let path = Bundle.main.path(forResource: "Workout", ofType: "json"), let data = NSData(contentsOfFile: path) {
            do {
                json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Dictionary<String, Any>]
                
            } catch {
                print(error)
            }
        }
        
        return json!;
    }
}
