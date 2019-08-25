import Foundation
import ARKit

extension ViewController {
    
    func createEarth() {
        let duration = 8
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "EarthTexture.jpeg")
        earthSphere.materials = [material]
        earthParent.position = sun.worldPosition
        self.sceneView.scene.rootNode.addChildNode(earthParent)
        let earth = planet(geometry: earthSphere, position: SCNVector3(0.3, 0, 0.3))
        earthParent.addChildNode(earth)
        let earthParentAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 18))
        let earthAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8))
        print("Tempo: \(duration)")
        earthParent.runAction(earthParentAction)
        earth.runAction(earthAction)
        createMoon(earth)
    }
    
    func createMoon(_ earth: SCNNode) {
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "moon.jpeg")
        moonSphere.materials = [material]
        moonParent.position = sun.worldPosition
        moonParent.position = earth.position
        earth.parent?.addChildNode(moonParent)
        let moon = planet(geometry: moonSphere, position: SCNVector3(0.08, 0, 0))
        earth.addChildNode(moon)
        let moonParentAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 1.5))
        let moonAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 5))
        moonParent.runAction(moonParentAction)
        moon.runAction(moonAction)
    }
    
    
    
    func planet(geometry: SCNGeometry, position: SCNVector3) -> PlanetNode {
        let planet = PlanetNode(geometry: geometry, position: position)
        return planet
    }
}
