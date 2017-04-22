//
//  WorkoutInformationTableViewController.swift
//  Swim
//
//  Created by StephenGrinich on 3/7/17.
//  Copyright © 2017 StephenGrinich. All rights reserved.
//

import UIKit

protocol WorkoutInformationTableViewControllerDelegate {
    func workoutInformationCollectionTableViewControllerResponse(chosenWorkout: SwimWorkout)
}

class WorkoutInformationTableViewController: UITableViewController {
    
    // This is the current workout being viewed. This is simply used to populate this view controller.
    var chosenWorkout: SwimWorkout!;
    
    // This is nil unless it was otherwise set; it is set when the user selects this workout via button.
    var selectedWorkout: SwimWorkout!;
    
    var delegate: WorkoutInformationTableViewControllerDelegate?;
    
    var showBackButton: Bool = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 250;
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 41/255.0, green: 128/255.0, blue: 185/255.0, alpha: 1.0)
        
        self.tableView.backgroundColor = UIColor(red: 202/255.0, green: 232/255.0, blue: 255/255.0, alpha: 1.0)
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black;
        self.navigationController?.navigationBar.tintColor = UIColor.white;


        
        if (self.showBackButton) {
            let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WorkoutTypesTableViewController.goBack))
            navigationItem.leftBarButtonItem = backButton
            
        } else {
            let selectButton = UIBarButtonItem(title: "Select", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WorkoutInformationTableViewController.selectWorkout));
            navigationItem.rightBarButtonItem = selectButton;
            navigationItem.rightBarButtonItem?.tintColor = UIColor.green;
            
            navigationItem.title = "";
        }
    }
    
    func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectWorkout() {
        self.selectedWorkout = self.chosenWorkout;
        self.delegate?.workoutInformationCollectionTableViewControllerResponse(chosenWorkout: self.chosenWorkout);
        
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
        return chosenWorkout.getSetList().count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: SetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "setCellIdentifier", for: indexPath) as! SetTableViewCell
        
            let set = chosenWorkout.getSetList()[indexPath.row];
            
            cell.totalLabel.text = String(set.total);
        
            let distanceUnitStrokeText = set.getDisplayDistance() + set.getDisplayUnit() + " " + set.getDisplayStroke();
            cell.distanceUnitStrokeLabel.text = distanceUnitStrokeText;
            cell.noteLabel.text = set.getDisplayNote();
            
            return cell;
    }
}
