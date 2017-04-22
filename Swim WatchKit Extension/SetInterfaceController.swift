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
import HealthKit
import WatchConnectivity


class SetInterfaceController: WKInterfaceController, WKCrownDelegate {

    @IBOutlet var navSlider: WKInterfaceSKScene!
    @IBOutlet var strokeLabel: WKInterfaceLabel!
    @IBOutlet var interfaceTimer: WKInterfaceTimer!
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    @IBOutlet var intervalLabel: WKInterfaceLabel!
    @IBOutlet var notesLabel: WKInterfaceLabel!
    
    var rotationValue: Double = 0.0;
    
    var scene: SliderScene!;
    
    // MARK: Properties
    
    let healthStore = HKHealthStore()
    
//    var workoutSession : HKWorkoutSession?
    
    var activeDataQueries = [HKQuery]()
    
//    let parentConnector = ParentConnector()
    
    var workoutStartDate : Date?
    
    var workoutEndDate : Date?
    
    var timer : Timer?
    
    var workoutStartTime: NSDate?
    
    var totalEnergyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 0)
    
    var totalDistance = HKQuantity(unit: HKUnit.meter(), doubleValue: 0)
    
    var workoutEvents = [HKWorkoutEvent]()
    
    var metadata = [String: AnyObject]()
    
    var isPaused = false
    
    var chosenWorkout: SwimWorkout!;
    
    var workoutPosition = 0;
    
    var canUpdate = true;
    
    var workoutProgramList: [SwimWorkout] = [];
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.crownSequencer.delegate = self;
        
        
        let payload = context as! [String: Any];
        
        self.chosenWorkout = payload["chosenWorkout"] as! SwimWorkout;
        self.workoutProgramList = payload["workoutProgramList"] as! [SwimWorkout];
        
        self.updateLabels()
        
        
//        if let workout = context as? SwimWorkout{
//            self.chosenWorkout = workout;
//            self.updateSetLabels();
//        }
        
//        else{
//            print("SetInterfaceController did not receive context.");
//        }
        
        
        scene = SliderScene();
        
        navSlider.preferredFramesPerSecond = 30
        navSlider.presentScene(scene)
        
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = HKWorkoutActivityType.swimming;
        do{
//            workoutSession = try HKWorkoutSession(configuration: workoutConfiguration)
//            workoutSession?.delegate = self;
            workoutStartDate = Date()
//            healthStore.start(workoutSession!);
        } catch{
            print("within catch")
        }
    }
    
    @IBAction func onStopTouch() {
        workoutEndDate = Date()
//        healthStore.end(workoutSession!)
    }
    
    @IBAction func onMenuStopTouch() {
        
        WKInterfaceController.reloadRootControllers(withNames: ["HomeInterfaceController"], contexts: [self.workoutProgramList]);
        
        

//        let action = WKAlertAction(title: "OK", style: .cancel) {
//        WKInterfaceController.reloadRootControllers(withNames: ["HomeInterfaceController"], contexts: nil);
//            }        
//        presentAlert(withTitle: "End Workout?", message: "You will lose all progress in this workout", preferredStyle: .alert, actions: [action])
        
    }
    // MARK: Totals
    
    private func totalCalories() -> Double {
        return totalEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
    }
    
    private func totalMeters() -> Double {
        return totalDistance.doubleValue(for: HKUnit.meter())
    }
    
    private func setTotalCalories(calories: Double) {
        totalEnergyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
    }
    
    private func setTotalMeters(meters: Double) {
        totalDistance = HKQuantity(unit: HKUnit.meter(), doubleValue: meters)
    }
    
    private func setSwimmingStrokeCount(yards: Double) {
        totalDistance = HKQuantity(unit: HKUnit.yard(), doubleValue: yards)
    }
    
    override func willActivate() {
        super.willActivate()
        self.crownSequencer.focus();
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    
    // MARK: Handle crown rotation interface
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        scene.scale(rotationalDelta: rotationalDelta);
        
        if(canUpdate){
            navSlider.presentScene(scene)
            
            if(scene.shaderSprite.size.height > 2.2) {
                
                if(scene.movingForward == false){
                    //                self.crownSequencer.resignFocus();
                    //                workoutEndDate = Date()
                    //                healthStore.end(workoutSession!)
                    //                WKInterfaceController.reloadRootControllers(withNames: ["InstructionInterfaceController"], contexts: nil);
                    
                    if(canUpdate){
                        if(workoutPosition > 0) {
                            workoutPosition = workoutPosition - 1
                            updateSetLabels();
                            canUpdate = false;
                        }
                        
                    }
                }
                else{
                    if(canUpdate){
//                        print("workouts.count ", swimSets.count);
                        if(workoutPosition < (self.chosenWorkout.setList.count - 1)) {
                            workoutPosition = workoutPosition + 1
                            updateSetLabels();
                            canUpdate = false;
                        }
                        
                    }
                }
            }
        }
        
        
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        canUpdate = true;
        self.rotationValue = 0.0;
        scene.fallDown();
    }
    
    func updateSetLabels() {
        distanceLabel.setText(String(self.chosenWorkout.setList[workoutPosition].distance) + " " + self.chosenWorkout.setList[workoutPosition].unit);
        strokeLabel.setText(self.chosenWorkout.setList[workoutPosition].stroke);
        intervalLabel.setText("@ " + self.chosenWorkout.setList[workoutPosition].interval);
        notesLabel.setText(self.chosenWorkout.setList[workoutPosition].notes);
    }
    
    
    // MARK: HKWorkoutSessionDelegate
    
