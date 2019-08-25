import ARKit

extension ViewController {
    
    func setUpTracker() {
        guard tracking else { return }
        let hitTest = self.sceneView.hitTest(CGPoint(x: self.view.frame.midX, y: self.view.frame.midY), types: .featurePoint)
        guard hitTest.first != nil else { return }
        if trackerNode == nil {
            let plane = SCNPlane(width: 1.5, height: 1.5)
            plane.firstMaterial?.diffuse.contents = imageTracker
            plane.firstMaterial?.isDoubleSided = true
            trackerNode = SCNNode(geometry: plane) //2
            trackerNode?.eulerAngles.x = -.pi * 0.5 //3
            
            self.sceneView.scene.rootNode.addChildNode(self.trackerNode!)
            foundSurface = true
        }
        trackingPosition = (focusSquare?.worldPosition)!
        self.trackerNode?.position = SCNVector3(x: (focusSquare?.worldPosition.x)!, y: (focusSquare?.worldPosition.y)!, z: (focusSquare?.worldPosition.z)!) //5
    }
    
    
    func addObject(position: SCNVector3, sceneView: ARSCNView, node: SCNNode, objectPath: String){
        node.position = position
        node.eulerAngles.y = (trackerNode?.eulerAngles.y)!
        node.eulerAngles.z = (trackerNode?.eulerAngles.y)!
        guard let constellationsScene = SCNScene(named: objectPath)
            else {
                print("Unable to Generate" + objectPath)
                return
        }
        let wrapperNode = SCNNode()
        for child in constellationsScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        node.addChildNode(wrapperNode)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    
    internal func setupFocusSquare() {
        focusSquare?.removeFromParentNode()
        focusSquare = FocusSquare()
        focusSquare?.isHidden = false
        sceneView.scene.rootNode.addChildNode(focusSquare!)
    }
    
    
    func worldPositionFromScreenPosition(_ position: CGPoint,
                                         objectPos: SCNVector3?,
                                         infinitePlane: Bool = false) -> (position: SCNVector3?, planeAnchor: ARPlaneAnchor?, hitAPlane: Bool) {
        let planeHitTestResults = sceneView.hitTest(position, types: .existingPlaneUsingExtent)
        if let result = planeHitTestResults.first {
            let planeHitTestPosition = SCNVector3.positionFromTransform(result.worldTransform)
            let planeAnchor = result.anchor
            return (planeHitTestPosition, planeAnchor as? ARPlaneAnchor, true)
        }
        
        var featureHitTestPosition: SCNVector3?
        var highQualityFeatureHitTestResult = false
        let highQualityfeatureHitTestResults = sceneView.hitTestWithFeatures(position, coneOpeningAngleInDegrees: 18, minDistance: 0.2, maxDistance: 2.0)
        
        if !highQualityfeatureHitTestResults.isEmpty {
            let result = highQualityfeatureHitTestResults[0]
            featureHitTestPosition = result.position
            highQualityFeatureHitTestResult = true
        }
        
        if (infinitePlane && dragOnInfinitePlanesEnabled) || !highQualityFeatureHitTestResult {
            
            let pointOnPlane = objectPos ?? SCNVector3Zero
            
            let pointOnInfinitePlane = sceneView.hitTestWithInfiniteHorizontalPlane(position, pointOnPlane)
            if pointOnInfinitePlane != nil {
                return (pointOnInfinitePlane, nil, true)
            }
        }
        
        if highQualityFeatureHitTestResult {
            return (featureHitTestPosition, nil, false)
        }
        
        let unfilteredFeatureHitTestResults = sceneView.hitTestWithFeatures(position)
        if !unfilteredFeatureHitTestResults.isEmpty {
            let result = unfilteredFeatureHitTestResults[0]
            return (result.position, nil, false)
        }
        
        return (nil, nil, false)
    }
    
    func updateFocusSquare() {
        guard let screenCenter = screenCenter else { return }
        
        let (worldPos, planeAnchor, _) = worldPositionFromScreenPosition(screenCenter, objectPos: focusSquare?.position)
        if let worldPos = worldPos {
            focusSquare?.updateFocus(for: worldPos, planeAnchor: planeAnchor, camera: sceneView.session.currentFrame?.camera)
        }
    }
    
    func restartPlaneDetection() {
        sessionConfig.planeDetection = .horizontal
        session.run(sessionConfig, options: [.resetTracking, .removeExistingAnchors])
    }
    
    
}
