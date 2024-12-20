import SpriteKit

class GameScene: SKScene {

    private var bear = SKSpriteNode()
    private var bearWalkingFrames: [SKTexture] = []

    override func didMove(to view: SKView) {
        addBackground()
        backgroundColor = .blue
        buildBear()
       
        
    }
    
    
    
    
    func addBackground() {
        let background = SKSpriteNode(imageNamed: "BackgroundImage")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = frame.size
        background.zPosition = -1
        addChild(background)
    }
    

    func buildBear() {
        let bearAnimatedAtlas = SKTextureAtlas(named: "BearImages")
        var walkFrames: [SKTexture] = []

        let numImages = bearAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let bearTextureName = "bear\(i)"
            walkFrames.append(bearAnimatedAtlas.textureNamed(bearTextureName))
        }
        bearWalkingFrames = walkFrames

        let firstFrameTexture = bearWalkingFrames[0]
        bear = SKSpriteNode(texture: firstFrameTexture)
        bear.position = CGPoint(x: view!.frame.midX, y: view!.frame.midY)
        addChild(bear)

        animateBear()
    }

    func animateBear() {
        
        if bear.action(forKey: "walkingInPlaceBear") == nil {
            bear.run(SKAction.repeatForever(
                SKAction.animate(with: bearWalkingFrames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                withKey: "walkingInPlaceBear")
        }
    }

    func moveBear(to location: CGPoint) {
      
        let limitedX = max(min(location.x, frame.maxX - bear.size.width / 2), frame.minX + bear.size.width / 2)
        let limitedY = max(min(location.y, frame.maxY - bear.size.height / 0.60), frame.minY + bear.size.height / 2)
        
        let limitedLocation = CGPoint(x: limitedX, y: limitedY)
        

        let bearSpeed = frame.size.width / 3.0
        let moveDifference = CGPoint(x: limitedLocation.x - bear.position.x, y: limitedLocation.y - bear.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        let moveDuration = distanceToMove / bearSpeed

    
        let moveAction = SKAction.move(to: limitedLocation, duration: moveDuration)
        let stopAction = SKAction.run {
            self.bear.removeAllActions()
        }

        bear.run(SKAction.sequence([moveAction, stopAction]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        var multiplierForDirection: CGFloat
        if location.x < frame.midX {
            // walk left
            multiplierForDirection = 1.0
        } else {
            // walk right
            multiplierForDirection = -1.0
        }

        bear.xScale = abs(bear.xScale) * multiplierForDirection


        moveBear(to: location)

        
        animateBear()
    }
    
    func jumpBear() {
        let jumpAction = SKAction.moveBy(x: 0, y: 150, duration: 0.5)
        let fallAction = SKAction.moveBy(x: 0, y: -150, duration: 0.5)
        let jumpSequence = SKAction.sequence([jumpAction, fallAction])
        bear.run(jumpSequence)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        jumpBear()
        
    }

}
