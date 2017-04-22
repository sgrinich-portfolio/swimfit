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

class RootSetInterfaceController: WKInterfaceController, WKCrownDelegate {

    @IBOutlet var navSlider: WKInterfaceSKScene!
    var rotationValue: Double = 0.0;
    var scene: SliderScene!;
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        scene = SliderScene();
        navSlider.preferredFramesPerSecond = 30
        navSlider.presentScene(scene)
        
        self.crownSequencer.delegate = self;
    }
    
    override func willActivate() {
        super.willActivate()
        self.crownSequencer.focus();
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        print(rotationalDelta);
        
        scene.scale(rotationalDelta: rotationalDelta);
        navSlider.presentScene(scene)
        
        if(scene.shaderSprite.size.height > 2.2) {
            
        }
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        self.rotationValue = 0.0;
        scene.fallDown();
    }
    
    func setSwimWorkout(){
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = HKWorkoutActivityType.swimming;
    }
    
}