//    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
//        print("workout session did fail with error: \(error)")
//    }
//    
//    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
//        workoutEvents.append(event)
//    }
//    
//    func workoutSession(_ workoutSession: HKWorkoutSession,
//                        didChangeTo toState: HKWorkoutSessionState,
//                        from fromState: HKWorkoutSessionState,
//                        date: Date) {
//        switch toState {
//        case .running:
//            if fromState == .notStarted {
//                startAccumulatingData(startDate: workoutStartDate!)
//            } else {
//                resumeAccumulatingData()
//            }
//            
//        case .paused: pauseAccumulatingData()
//                    print("paused");
//            
//        case .ended:
//            print("has now ended");
//            stopAccumulatingData();
////            saveWorkout();
//            
//        default: break;
//        }
//        
//        updateLabels()
////        updateState()
//    }
    
    // MARK: Data Queries
    
    func startAccumulatingData(startDate: Date) {
//        startQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        startQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier.swimmingStrokeCount)
        startQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier.distanceSwimming)
        startQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier.heartRate)
        startQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        
        startTimer()
    }
    
    func startQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictStartDate)
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let queryPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])
        
        let updateHandler: ((HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void) = { query, samples, deletedObjects, queryAnchor, error in
            self.process(samples: samples, quantityTypeIdentifier: quantityTypeIdentifier)
        }
        
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!,
                                          predicate: queryPredicate,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit,
                                          resultsHandler: updateHandler)
        query.updateHandler = updateHandler
        healthStore.execute(query)
        
        activeDataQueries.append(query)
    }
    
    func process(samples: [HKSample]?, quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self, !strongSelf.isPaused else { return }
            
            if let quantitySamples = samples as? [HKQuantitySample] {
                for sample in quantitySamples {
                    
                    if quantityTypeIdentifier == HKQuantityTypeIdentifier.distanceWalkingRunning {
                        let newMeters = sample.quantity.doubleValue(for: HKUnit.meter())
                        strongSelf.setTotalMeters(meters: strongSelf.totalMeters() + newMeters)
                    } else if quantityTypeIdentifier == HKQuantityTypeIdentifier.activeEnergyBurned {
                        let newKCal = sample.quantity.doubleValue(for: HKUnit.kilocalorie())
                        strongSelf.setTotalCalories(calories: strongSelf.totalCalories() + newKCal)
                    }
                    
//                     else if quantityTypeIdentifier == HKQuantityTypeIdentifier.distanceSwimming {
//                        let newStrokeCount = sample.quantity.doubleValue(for: HKUnit.yard()));
//                        strongSelf.setSwimmingStrokeCount(yards: strongSelf.tot)(calories: strongSelf.totalCalories() + newKCal)
//                    }
                    
                    
                    
//                    startQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier.swimmingStrokeCount)
//                    startQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier.distanceSwimming)
//                    startQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier.heartRate)
//                    startQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
                    
                    
                }
             
                strongSelf.updateLabels()
            }
        }
    }
    
    func stopAccumulatingData() {
        for query in activeDataQueries {
            healthStore.stop(query)
        }
        
        activeDataQueries.removeAll()
        stopTimer()
    }
    
    func pauseAccumulatingData() {
        DispatchQueue.main.sync {
            isPaused = true
        }
    }
    
    func resumeAccumulatingData() {
        DispatchQueue.main.sync {
            isPaused = false
        }
    }
    
    private func saveWorkout() {
        // Create and save a workout sample
//        let configuration = workoutSession!.workoutConfiguration
//        let isIndoor = (configuration.locationType == .indoor) as NSNumber
//        print("locationType: \(configuration)")
//        
//        let workout = HKWorkout(activityType: configuration.activityType,
//                                start: workoutStartDate!,
//                                end: workoutEndDate!,
//                                workoutEvents: workoutEvents,
//                                totalEnergyBurned: totalEnergyBurned,
//                                totalDistance: totalDistance,
//                                metadata: [HKMetadataKeyIndoorWorkout:isIndoor]);
//        
//        healthStore.save(workout) { success, _ in
//            if success {
//                self.addSamples(toWorkout: workout)
//            }
//        }
//        
//        // Pass the workout to Summary Interface Controller
//        WKInterfaceController.reloadRootControllers(withNames: ["SummaryInterfaceController"], contexts: [workout])
    }
    
    private func addSamples(toWorkout workout: HKWorkout) {
        // Create energy and distance samples
        let totalEnergyBurnedSample = HKQuantitySample(type: HKQuantityType.activeEnergyBurned(),
                                                       quantity: totalEnergyBurned,
                                                       start: workoutStartDate!,
                                                       end: workoutEndDate!)
        
        let totalDistanceSample = HKQuantitySample(type: HKQuantityType.distanceWalkingRunning(),
                                                   quantity: totalDistance,
                                                   start: workoutStartDate!,
                                                   end: workoutEndDate!)
        
        // Add samples to workout
        healthStore.add([totalEnergyBurnedSample, totalDistanceSample], to: workout) { (success: Bool, error: Error?) in
            if success {
                // Samples have been added
            }
        }
    }
    
    // MARK: Convenience
    
    func updateLabels() {
//        strokeLabel.setText(format(distance: totalDistance))
    }
    
    // MARK: Timer code
    func startTimer() {
        interfaceTimer.setDate(NSDate(timeIntervalSinceNow: 0.0) as Date)
        interfaceTimer.start()
        self.workoutStartTime = NSDate()
    }
    
    func stopTimer() {
        interfaceTimer.stop();
    }
    
}

extension SetInterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) { }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) { }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) { }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        let message = [message] as [Dictionary<String, Any>]
    }
}
