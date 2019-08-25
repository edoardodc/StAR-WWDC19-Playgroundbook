import Foundation
import ARKit

extension ViewController {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.updateLine()
        sceneView.scene.physicsWorld.contactDelegate = self
        cameraPosition = (sceneView.pointOfView?.position)!
        if isTrackerNodePositioned == false {
            if focusSquare?.isOpen == true {
                helpView.setUpText(text: "Looking for ground surface...")
            }else{
                helpView.setUpText(text: "Tap the screen to place")
            }
        }
        
        if stateTutorial == .pointViewStar {
            giveNodeToCheckStar(node: succNode)
        } else if stateTutorial == .pointViewStartStar {
            helpViewDraw.setUpText(text: "Find and touch a blue star")
        }else if stateTutorial == .constellationFinished {
            helpViewDraw.setUpText(text: "Congrats! you have discovered all the constellations! Thank you!")
        }
        
        trackerNode?.position = (focusSquare?.position)!
        DispatchQueue.main.async {
            self.updateFocusSquare()
            self.setUpTracker()
            self.screenCenter = self.sceneView.bounds.mid
        }
    }
    
    
    public func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else { return }
        let mat = pointOfView.transform
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        let currentPosition = pointOfView.position + (dir * 0.185)
        line?.endNode.position = currentPosition
    }
    
    func giveNodeToCheckStar(node: SCNNode) {
        if sceneView.isNode(node, insideFrustumOf: self.sceneView.pointOfView!) {
            helpViewDraw.setUpText(text: "Get closer and connect to a white star")
                helpViewDraw.viewBounce()
        }else{
                helpViewDraw.setUpText(text: "Find a white star")
                helpViewDraw.viewBounce()
        }
    }

    
}
