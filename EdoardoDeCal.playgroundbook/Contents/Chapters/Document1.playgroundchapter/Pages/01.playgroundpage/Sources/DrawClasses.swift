import UIKit
import SceneKit
import ARKit

class CylinderLine: SCNNode {
    init( parent: SCNNode, v1: SCNVector3, v2: SCNVector3, radius: CGFloat, radSegmentCount: Int, color: UIColor)
    {
        super.init()
        
        let  height = v1.distance(receiver: v2)
        position = v1
        let nodeV2 = SCNNode()
        nodeV2.position = v2
        parent.addChildNode(nodeV2)
        
        let zAlign = SCNNode()
        zAlign.eulerAngles.x = Float(CGFloat.pi / 2)
        
        let cyl = SCNCylinder(radius: radius, height: CGFloat(height))
        cyl.radialSegmentCount = radSegmentCount
        cyl.firstMaterial?.diffuse.contents = color
        
        let nodeCyl = SCNNode(geometry: cyl )
        nodeCyl.position.y = -height/2
        zAlign.addChildNode(nodeCyl)
        
        addChildNode(zAlign)
        
        constraints = [SCNLookAtConstraint(target: nodeV2)]
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private extension SCNVector3{
    func distance(receiver:SCNVector3) -> Float{
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}

class LineNode: NSObject {
    let startNode: SCNNode
    let endNode: SCNNode
    var lineNode: SCNNode?
    let sceneView: ARSCNView?
    private var recentFocusSquarePositions = [SCNVector3]()
    
    init(startPos: SCNVector3,
         sceneV: ARSCNView,
         color: (start: UIColor, end: UIColor) = (UIColor.green, UIColor.red)) {
        sceneView = sceneV
        let scale = 1/400.0
        let scaleVector = SCNVector3(scale, scale, scale)
        
        func buildSCNSphere(color: UIColor) -> SCNSphere {
            let dot = SCNSphere(radius:1)
            dot.firstMaterial?.diffuse.contents = color
            dot.firstMaterial?.lightingModel = .constant
            dot.firstMaterial?.isDoubleSided = true
            return dot
        }
        
        startNode = SCNNode(geometry: buildSCNSphere(color: color.start))
        startNode.scale = scaleVector
        startNode.position = startPos
        sceneView?.scene.rootNode.addChildNode(startNode)
        
        endNode = SCNNode(geometry: buildSCNSphere(color: color.end))
        endNode.scale = scaleVector
        
        endNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        endNode.physicsBody?.categoryBitMask = 3
        endNode.physicsBody?.contactTestBitMask = 1
        
        lineNode = nil
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func updatePosition(camera: ARCamera?) {
        let pointOfView = sceneView!.pointOfView
        let mat = pointOfView!.transform
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        let currentPosition = pointOfView!.position + (dir * 0.185)
        
        if endNode.parent == nil {
            sceneView?.scene.rootNode.addChildNode(endNode)
        }
        endNode.position = currentPosition
        lineNode?.removeFromParentNode()
        lineNode = lineBetweenNodeA(nodeA: startNode, nodeB: endNode)
        sceneView?.scene.rootNode.addChildNode(lineNode!)
    }
    
    public func sphereTouchedPosition(camera: ARCamera?, position: SCNVector3) {
        if endNode.parent == nil {
            sceneView?.scene.rootNode.addChildNode(endNode)
        }
        endNode.position = position
        lineNode?.removeFromParentNode()
        lineNode = lineBetweenNodeA(nodeA: startNode, nodeB: endNode)
        sceneView?.scene.rootNode.addChildNode(lineNode!)
    }
    
    
    func removeFromParent() -> Void {
        startNode.removeFromParentNode()
        endNode.removeFromParentNode()
        lineNode?.removeFromParentNode()
    }
    
    public func lineBetweenNodeA(nodeA: SCNNode, nodeB: SCNNode) -> SCNNode {
        return CylinderLine(parent: sceneView!.scene.rootNode,
                            v1: nodeA.position,
                            v2: nodeB.position,
                            radius: 0.002,
                            radSegmentCount: 16,
                            color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }
    
        
    private func updateTransform(for position: SCNVector3, camera: ARCamera?) -> SCNVector3 {
        recentFocusSquarePositions.append(position)
        recentFocusSquarePositions.keepLast(8)
        if let average = recentFocusSquarePositions.average {
            return average
        }
        return SCNVector3Zero
    }
    
}

