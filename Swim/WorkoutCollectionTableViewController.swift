//
//  WorkoutCollectionTableViewController
//  
//
//  Created by StephenGrinich on 1/28/17.
//
//

import UIKit

protocol WorkoutCollectionTableViewControllerDelegate {
    func workoutCollectionTableViewControllerResponse(chosenWorkout: SwimWorkout)
}

class WorkoutCollectionTableViewController: UITableViewController, WorkoutInformationTableViewControllerDelegate {
    @IBOutlet var testLabel: UILabel!
    
    var chosenWorkout: SwimWorkout!
    var delegate: WorkoutCollectionTableViewControllerDelegate?;
    var workoutType: String = "";
    var workouts: [SwimWorkout]!;
        
    internal func workoutInformationCollectionTableViewControllerResponse(chosenWorkout: SwimWorkout) {
        self.chosenWorkout = chosenWorkout;
        self.delegate?.workoutCollectionTableViewControllerResponse(chosenWorkout: chosenWorkout);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(red: 202/255.0, green: 232/255.0, blue: 255/255.0, alpha: 1.0)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 41/255.0, green: 128/255.0, blue: 185/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black;
        self.navigationController?.navigationBar.tintColor = UIColor.white;
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workouts.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WorkoutCollectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! WorkoutCollectionTableViewCell
        let workout = self.workouts[indexPath.row] as SwimWorkout;
        
        cell.workoutNameLabel.text = workout.getWorkoutType() + " " + String(indexPath.row + 1);
        cell.totalDistanceLabel.text = workout.getTotalDistance();        
        cell.accessoryType = .disclosureIndicator;

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = self.workouts[indexPath.row] as SwimWorkout;
        self.presentWorkoutInformationViewController(chosenWorkout: workout);
        tableView.deselectRow(at: indexPath, animated: true)
        return;
    }
    
    func presentWorkoutInformationViewController(chosenWorkout: SwimWorkout) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "workoutInformationTableViewController") as! WorkoutInformationTableViewController
        controller.chosenWorkout = chosenWorkout;
        controller.delegate = self;
        
        self.navigationController?.pushViewController(controller, animated: true);
    }
}
