//
//  InterfaceController.swift
//  Swim WatchKit Extension
//
//  Created by StephenGrinich on 10/30/16.
//  Copyright © 2016 StephenGrinich. All rights reserved.
//

import WatchKit
import Foundation
import SpriteKit
import SceneKit
import WatchConnectivity

class InstructionInterfaceController: WKInterfaceController, WKCrownDelegate, WCSessionDelegate {

    @IBOutlet var navSlider: WKInterfaceSKScene!;
    var scene: SliderScene!;
    
    // this used to be called jsonDict
//    var workoutList: [Dictionary<String, Any>]!;
    
    var chosenWorkout: SwimWorkout!;
    var workoutService = SwimWorkoutService();
    
    var workoutProgramList: [SwimWorkout] = []
    
    @IBOutlet var navigationTutorialText: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let payload = context as! [String : Any];
        
        let rowIndex = payload["rowIndex"] as! Int;
        self.workoutProgramList = payload["workoutProgramList"] as! [SwimWorkout];
        
        self.chosenWorkout = self.workoutProgramList[rowIndex];
        
        scene = SliderScene();
        navSlider.preferredFramesPerSecond = 30
        navSlider.presentScene(scene)
        
        self.navigationTutorialText.setText("Rotate digital crown clockwise to iterate forward through your sets. Rotate counter-clockwise to iterate backwards.");
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
//        self.crownSequencer.resignFocus();
    }
    
    override func didAppear() {
        if WCSession.isSupported() {
            let session = WCSession.default();
            session.delegate = self;
            session.activate();
        }
        
//        scene = SliderScene();
//        navSlider.preferredFramesPerSecond = 30
//        navSlider.presentScene(scene)
        
        
        self.crownSequencer.delegate = self;
        self.crownSequencer.focus();
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        scene.scale(rotationalDelta: rotationalDelta);
        navSlider.presentScene(scene);
        
        if(scene.shaderSprite.size.height > 2.2){
            if(scene.movingForward == true){
                
                let payload: AnyObject? = ["chosenWorkout": self.chosenWorkout, "workoutProgramList": self.workoutProgramList] as AnyObject?;
                
//                let workoutContext: AnyObject? = self.chosenWorkout as AnyObject?;
                if (payload != nil) {
                    self.crownSequencer.resignFocus();
                    WKInterfaceController.reloadRootControllers(withNamesAndContexts: [(name: "SetInterfaceController", context: payload! )]);
                } else{
                    let action = WKAlertAction(title: "OK", style: .cancel) {}
                    presentAlert(withTitle: "Select Workout", message: "Please select workout on iPhone",preferredStyle: .alert, actions: [action])
                }
            }
        }
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        scene.fallDown();
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("func 1");
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("func 2");
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print("func 3")
        
        // TODO: Ideally send object over from iPhone and pick it up here.
//        NSKeyedUnarchiver.setClass(SwimWorkout.self, forClassName: "SwimWorkout");
//        NSKeyedUnarchiver.setClass(SwimSet.self, forClassName: "SwimSet");
//        let unarchiver =  NSKeyedUnarchiver(forReadingWith: messageData);
//        unarchiver.
//
//        do {
//            let decodedDataObject = try unarchiver.decodeTopLevelObject()
//            
//            print("Decoded Data Object: ", decodedDataObject);
//            
//            if let newChosenWorkout = decodedDataObject {
//                print("success");
//            } else {
//                print("failure");
//            }
//        } catch {
//            print("within catch");
//        }
//        
    
    }
    
//    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
//        print("func 4");
//    }
//    
//    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String : Any]) -> Void) {
//        print("func 5 instruciton");
//        
//        let receivedObject = message as Dictionary<String, Any>;
//        let workoutList = receivedObject["workout"] as! (file: [Dictionary<String, Any>], workoutType: String)!;
//        
//        // this needs to be changed
//        let receivedWorkout = workoutService.getWorkoutFromJSON(json: (workoutList?.file)!, workoutType: (workoutList?.workoutType)!)
//        
//        self.workoutProgramList.append(receivedWorkout);
//        
//        
//        // TODO: This class is expecting having a chosenWorkout to be sent to the next view. need to create a view controller for
//        // right beore this that recieves the individual objects and creates the list.
//    }
}

