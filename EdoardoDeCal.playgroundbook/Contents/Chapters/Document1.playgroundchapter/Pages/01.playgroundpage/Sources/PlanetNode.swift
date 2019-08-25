import Foundation
import ARKit

class PlanetNode: SCNNode {
    
    init(geometry: SCNGeometry, position: SCNVector3) {
        super.init()
        self.geometry = geometry
        self.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        self.geometry?.firstMaterial?.shininess = 0.1
        self.geometry?.firstMaterial?.specular.intensity = 0.5
        self.position = position
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
