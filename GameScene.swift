//
//  GameScene.swift
//  ZappyBird
//
//  Created by Tyler Roth on 4/7/18.
//  Copyright © 2018 Fortis et Fidus. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    
    var bg = SKSpriteNode()
    
    var scoreLabel = SKLabelNode()
    
    var score = 0
    
    var gameOverLabel = SKLabelNode()
    
    var timer = Timer()
    
    
    
    
    
    enum ColliderType: UInt32 {
        
        case Bird = 1
        case Object = 2
        case Gap = 4
        
    }
    
    
    var GameOver = false
    
    @objc func makePipes() {
        let movePipes = SKAction.move(by: CGVector(dx: -2*self.frame.width, dy: 0), duration: TimeInterval(self.frame.width/100))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        //gap height
        let gapHeight = bird.size.height * 3
        
        //maxmove
        let maxMove = self.frame.height / 4
        var moveAmount = arc4random() % UInt32(self.frame.height/2)
        let pipeOffset = CGFloat(moveAmount) - maxMove
        
        //Pipes!
        
        
        let pipeTexture = SKTexture(imageNamed: "zapper1.png")
        let pipeNode = SKSpriteNode(texture: pipeTexture)
        //pipeNode.size.height = self.frame.height/2
        pipeNode.position = CGPoint(x: self.frame.width, y: self.frame.midY + pipeTexture.size().height/2 + gapHeight + pipeOffset)
        pipeNode.zPosition = 1
        pipeNode.run(moveAndRemovePipes)
        pipeNode.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipeNode.physicsBody?.isDynamic = false
        pipeNode.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        
        pipeNode.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        
        pipeNode.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        self.addChild(pipeNode)
        
        
        //bottom Pipe
        let pipeTexture2 = SKTexture(imageNamed: "zapper2.png")
        let pipeNode2 = SKSpriteNode(texture: pipeTexture2)
        //pipeNode.size.height = self.frame.height/2
        pipeNode2.position = CGPoint(x: self.frame.width, y: self.frame.midY - pipeTexture.size().height/2 - gapHeight + pipeOffset)
        pipeNode2.zPosition = 1
        pipeNode2.run(moveAndRemovePipes)
        pipeNode2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture2.size())
        
        pipeNode2.physicsBody?.isDynamic = false
        
        pipeNode2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        
        pipeNode2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        
        pipeNode2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        self.addChild(pipeNode2)
        
        
        let gap = SKNode()
        
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffset)
        
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHeight))
        
        gap.physicsBody!.isDynamic = false
        
        gap.run(moveAndRemovePipes)
        
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        
        self.addChild(gap)
        
   
        
        
    }
    
    
    //When they become in contact with eachother!!!
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if GameOver == false {
            
            if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
                
                score += 1
                
                scoreLabel.text = String(score)
                
                
            } else {
                
                self.speed = 0
                
                GameOver = true
                
                timer.invalidate()
                
                gameOverLabel.fontName = "Helvetica"
                
                gameOverLabel.fontSize = 30
                
                gameOverLabel.text = "Game Over! Tap to play again."
                
                gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                
                gameOverLabel.zPosition = 2
                
                self.addChild(gameOverLabel)
                
            }
            
        }
        
    }
    
    
    
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        setupGame()
    }
    
    
    
    
    
    func setupGame(){
        
        let birdTexture = SKTexture(imageNamed: "flappy1")
        let birdTexture2 = SKTexture(imageNamed: "flappy2")
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        let animation = SKAction.animate(with: [birdTexture,birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bird.run(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        
        bird.physicsBody!.isDynamic = false
        
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
        
        bird.zPosition = 1
        
        self.addChild(bird)
        
        
        
        //Background!
        let background = SKTexture(imageNamed: "bgnew.png")
        let moveBGanimation = SKAction.move(by: CGVector(dx: -2*background.size().width, dy: 0), duration: TimeInterval(self.frame.width/120))
        let shiftBGanimation = SKAction.move(by: CGVector(dx: 2*background.size().width, dy: 0), duration: 0)
        
        let background2 = SKTexture(imageNamed: "bgnew.png")
        let bgnode2 = SKSpriteNode(texture: background2)
        bgnode2.position = CGPoint(x: self.frame.midX + 2*background2.size().width, y: self.frame.midY)
        bgnode2.size.height = self.frame.height
        let moveBGanimation2 = SKAction.move(by: CGVector(dx: -2*background2.size().width, dy: 0), duration: TimeInterval(self.frame.width/120))
        let shiftBGanimation2 = SKAction.move(by: CGVector(dx: 2*background2.size().width, dy: 0), duration: 0)
        
        
        let backgroundStart = SKTexture(imageNamed: "bgnew.png")
        let bgnodeStart = SKSpriteNode(texture: backgroundStart)
        bgnodeStart.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bgnodeStart.size.height = self.frame.height
        let moveBGanimationStart = SKAction.move(by: CGVector(dx: -2*backgroundStart.size().width, dy: 0), duration: TimeInterval(self.frame.width/120))
        let shiftBGanimationStart = SKAction.move(by: CGVector(dx: 2*background2.size().width, dy: 0), duration: 0)
        
        
        let moveBGanimationForever = SKAction.repeatForever(SKAction.sequence([moveBGanimation, shiftBGanimation]))
        let moveBGanimationForever2 = SKAction.repeatForever(SKAction.sequence([moveBGanimation2, shiftBGanimation2]))
        let moveBGanimationForeverStart = SKAction.repeatForever(SKAction.sequence([moveBGanimationStart, shiftBGanimationStart]))
        
        let bgnode = SKSpriteNode(texture: background)
        bgnode.position = CGPoint(x: self.frame.midX + background.size().width, y: self.frame.midY)
        bgnode.size.height = self.frame.height
        
        bgnodeStart.run(moveBGanimationForeverStart)
        bgnode.run(moveBGanimationForever2)
        bgnode2.run(moveBGanimationForever)
        
        self.addChild(bgnode2)
        self.addChild(bgnode)
        self.addChild(bgnodeStart)
        
        
        
     
        
       
        
        
        
        
        //ground
        let ground = SKNode()
        
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        ground.physicsBody!.isDynamic = false
        
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
        
        
        
        //Label
        
        scoreLabel.fontName = "Helvetica"
        
        scoreLabel.fontSize = 60
        
        scoreLabel.text = "0"
        
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height/2-125)
        
        scoreLabel.zPosition = 2
        
        //button
        let gobutton = UIButton(frame: CGRect(x: self.frame.midX, y: self.frame.height/2-175, width: 44, height: 44))
        
        gobutton.backgroundColor = UIColor.red
        
        
        //self.addChild(gobutton)
        
        self.addChild(scoreLabel)
        

        }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if GameOver == false {
            
            bird.physicsBody!.isDynamic = true
            
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 80))
            
        } else {
            
            GameOver = false
            
            score = 0
            
            timer.invalidate()
            
            self.speed = 1
            
            self.removeAllChildren()
            
            setupGame()
            
            
        }
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
