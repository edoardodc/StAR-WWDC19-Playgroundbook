import Foundation
import ARKit

extension ViewController {
    
    func createPhysicsBody(node: SCNNode, radius: Float, categoryBitMask: Int, contactTestBitMask: Int) {
        let sphereBody = SCNPhysicsShape(geometry: SCNSphere(radius: CGFloat(radius)), options: nil)
        let physicsBody = SCNPhysicsBody(type: .static, shape: sphereBody)
        node.physicsBody = physicsBody
        node.physicsBody?.categoryBitMask = categoryBitMask
        node.physicsBody?.contactTestBitMask = contactTestBitMask
    }
    
    func clearNodeColor() {
        for node in nodes {
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
            node.geometry?.firstMaterial?.emission.contents = UIColor.yellow
        }
    }
    
    func restartSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    
    func updateLine() -> Void {
        let startPos = sceneView.worldPositionFromScreenPosition(self.view.center, objectPos: nil)
        if startPos.position != nil {
            let camera = self.sceneView.session.currentFrame?.camera
            
            _ = SCNVector3.positionFromTransform(camera!.transform)
            guard let currentLine = line else {
                return
            }
            _ = currentLine.updatePosition(camera: self.sceneView.session.currentFrame?.camera)
        }
    }
}



extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}

@objc extension ViewController {
    func placeAction(startPos: SCNVector3) {
        if let l = line {
            lines.append(l)
            line = nil
            print("Line added in list")
        } else  {
            line = LineNode(startPos: startPos, sceneV: sceneView)
            print("Crate a new line")
        }
    }
}
