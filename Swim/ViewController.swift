//
//  ViewController.swift
//  Swim
//
//  Created by StephenGrinich on 10/30/16.
//  Copyright © 2016 StephenGrinich. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WorkoutCollectionTableViewControllerDelegate {
    
    @IBOutlet var workoutCollectionTableView: UITableView!
    
    @IBOutlet var sendToWatchButton: UIButton!
    
    var chosenWorkout: SwimWorkout!;
    
    var workoutCollections = ["Sprint", ]
    var workoutService = SwimWorkoutService();
    var workoutCollectionService = SwimWorkoutCollectionService();
    
    var session: WCSession!;
    
    
    internal func workoutCollectionTableViewControllerResponse(chosenWorkout: SwimWorkout) {
        self.chosenWorkout = chosenWorkout;
        self.setButtonLabel();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.establishWCSession();

        workoutCollectionTableView.delegate = self;
        workoutCollectionTableView.dataSource = self;
    }
    
    func establishWCSession() {
        if WCSession.isSupported() {
            self.session = WCSession.default();
            self.session.delegate = self;
            self.session.activate();
        }
    }
    
    func presentWorkoutChoiceViewController(chosenWorkoutType: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "workoutCollectionTableViewController") as! WorkoutCollectionTableViewController
        
        controller.workoutType = chosenWorkoutType;
        controller.workouts = self.workoutCollectionService.getAllWorkoutsForCollection(collection: chosenWorkoutType)
        
        controller.delegate = self;
        
        let navController = UINavigationController(rootViewController: controller);
        self.showDetailViewController(navController, sender: nil);
    }
    
    func setButtonLabel() {
        self.sendToWatchButton.setTitle("Send " + self.chosenWorkout.getTotalDistance() + " " + self.chosenWorkout.getWorkoutType() + " to Watch", for: UIControlState.normal);
    }
    
    @IBAction func sendToWatchButton(_ sender: Any) {
        if((self.chosenWorkout) != nil){
            
                if(!self.session.isPaired) {
                    let alert = UIAlertController(title: "Wait", message: "You must connect an Apple Watch for this functionality.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                } else {
                    
                    // TODO: try to get this to work
                    
//                    let data = NSKeyedArchiver.archivedData(withRootObject: self.chosenWorkout);
//                    NSKeyedArchiver.setClassName("SwimWorkout", for: SwimWorkout.self);
//                    NSKeyedArchiver.setClassName("SwimSet", for: SwimSet.self);
//                    
//                    print("Here is data: ", data);
//                    self.session.sendMessageData(data, replyHandler: { (response) -> Void in
//                        print("Response 1: ", response);
//                    }, errorHandler: { (error) in
//                        print("error 1: ", error);
//                    })
                    
                    // TODO: This is bad. Should send actual object, but xcode makes this hard.
                    
                    let json = workoutService.getJSON(filename: self.chosenWorkout.filename);
                    self.session.sendMessage(["workout": json], replyHandler: { (response) -> Void in
                        print("Response 1: ", response);
                            }, errorHandler: { (error) in
                                print("error 1: ", error);
                    });
                }
        } else {
            let alert = UIAlertController(title: "Wait", message: "You must choose a workout to send to your wearable.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutCollectionService.getWorkoutTypeLabels().count;
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WorkoutCollectionChoicesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! WorkoutCollectionChoicesTableViewCell
        
        cell.collectionLabel.text = workoutCollectionService.getWorkoutTypeLabels()[indexPath.row];
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentWorkoutChoiceViewController(chosenWorkoutType: workoutCollectionService.getWorkoutTypeLabels()[indexPath.row])
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        return;
    }
    


}

extension ViewController: WCSessionDelegate {
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession) {
        print("session did deactive");
    }

    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session did become inacive viewcontroller")
    }

    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        print("Session test a");
        
        if(session.isReachable){
            
            print("Session is reachable");
//            let json = self.workoutService.getJSON(filename: self.workoutChosen);
//            let workout = self.workoutService.getWorkoutFromJSONFilename(filename: self.workoutChosen, workoutType: "no type");
//            
//            session.sendMessage(["workouts":json], replyHandler: { (response) -> Void in
//                print("Response: ", response);
//            }, errorHandler: { (error) in
//                print("error: ", error);
//            })
            
            
//            let data = NSKeyedArchiver.archivedData(withRootObject: self.chosenWorkout);
//            
//            print("Here is data: ", data);
//            
//            session.sendMessageData(data, replyHandler: { (response) -> Void in
//                
//                print("Response 1: ", response);
//            }, errorHandler: { (error) in
//                print("error 1: ", error);
//            })

//            session.sendMessage(["workout": data], replyHandler: { (response) -> Void in
//                print("Response 2: ", response);
//            }, errorHandler: { (error) in
//                print("error 2: ", error);
//            })
            
//            session.sendMessage(["workout": self.chosenWorkout], replyHandler: { (response) -> Void in
//                print("Response: ", response);
//            }, errorHandler: { (error) in
//                print("error: ", error);
//            })
            
        }
        else{
            print("Session is not reachable");
        }
    }
    
}

