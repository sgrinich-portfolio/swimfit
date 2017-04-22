//
//  SwimWorkoutCollectionService
//  Swim
//
//  Created by StephenGrinich on 1/29/17.
//  Copyright © 2017 StephenGrinich. All rights reserved.
//

import Foundation

class SwimWorkoutCollectionService: NSObject {
    
    let midDistanceFiles = ["midDistance1", "midDistance2"];
    let distanceFiles = ["distance1", "distance2"];
    let thresholdFiles = ["threshold1", "threshold2"];
    let kickFiles = ["kick1", "kick2"];
    let sprintFiles = ["sprint1", "sprint2"];
    let otherFiles = ["other1", "other2"];
    
    var workoutService = SwimWorkoutService();
    
    func getWorkoutTypeLabels() -> [String] {
        return [SwimWorkoutTypes.Sprint,
                SwimWorkoutTypes.MidDistance,
                SwimWorkoutTypes.Distance,
                SwimWorkoutTypes.Threshold,
                SwimWorkoutTypes.Kick,
                SwimWorkoutTypes.Other
        ]
    }
    
    func getWorkoutTypeDescription(workoutType: String) -> String {
        
        switch workoutType {
            case SwimWorkoutTypes.Sprint:
                return "Shorter distances and higher intensity"
            
            case SwimWorkoutTypes.MidDistance:
                return "Medium distance with medium intensity"
            
            case SwimWorkoutTypes.Distance:
                return "Endurance training with lower intensity";
            
            case SwimWorkoutTypes.Threshold:
                return "Medium intensity with less rest";
            
            case SwimWorkoutTypes.Kick:
                return "Workouts that emphasis kick training";
            
            case SwimWorkoutTypes.Other:
                return "Everything else";
            default:
                return "abc";
        }
    }
    
    func getAllWorkoutsForCollection(collection: String) -> [SwimWorkout]{
        var workoutsForCollection = [SwimWorkout]();
        
        switch collection {
        case SwimWorkoutTypes.Distance:
            for name in self.distanceFiles {
                workoutsForCollection.append(self.workoutService.getWorkoutFromJSONFilename(filename: name, workoutType: SwimWorkoutTypes.Distance));
            }
        case SwimWorkoutTypes.MidDistance:
            for name in self.midDistanceFiles {
                workoutsForCollection.append(self.workoutService.getWorkoutFromJSONFilename(filename: name, workoutType: SwimWorkoutTypes.MidDistance));
            }
        case SwimWorkoutTypes.Threshold:
            for name in self.thresholdFiles {
                workoutsForCollection.append(self.workoutService.getWorkoutFromJSONFilename(filename: name, workoutType: SwimWorkoutTypes.Threshold));
            }
        case SwimWorkoutTypes.Kick:
            for name in self.kickFiles {
                workoutsForCollection.append(self.workoutService.getWorkoutFromJSONFilename(filename: name, workoutType: SwimWorkoutTypes.Kick));
            }
        case SwimWorkoutTypes.Sprint:
            for name in self.sprintFiles {
                workoutsForCollection.append(self.workoutService.getWorkoutFromJSONFilename(filename: name, workoutType: SwimWorkoutTypes.Sprint));
            }
        case SwimWorkoutTypes.Other:
            for name in self.otherFiles {
                workoutsForCollection.append(self.workoutService.getWorkoutFromJSONFilename(filename: name, workoutType: SwimWorkoutTypes.Other));
            }
        default:
            break;
        }
        
        return workoutsForCollection;
    }
}
