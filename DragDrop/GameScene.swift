import SpriteKit
import UIKit

let kAnimalNodeName:String = "movable"

class GameScene: SKScene {
    
    var background:SKSpriteNode = SKSpriteNode()
    var selectedNode:SKSpriteNode = SKSpriteNode()
    
    
    
    init(size:CGSize){
        super.init(size: size)
        background = SKSpriteNode(imageNamed: "blue-shooting-stars.png")
        background.name = "background"
        background.anchorPoint = CGPointMake(0.0, 0.0)
        self.addChild(background)
        
        // loading the images
        let imageNames:NSArray = ["bird", "cat", "dog", "turtle"]
        for i in 0 ..< imageNames.count {
            let imageNamed:String = imageNames[i] as String
            let sprite = SKSpriteNode(imageNamed: imageNamed)
            sprite.name = kAnimalNodeName
            
            let offsetFraction = ((CGFloat)(i+1) / (CGFloat)(imageNames.count + 1)) as CGFloat
            sprite.position = CGPointMake(size.width * offsetFraction, size.height / 2)
            
            background.addChild(sprite)
        }
    }
    
    
    
    
    override func didMoveToView(view: SKView) {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanFrom:")
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    func handlePanFrom(recognizer:UIPanGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Began {
            var touchLocation = recognizer.locationInView(recognizer.view)
            
            touchLocation = self.convertPointFromView(touchLocation)
            
            self.selectNodeForTouch(touchLocation)
        } else if recognizer.state == UIGestureRecognizerState.Changed {
            
            var translation = recognizer.translationInView(recognizer.view)
            translation = CGPointMake(translation.x, -translation.y)
            self.panForTranslation(translation)
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
            
        } else if recognizer.state == UIGestureRecognizerState.Ended {
            let scrollDuration = 0.2
            if selectedNode.name != kAnimalNodeName {
                let velocity = recognizer.velocityInView(recognizer.view)
                let pos = selectedNode.position
                let p = mult(velocity, s: scrollDuration)
                
                var newPos = CGPointMake(pos.x + p.x, pos.y + p.y)
                newPos = boundLayerPos(newPos)
                
                
                selectedNode.removeAllActions()
                
                let moveTo = SKAction.moveTo(newPos, duration: NSTimeInterval(scrollDuration))
                moveTo.timingMode = SKActionTimingMode.EaseOut
                selectedNode.runAction(moveTo)
                
            }
            
        }
        
    }
    
    func mult(v: CGPoint, s:CGFloat) -> CGPoint{
        return CGPointMake(v.x*s, v.y*s)
    }
    
    
    
    // 按下去
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {

//        let touch:UITouch = touches.anyObject() as UITouch
//        let positionInScene = touch.locationInNode(self)
//        selectNodeForTouch(positionInScene)
    }
   
   
    
    func selectNodeForTouch(touchLocation: CGPoint) {
        let touchedNode = self.nodeAtPoint(touchLocation) as SKSpriteNode
        
        if !touchedNode.isEqual(selectedNode) {

            selectedNode.removeAllActions()
            selectedNode.runAction(SKAction.rotateToAngle(0.0, duration: NSTimeInterval(0.1)))

            
            selectedNode = touchedNode
            
            if touchedNode.name == kAnimalNodeName {
                let sequcene = [SKAction.rotateByAngle(degToRad(-4.0), duration: NSTimeInterval(0.1)),
                                SKAction.rotateByAngle(0.0, duration: NSTimeInterval(0.1)),
                                SKAction.rotateByAngle(degToRad(4.0), duration: NSTimeInterval(0.1))]
                selectedNode.runAction(SKAction.repeatActionForever(SKAction.sequence(sequcene)))

            }
            
        }
        
    }
    
    func degToRad(degree : CGFloat) -> CGFloat{
        return degree / 180 * M_PI
    }
    
    
    
    
    // 移动
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
//        let touch = touches.anyObject() as UITouch
//        let positionInScene = touch.locationInNode(self)
//        let previouePosition = touch.previousLocationInNode(self)
//        
//        let translation = CGPointMake(positionInScene.x - previouePosition.x, positionInScene.y - previouePosition.y)
//        panForTranslation(translation)
    }
    
    func boundLayerPos(newPos: CGPoint) -> CGPoint{
        let winSize = self.size
        var retVal = newPos
        retVal.x = min(retVal.x, 0)
        retVal.x = max(retVal.x, winSize.width - background.size.width)
        retVal.y = self.position.y
        
        return retVal
    }
    
    func panForTranslation(translation: CGPoint){

        let position = selectedNode.position
        if selectedNode.name == kAnimalNodeName {
            selectedNode.position = CGPointMake(position.x + translation.x, position.y + translation.y)
        } else {
            let newPos = CGPointMake(position.x + translation.x, position.y + translation.y)
            background.position = boundLayerPos(newPos)
        }
        
    }
    

    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
