import UIKit
import SceneKit
import ARKit
import AVFoundation

enum Tutorial {
    case moveToCenterScene
    case pointViewStar
    case tapInfo
    case pointViewStartStar
    case constellationFinished
}

struct Constellation {
    var name: String
    var description: String
    var image: UIImage
    var lastNode: Int
    var spheresCount: Int
    var starsNames: [String]
}


public class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, SCNPhysicsContactDelegate, UIGestureRecognizerDelegate, ARDetailViewDelegate, AlienViewDelegate {
    
    
    func didStartDetecting() {}
    
    var stateTutorial = Tutorial.moveToCenterScene

    func updateHelpView() {
        if stateTutorial == .moveToCenterScene {
            helpViewDraw.setUpText(text: "So many stars! Get closer to the Sun and touch a blue star")
            helpViewDraw.viewBounce()
        }
    }
    
    let restartButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "restart.png")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(restart), for: .touchUpInside)
        return button
    }()
    
    lazy var sceneView: ARSCNView = {
        let sceneView = ARSCNView()
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        return sceneView
    }()
    
    //Bool
    var start = false
    var foundSurface = false
    var tracking = true
    var dragOnInfinitePlanesEnabled = false
    var shouldPresentARDetailView = true
    var isUniverseScene = false
    var isTrackerNodePositioned = false
    var createdRocket = false
    var boolPhysicsWorld = true

    
    //Int
    var lastNode = 0
    var numSphere = 1
    var numTotDots = 0
    var count = 0
    var numOfConstellationDid = 0
    
    //Vectors
    var succSpherePosition: SCNVector3?
    var positionSelectedSphere: SCNVector3?
    var trackingPosition = SCNVector3()
    var infoNodePosition: SCNVector3?
    var cameraPosition = SCNVector3(x: 0, y: 0, z: 0)
    var listConstellation = [Constellation]()
    var scenePosition = SCNVector3()
        
    func populateList() {
        guard let imageOrion = UIImage(named: "Orion"), let imageSerena = UIImage(named: "Serena"), let imageAries = UIImage(named: "Aries"), let imageBigDipper = UIImage(named: "BigDipper") else {
            return
        }
        
        let bigDipper = Constellation(name: "Big Dipper", description: "It is a part of Ursa Major constellation. The stars that form the bowl represent a coffin and the three stars marking the handle are mourners following it. ", image: imageBigDipper, lastNode: 4, spheresCount: 8, starsNames: ["AlKaid", "Mizar", "Alioth", "Megrez", "Dubhe", "Merak", "Phecda", "Megrez"])
        
        let aries = Constellation(name: "Aries", description: "Aries represents a ram’s horn, it belongs to the Zodiac family of constellations and it was the first catalogued by a Greek astronomer in the 2nd century.", image: imageAries, lastNode: 4, spheresCount: 4, starsNames: ["Mesarthim", "Sheratan", "Hamal", "41 Ari"])
        
        let serena = Constellation(name: "Serena", description: "That's a constellation that represents tennis champion Serena Williams by her racket. You can see it during nautical twilight in September. ", image: imageSerena, lastNode: 2, spheresCount: 7, starsNames: ["Without name", "Thuban", "Star without name", "Star without name", "Pherkad", "Kochab", "No name"])
        
        let orion = Constellation(name: "Orion", description: "Orion is one of the most recognizable constellations in the night and visible throughout the world, it represents Orion’s body, a hunter in Greek mythology.", image: imageOrion, lastNode: 1, spheresCount: 7, starsNames: ["Saiph", "Rigel", "Mintaka", "Bellatrix", "Betelgeuse", "Alnitak", "Saiph"])
        
        listConstellation = [serena, aries, bigDipper, orion]

    }
    
    
    //Nodes
    var engineRocket = SCNNode()
    var rocketShip = SCNNode()
    var nodes = [SCNNode]()
    var planeNode = SCNNode()
    var trackerNode: SCNNode?
    var container: SCNNode!
    var reactorParticleSystem = SCNParticleSystem()
    var focusSquare: FocusSquare?
    var line: LineNode?
    var lines: [LineNode] = []
    let constellations = SCNNode()
    let rocketDotsNode = SCNNode()
    let universeSphere = SCNSphere(radius: 15)
    var universeNode = SCNNode()
    let imageTracker = UIImageView(image: UIImage(named: "Tracker"))
    var earthParent = SCNNode()
    var moonParent = SCNNode()
    var sun = SCNNode()
    var sunSphere = SCNSphere(radius: 0.06)
    var earthSphere = SCNSphere(radius: 0.03)
    var moonSphere = SCNSphere(radius: 0.01)
    var succNode = SCNNode()
    
    //Other
    var currentAngleY: Float = 0.0
    let session = ARSession()
    var sessionConfig =  ARWorldTrackingConfiguration()
    var screenCenter: CGPoint?
    let countDown = CountDown(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var trackingStateString = ""
    
    //Sounds
    var soundTrackPlayer: AVAudioPlayer?
    var rocketLaunchSoundPlayer: AVAudioPlayer?
    
    let starNameView: StarNameView = {
        let view = StarNameView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let helpViewDraw: StarNameView = {
        let view = StarNameView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let helpView: StarNameView = {
        let view = StarNameView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let configuration = ARWorldTrackingConfiguration()

    
    var nameConstellation = ""
    var infoView: InfoNodeView = {
        let view = InfoNodeView(frame: CGRect(x: 3000, y: 1000, width: 170, height: 50))
        view.backgroundColor = UIColor.white
        return view
    }()
    

    

    func setUpStarNameView() {
        view.addSubview(starNameView)
        starNameView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        starNameView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 10).isActive = true
    }
    
    func waitForPrepareForTakeoff() {
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(rocketPrepareTakeOff), userInfo: nil, repeats: false)
    }
    
    func truePhysicsWorld() {
        boolPhysicsWorld = true
    }
    

    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        count += 1
        if boolPhysicsWorld {
            boolPhysicsWorld = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.boolPhysicsWorld = true
            })
            stateTutorial = .pointViewStar
            numSphere += 1
            contact.nodeA.physicsBody = nil
            contact.nodeB.physicsBody = nil
            line?.endNode.position = succSpherePosition!
            line?.sphereTouchedPosition(camera: self.sceneView.session.currentFrame?.camera, position: succSpherePosition!)
            createLine()
            if numSphere < numTotDots {
                createLine()
            }else{
                start = true
                clearNodeColor()
                numSphere = 1
                numOfConstellationDid += 1
                starNameView.setUpText(text: "✅ \(nameConstellation) completed!")
                starNameView.viewBounce()
                guard let infoNodePosition = self.infoNodePosition else {print("No InfoPosition");return}
                createNodeInfo(position: infoNodePosition, nameOfNode: "\(nameConstellation)Info", nameConstellation: nameConstellation)
                stateTutorial = .tapInfo
                helpViewDraw.setUpText(text: "Great Job! Tap label to know more")
                
            }
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     }

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(infoView)
        populateList()
        view.backgroundColor = UIColor.black
        setupScene()
        setupInfoView()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        helpView.removeFromSuperview()
        restartPlaneDetection()
        setUpHelpViewTracking()
        sceneView.delegate = self
        setupFocusSquare()
        runARSession()
        sceneView.session.run(configuration)
        setUpRestartbutton()

        DispatchQueue.main.async {
            self.screenCenter = self.sceneView.bounds.mid
        }
        
    }
    
    
    func setupScene() {
        sceneView.delegate = self
        sceneView.session = session
        sceneView.antialiasingMode = .multisampling4X
        sceneView.preferredFramesPerSecond = 60
        sceneView.contentScaleFactor = 1.3
        DispatchQueue.main.async {
            self.screenCenter = self.sceneView.bounds.mid
        }
        view.addSubview(sceneView)
        sceneView.fillToSuperview(includeNotch: true)
        sceneView.fillToSuperview()
        view.bringSubview(toFront: sceneView)
    }
    
    
    func runARSession() {
        configuration.planeDetection = .horizontal
        sceneView.session = session
        sceneView.session.run(configuration)
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let tappedView = sender.view as! SCNView
        let touchLocation = sender.location(in: tappedView)
        let hitTest = tappedView.hitTest(touchLocation, options: nil)
        
        if isTrackerNodePositioned == false && focusSquare?.isOpen == false {
            isTrackerNodePositioned = true
            if createdRocket {
                trackerNode?.removeFromParentNode()
                setUpInstantUniverse()
            }else{
                restartButton.isHidden = true
                createdRocket = true
                createRocket()
                waitForPrepareForTakeoff()
            }
            helpView.removeFromSuperview()
        }
        
        if !hitTest.isEmpty {
            let result = hitTest.first!
            let name = result.node.name
            for constellation in listConstellation {
                if name == "\(constellation.name)Info" {
                    presentDetailView(node: result.node, name: constellation.name, description: constellation.description, image: constellation.image)
                }
                if name == "\(constellation.name)1" {
                    if start == true {
                        stateTutorial = .pointViewStar
                        start = false
                        lastNode = constellation.lastNode
                        nameConstellation = constellation.name
                        numTotDots = constellation.spheresCount
                        createLine()
                    }
                }
            }
        }
    }
    
    func createLine() {
        self.sceneView.scene.rootNode.enumerateChildNodes {(node,_) in
            if node.name == "\(nameConstellation)Info" {
                self.infoNodePosition = node.worldPosition
            }
            
            if node.name == "\(nameConstellation)\(numSphere)" {
                nodes.append(node)
                
                for constellation in listConstellation {
                    if constellation.name == nameConstellation {
                        if isUniverseScene == true {
                            starNameView.alpha = 1
                            starNameView.setUpText(text: "⭐ \(constellation.starsNames[numSphere-1])")
                            starNameView.viewBounce()
                        }
                    }
                }
                
                if node.name == "\(nameConstellation)\(lastNode)" {
                    node.name = "\(nameConstellation)\(numTotDots)"
                }
                positionSelectedSphere = node.worldPosition
            }
            
            if node.name == "\(nameConstellation)\(numSphere+1)" {
                createPhysicsBody(node: node, radius: 0.055, categoryBitMask: 5, contactTestBitMask: 10)
                
                clearNodeColor()
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                node.geometry?.firstMaterial?.emission.contents = UIColor.white
                succSpherePosition = node.worldPosition
                succNode = node
                
            }
        }
        placeAction(startPos: positionSelectedSphere!)
        guard  let endNode = line?.endNode else {
            print("No end node")
            return
        }
        createPhysicsBody(node: endNode, radius: 0.007, categoryBitMask: 10, contactTestBitMask: 5)
        if numSphere == numTotDots {
            clearNodeColor()
        }
    }
    
    func createPhysicsBodyCylinder(node: SCNNode, radius: CGFloat, categoryBitMask: Int, contactTestBitMask: Int) {
        let sphereBody = SCNPhysicsShape(geometry: SCNCylinder(radius: 0.01, height: 1), options: nil)
        let physicsBody = SCNPhysicsBody(type: .static, shape: sphereBody)
        node.physicsBody = physicsBody
        node.physicsBody?.categoryBitMask = categoryBitMask
        node.physicsBody?.contactTestBitMask = contactTestBitMask
    }
    
    
    
    
    func createRocket() {
        
        let width = 0.5
        let height = 0.5
        scenePosition = trackingPosition
        guard let rocketshipScene = SCNScene(named: "Models.scnassets/rocketship.scn"),
            let rocketshipNode = rocketshipScene.rootNode.childNode(withName: "rocketship", recursively: false),
            let engineNode = rocketshipNode.childNode(withName: "node2", recursively: false)
            else { return }
        engineRocket = engineNode
        reactorParticleSystem = SCNParticleSystem(named: "Models.scnassets/reactor.scnp", inDirectory: nil)!
        rocketShip = rocketshipNode
        let plane = SCNPlane(width: CGFloat(width), height: CGFloat(height))
        planeNode = SCNNode(geometry: plane)
        planeNode.opacity = 0
        planeNode.position = scenePosition
        planeNode.eulerAngles.x = -.pi / 2
        let shape = SCNPhysicsShape(geometry: plane, options: nil)
        let physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        planeNode.physicsBody = physicsBody
        rocketShip.position = scenePosition
        rocketShip.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        rocketShip.scale = SCNVector3(0.03, 0.03, 0.03)
        self.sceneView.scene.rootNode.enumerateChildNodes {(node,_) in
            node.removeFromParentNode()
        }
        sceneView.scene.rootNode.addChildNode(rocketShip)
        sceneView.scene.rootNode.addChildNode(planeNode)
    }
    
    func createSun() {
        let materialSun = SCNMaterial()
        materialSun.diffuse.contents = UIImage(named: "sunTexture.jpg")
        sunSphere.materials = [materialSun]
        sun = SCNNode(geometry: sunSphere)
        sun.position = SCNVector3(scenePosition.x, scenePosition.y + 0.65, scenePosition.z)
        sceneView.scene.rootNode.addChildNode(sun)
    }
    
    
    func setUpUniverse() {
        createSun()
        createEarth()
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "stars_milky_way.png")
        material.isDoubleSided = true
        universeSphere.materials = [material]
        universeNode = SCNNode(geometry: universeSphere)
        universeNode.position = scenePosition
        sceneView.scene.rootNode.addChildNode(universeNode)
        universeNode.opacity = 0
        constellations.opacity = 0
        sun.opacity = 0
        earthParent.opacity = 0
        moonParent.opacity = 0
    }
    
    func setUpInstantUniverse() {
        scenePosition = trackingPosition
        createSun()
        createEarth()
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "stars_milky_way.png")
        material.isDoubleSided = true
        universeSphere.materials = [material]
        universeNode = SCNNode(geometry: universeSphere)
        universeNode.position = scenePosition
        sceneView.scene.rootNode.addChildNode(universeNode)
        isUniverseScene = true
        addObject(position: scenePosition, sceneView: sceneView, node: constellations, objectPath: "Models.scnassets/constellations.scn")
        setUpStarNameView()
    }
    
    
    private func presentDetailView(node: SCNNode, name: String, description: String, image: UIImage) {
        if shouldPresentARDetailView == true {
            let screenCoordinate = self.sceneView.projectPoint(node.position)
            let xPosition = CGFloat(screenCoordinate.x)
            let yPosition = CGFloat(screenCoordinate.y)
            let detailView = ARDetailView(frame: CGRect(x: xPosition, y: yPosition, width: 500, height: 200))
            view.addSubview(detailView)
            detailView.delegate = self
            detailView.node = node
            detailView.setImageLabels(image: image, title: name, description: description)
            detailView.show()
            helpViewDraw.alpha = 0
            shouldPresentARDetailView = false
        }
    }
    
    
    @objc func rocketTakeOff() {
        playBackgroundSound()
        disappearCountDown()
        timerAppearHelpViewDraw()
        rocketShip.physicsBody!.isAffectedByGravity = false
        rocketShip.physicsBody!.damping = 0
        reactorParticleSystem.colliderNodes = [planeNode]
        let direction = SCNVector3(0, 0.2, 0)
        let action = SCNAction.moveBy(x: 0, y: 0.3, z: 0, duration: 5)
        rocketShip.physicsBody!.applyForce(direction, asImpulse: true)
        action.timingMode = .easeInEaseOut
        countDown.removeLabelTitle()
        rocketShip.runAction(action)
        isUniverseScene = true
        let fadeOpacityConstellation = SCNAction.fadeOpacity(to: 1, duration: 11)
        let disappear = SCNAction.fadeIn(duration: 8)
        rocketShip.runAction(disappear)
        setUpUniverse()
        addObject(position: scenePosition, sceneView: sceneView, node: constellations, objectPath: "Models.scnassets/constellations.scn")
        constellations.runAction(fadeOpacityConstellation)
        universeNode.runAction(fadeOpacityConstellation)
        sun.runAction(fadeOpacityConstellation)
        earthParent.runAction(fadeOpacityConstellation)
        moonParent.runAction(fadeOpacityConstellation)
        setUpStarNameView()

    }
    
    
    @objc func rocketPrepareTakeOff() {
        playRocketLaunchSound()
        countDown.startStateRocket()
        view.addSubview(countDown)
        setConstraintsCoutDownViews()
        rocketShip.physicsBody!.damping = 0
        reactorParticleSystem.particleImage = UIImage(named: "spark")
        engineRocket.addParticleSystem(reactorParticleSystem)
        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(rocketTakeOff), userInfo: nil, repeats: false)
    }
    
    func disappearCountDown() {
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(removeCountDown), userInfo: nil, repeats: false)
    }
    
    func timerAppearHelpViewDraw() {
        _ = Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(appearHelpViewDraw), userInfo: nil, repeats: false)
    }
    
    @objc func appearHelpViewDraw() {
        rocketLaunchSoundPlayer?.stop()
        self.createHelpViewDraw()
        start = true
        restartButton.isHidden = true
        stateTutorial = .moveToCenterScene
        updateHelpView()
    }
    
    @objc func removeCountDown() {
        UIView.animate(withDuration: 0.4, animations: {
            self.countDown.alpha = 0
        }) { _ in
            self.countDown.removeFromSuperview()
        }
    }
    
    
    func createNodeInfo(position: SCNVector3, nameOfNode: String, nameConstellation: String) {
        let plane = SCNPlane(width: 0.16, height: 0.043)
        let imageMaterial = SCNMaterial()
        infoView.alpha = 1
        infoView.setText(text: nameConstellation)
        imageMaterial.diffuse.contents =  infoView.asImage()
        plane.materials = [imageMaterial]
        let node = SCNNode()
        plane.cornerRadius = 30
        node.geometry = plane
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = [.X, .Y, .Z]
        node.constraints = [billboardConstraint]
        node.worldPosition = position
        node.name = nameOfNode
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func image(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
    
    
    private func setupInfoView() {
        view.addSubview(infoView)
    }
    
    
    func didFinishOnboarding() {

    }
    
    func setConstraintsCoutDownViews() {
        countDown.translatesAutoresizingMaskIntoConstraints = false
        countDown.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        countDown.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    @objc func restart() {
        self.sceneView.scene.rootNode.enumerateChildNodes {(node,_) in
            node.removeFromParentNode()
        }
        isTrackerNodePositioned = false
        setupScene()
        restartPlaneDetection()
        setUpHelpViewTracking()
        setupFocusSquare()
        runARSession()
        sceneView.session.run(configuration)
        self.sceneView.scene.rootNode.addChildNode(self.trackerNode!)
        scenePosition = SCNVector3(0, 0, 0)
        setUpRestartbutton()
    }
    
    
    func setUpRestartbutton() {
        restartButton.isHidden = true
        view.addSubview(restartButton)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        restartButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        restartButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        restartButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func didTapClose() {
        shouldPresentARDetailView = true
        helpViewDraw.alpha = 1
        if numOfConstellationDid == 4 {
            stateTutorial = .constellationFinished
        }else{
            stateTutorial = .pointViewStartStar
        }
    }
    
    
    func playBackgroundSound() {
        let path = Bundle.main.path(forResource: "SoundTrack.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            soundTrackPlayer?.numberOfLoops = -1
            soundTrackPlayer?.volume = 0.2
            soundTrackPlayer = try AVAudioPlayer(contentsOf: url)
            soundTrackPlayer?.play()
        } catch {
            print("could not load the file")
        }
    }
    
    func playRocketLaunchSound() {
        let path = Bundle.main.path(forResource: "RocketLaunchSound.m4v", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            rocketLaunchSoundPlayer?.volume = 0.01
            rocketLaunchSoundPlayer = try AVAudioPlayer(contentsOf: url)
            rocketLaunchSoundPlayer?.play()
        } catch {
            print("could not load the file")
        }
    }
    
}

protocol ARDetailViewDelegate {
    func didTapClose()
}

protocol AlienViewDelegate {
    func didStartDetecting()
}

