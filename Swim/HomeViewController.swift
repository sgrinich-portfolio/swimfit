//
//  ViewController.swift
//  Swim
//
//  Created by StephenGrinich on 10/30/16.
//  Copyright © 2016 StephenGrinich. All rights reserved.
//

import UIKit
import WatchConnectivity
import os.log;

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WorkoutTypesTableViewControllerDelegate {
    
    
    @IBOutlet var sendToWatchButton: UIButton!
    @IBOutlet var workoutProgramTableView: UITableView!
    
    var watchSender = WatchSender();
    
    var workoutCollectionService = SwimWorkoutCollectionService();
    var workoutProgramList: [SwimWorkout] = [];
    var workoutService = SwimWorkoutService();
    
    internal func workoutTypesTableViewControllerResponse(chosenWorkout: SwimWorkout) {
        self.workoutProgramList.append(chosenWorkout);
        self.workoutProgramChanged();
        workoutProgramTableView.reloadData();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        watchSender.activateSession();

        workoutProgramTableView.delegate = self;
        workoutProgramTableView.dataSource = self;
        
        if let savedSwimWorkouts = self.loadSwimWorkouts() {
            os_log("HomeViewController successfully loaded saved workouts", log: OSLog.default, type: .default);
            self.workoutProgramList += savedSwimWorkouts;
        } else {
            os_log("HomeViewController did not load saved workouts", log: OSLog.default, type: .default);
        }
        
    }
    
    private func workoutProgramChanged() {
        self.saveSwimWorkouts();
        
        if(watchSender.session.isPaired) {
            watchSender.sendWorkoutProgramList(list: self.workoutProgramList);
        }
    }
    
    private func saveSwimWorkouts() {

    // Alternative functionality that seemed to result in same error. See loadSwimWorkouts() for more
//        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.workoutProgramList);
//        UserDefaults.standard.set(encodedData, forKey: "workoutList");
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.workoutProgramList, toFile: SwimWorkout.ArchiveURL.path);
        
        if (isSuccessfulSave){
            os_log("workoutProgramList saved successfully", log: OSLog.default, type: .debug);
        } else {
            os_log("Failed to save workoutProgramList", log: OSLog.default, type: .error);
        }
    }
    
    
    // TODO: One day NSKeyArchiver be working here. For now I must recreate objects when reloading to get this project moving.
    private func loadSwimWorkouts() -> [SwimWorkout]? {
        
        // Alternative functionality that seemed to result in same error. See saveSwimWorkouts() for more
//        if let data = UserDefaults.standard.data(forKey: "workoutList"),
//            let thisWoroutList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SwimWorkout] {
//            return thisWoroutList;
//        } else {
//            print("There is an issue")
//            return nil;
//        }
        
        let swimWorkouts = NSKeyedUnarchiver.unarchiveObject(withFile: SwimWorkout.ArchiveURL.path) as? [SwimWorkout];
        var swimWorkoutList: [SwimWorkout] = []
        
        if(swimWorkouts != nil){
            for workout in swimWorkouts! {
                let rebornWorkout = self.workoutService.getWorkoutFromJSONFilename(filename: workout.filename, workoutType: workout.workoutType)
                
                swimWorkoutList.append(rebornWorkout);
            }
        }
        
        return swimWorkoutList;
    }
    
    func presentWorkoutTypeTableViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "workoutTypesTableViewController") as! WorkoutTypesTableViewController
        
        controller.delegate = self;
        
        let navController = UINavigationController(rootViewController: controller);
        self.showDetailViewController(navController, sender: nil);
    }
    
    //func setButtonLabel() {
      //  self.sendToWatchButton.setTitle("Send " + self.chosenWorkout.getTotalDistance() + " " + self.chosenWorkout.getWorkoutType() + " to Watch", for: UIControlState.normal);
    //}
    
    @IBAction func sendToWatchButton(_ sender: Any) {
        self.presentWorkoutTypeTableViewController();
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workoutProgramList.count;
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WorkoutProgramTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! WorkoutProgramTableViewCell
        
        cell.workoutNameLabel.text = self.workoutProgramList[indexPath.row].getWorkoutType();
        cell.totalDistanceLabel.text = self.workoutProgramList[indexPath.row].getTotalDistance();

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentWorkoutInformationViewController(chosenWorkout: self.workoutProgramList[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        return;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            self.workoutProgramList.remove(at: indexPath.row);
            self.workoutProgramChanged();
            tableView.deleteRows(at: [indexPath], with: .fade);
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func presentWorkoutInformationViewController(chosenWorkout: SwimWorkout) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "workoutInformationTableViewController") as! WorkoutInformationTableViewController
        controller.chosenWorkout = chosenWorkout;
        controller.showBackButton = true;
        
        let navController = UINavigationController(rootViewController: controller);
        self.showDetailViewController(navController, sender: nil);
    }
}

