//
//  SliderScene.swift
//  Swim
//
//  Created by StephenGrinich on 10/31/16.
//  Copyright © 2016 StephenGrinich. All rights reserved.
//

import SpriteKit
import UIKit
import WatchKit

class SliderScene: SKScene, WKCrownDelegate {
    
    var shaderSprite: SKSpriteNode!;
    var num = 0.0;
    var curDelta = 0.0;
    var movingForward: Bool?
    var movingBackward: Bool?
    var barAtBottom: Bool?
    var isFallingDown: Bool?

    func is42mmWatch() -> Bool {
        return WKInterfaceDevice.current().screenBounds.width > 136.0
    }
    
    override func sceneDidLoad() {
        shaderSprite = SKSpriteNode(color: UIColor.orange, size: CGSize(width: 1, height: 1));
        self.addChild(shaderSprite)
        
        let myScale = SKAction.scale(to: CGSize(width: 1.0, height: 0.0), duration: 0.0)
        shaderSprite.run(myScale);
        
        barAtBottom = true;
        isFallingDown = false;
    }
    
    
    func scale(rotationalDelta: Double) {
        if(rotationalDelta > 0){
            shaderSprite.color = UIColor.orange;
            movingForward = true;
            curDelta = curDelta + rotationalDelta
            scaleUp(rotationalDelta: curDelta);
        }
        
        if(rotationalDelta < 0){
            shaderSprite.color = UIColor.cyan;
            movingForward = false;
            curDelta = curDelta - rotationalDelta
            scaleDown(rotationalDelta: curDelta);
        }
    }
    
    func scaleUp(rotationalDelta: Double) {
        isFallingDown = false
        let scalar = rotationalDelta * 10;
        let myScale = SKAction.scale(to: CGSize(width: 1.0, height: scalar), duration: 0.3)
        shaderSprite.run(myScale);
        barAtBottom = false;
    }
        
    func scaleDown(rotationalDelta: Double) {
        isFallingDown = true;
        let scalar = rotationalDelta * 10;
        let myScale = SKAction.scale(to: CGSize(width: 1.0, height: scalar), duration: 0.3)
        shaderSprite.run(myScale);
        barAtBottom = false;
    }
    
    func fallDown() {
        let myScale = SKAction.scale(to: CGSize(width: 1.0, height: 0.0), duration: 0.3)
        curDelta = 0.0;
        shaderSprite.run(myScale);
        shaderSprite.run(myScale, completion: {self.barAtBottom = true});
    }
}
