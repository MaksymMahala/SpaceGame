//
//  GameScene.swift
//  SpaceGame
//
//  Created by Maksym on 15.10.2023.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var spriteLabel: SKLabelNode!
    var spriteText = 0{
        didSet{
            spriteLabel.text = "Sprite: \(spriteText)"
        }
    }
    
    
    let possibleEnemies = ["ball", "hammer", "tv"]
    var isGameOver = false
    var isGame = false

    var gameTimer: Timer?
    
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starField = SKEmitterNode(fileNamed: "starfield")!
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        addChild(starField)
        starField.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        spriteLabel = SKLabelNode(fontNamed: "Chalkduster")
        spriteLabel.position = CGPoint(x: 800, y: 16)
        spriteLabel.horizontalAlignmentMode = .left
        addChild(spriteLabel)

        score = 0
        
        
     
        gameTimer = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
       

        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
    }
    @objc func createEnemy(){
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        sprite.name = "sprite"
        removeEnemy(enemy: sprite)
        
        switch spriteText{
        case 0...20:
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        case 20...40:
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        case 40...60:
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        case 60...80:
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        case 80...100:
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        default:
            break
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        for node in children{
            if node.position.x < -300{
                node.removeFromParent()
                spriteText += 1
            }
        }
        if !isGameOver {
            score += 1
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)

        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }

        player.position = location
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)

        player.removeFromParent()

        isGameOver = true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let move = SKAction.move(to: CGPoint(x: 0, y: 384), duration: 0.3)
        player.run(move)
    }
    func removeEnemy(enemy: SKNode){
        if isGameOver{
            enemy.removeFromParent()
        }
    }
    func invalidate(){
    }
}
