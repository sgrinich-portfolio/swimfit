//
//  WorkoutTypesTableViewController.swift
//  Swim
//
//  Created by StephenGrinich on 4/1/17.
//  Copyright © 2017 StephenGrinich. All rights reserved.
//

import UIKit

protocol WorkoutTypesTableViewControllerDelegate {
    func workoutTypesTableViewControllerResponse(chosenWorkout: SwimWorkout)
}

class WorkoutTypesTableViewController: UITableViewController, WorkoutCollectionTableViewControllerDelegate {

    var delegate: WorkoutTypesTableViewControllerDelegate?;
    var workoutCollectionService = SwimWorkoutCollectionService();
    
    internal func workoutCollectionTableViewControllerResponse(chosenWorkout: SwimWorkout) {
        self.delegate?.workoutTypesTableViewControllerResponse(chosenWorkout: chosenWorkout);
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WorkoutTypesTableViewController.goBack))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "Categories";
        
        self.tableView.backgroundColor = UIColor(red: 202/255.0, green: 232/255.0, blue: 255/255.0, alpha: 1.0)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 41/255.0, green: 128/255.0, blue: 185/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black;
        self.navigationController?.navigationBar.tintColor = UIColor.white;
    }
    
    func goBack(){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.workoutCollectionService.getWorkoutTypeLabels().count;
    }

    
    func presentWorkoutChoiceViewController(chosenWorkoutType: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "workoutCollectionTableViewController") as! WorkoutCollectionTableViewController
        
        controller.workoutType = chosenWorkoutType;
        controller.workouts = self.workoutCollectionService.getAllWorkoutsForCollection(collection: chosenWorkoutType)
        
        controller.delegate = self;
        
        self.navigationController?.pushViewController(controller, animated: true);
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WorkoutTypesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! WorkoutTypesTableViewCell
        
        let workoutType: String = workoutCollectionService.getWorkoutTypeLabels()[indexPath.row];
        
        cell.workoutTypeLabel.text = workoutType
        
        cell.workoutTypeDescription.text = workoutCollectionService.getWorkoutTypeDescription(workoutType: workoutType);
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentWorkoutChoiceViewController(chosenWorkoutType: workoutCollectionService.getWorkoutTypeLabels()[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        return;
    }
}
