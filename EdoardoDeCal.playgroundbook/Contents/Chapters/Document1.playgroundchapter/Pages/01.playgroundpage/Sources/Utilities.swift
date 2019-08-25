import Foundation
import ARKit

extension Array where Iterator.Element == CGFloat {
    var average: CGFloat? {
        guard !isEmpty else {
            return nil
        }
        var ret = self.reduce(CGFloat(0)) { (cur, next) -> CGFloat in
            var cur = cur
            cur += next
            return cur
        }
        let fcount = CGFloat(count)
        ret /= fcount
        return ret
    }
}

extension Array where Iterator.Element == SCNVector3 {
    var average: SCNVector3? {
        guard !isEmpty else {
            return nil
        }
        var ret = self.reduce(SCNVector3Zero) { (cur, next) -> SCNVector3 in
            var cur = cur
            cur.x += next.x
            cur.y += next.y
            cur.z += next.z
            return cur
        }
        let fcount = Float(count)
        ret.x /= fcount
        ret.y /= fcount
        ret.z /= fcount
        
        return ret
    }
}

extension RangeReplaceableCollection {
    mutating func keepLast(_ elementsToKeep: Int) {
        if count > elementsToKeep {
            self.removeFirst(count - elementsToKeep)
        }
    }
}

extension SCNVector3 {
    
    init(_ vec: vector_float3) {
        self.init()
        self.x = vec.x
        self.y = vec.y
        self.z = vec.z
    }
    
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    mutating func setLength(_ length: Float) {
        self *= length
    }
    
    mutating func setMaximumLength(_ maxLength: Float) {
        if self.length() <= maxLength {
            return
        } else {
            self *= maxLength
        }
    }
    
    mutating func normalize() {
        self = self.normalized()
    }
    
    func normalized() -> SCNVector3 {
        if self.length() == 0 {
            return self
        }
        
        return self / self.length()
    }
    
    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    func friendlyString() -> String {
        return "(\(String(format: "%.2f", x)), \(String(format: "%.2f", y)), \(String(format: "%.2f", z)))"
    }
    
    func dot(_ vec: SCNVector3) -> Float {
        return (self.x * vec.x) + (self.y * vec.y) + (self.z * vec.z)
    }
    
    func cross(_ vec: SCNVector3) -> SCNVector3 {
        return SCNVector3(self.y * vec.z - self.z * vec.y, self.z * vec.x - self.x * vec.z, self.x * vec.y - self.y * vec.x)
    }
}

public let SCNVector3One: SCNVector3 = SCNVector3(1.0, 1.0, 1.0)

func SCNVector3Uniform(_ value: Float) -> SCNVector3 {
    return SCNVector3Make(value, value, value)
}

func SCNVector3Uniform(_ value: CGFloat) -> SCNVector3 {
    return SCNVector3Make(Float(value), Float(value), Float(value))
}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

func += (left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}

func -= (left: inout SCNVector3, right: SCNVector3) {
    left = left - right
}

func / (left: SCNVector3, right: Float) -> SCNVector3 {
    return SCNVector3Make(left.x / right, left.y / right, left.z / right)
}

func * (left: SCNVector3, right: Float) -> SCNVector3 {
    return SCNVector3Make(left.x * right, left.y * right, left.z * right)
}

func /= (left: inout SCNVector3, right: Float) {
    left = left / right
}

func *= (left: inout SCNVector3, right: Float) {
    left = left * right
}

extension SCNMaterial {
    
    static func material(withDiffuse diffuse: Any?, respondsToLighting: Bool = true) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = diffuse
        material.isDoubleSided = true
        if respondsToLighting {
            material.locksAmbientWithDiffuse = true
        } else {

        }
        return material
    }
}

extension CGPoint {
    
    init(_ size: CGSize) {
        self.init()
        self.x = size.width
        self.y = size.height
    }
    
    init(_ vector: SCNVector3) {
        self.init()
        self.x = CGFloat(vector.x)
        self.y = CGFloat(vector.y)
    }
    
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return (self - point).length()
    }
    
    func length() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
    
    func midpoint(_ point: CGPoint) -> CGPoint {
        return (self + point) / 2
    }
    
    func friendlyString() -> String {
        return "(\(String(format: "%.2f", x)), \(String(format: "%.2f", y)))"
    }
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

func -= (left: inout CGPoint, right: CGPoint) {
    left = left - right
}

func / (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}

func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

func /= (left: inout CGPoint, right: CGFloat) {
    left = left / right
}

func *= (left: inout CGPoint, right: CGFloat) {
    left = left * right
}

// MARK: - CGSize extensions

extension CGSize {
    
    init(_ point: CGPoint) {
        self.init()
        self.width = point.x
        self.height = point.y
    }
    
    func friendlyString() -> String {
        return "(\(String(format: "%.2f", width)), \(String(format: "%.2f", height)))"
    }
}

func + (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width + right.width, height: left.height + right.height)
}

func - (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width - right.width, height: left.height - right.height)
}

func += (left: inout CGSize, right: CGSize) {
    left = left + right
}

func -= (left: inout CGSize, right: CGSize) {
    left = left - right
}

func / (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width / right, height: left.height / right)
}

func * (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
}

func /= (left: inout CGSize, right: CGFloat) {
    left = left / right
}

func *= (left: inout CGSize, right: CGFloat) {
    left = left * right
}

extension CGRect {
    
    var mid: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

func rayIntersectionWithHorizontalPlane(rayOrigin: SCNVector3, direction: SCNVector3, planeY: Float) -> SCNVector3? {
    
    let direction = direction.normalized()
    if direction.y == 0 {
        if rayOrigin.y == planeY {

            return rayOrigin
        } else {
            return nil
        }
    }
    let dist = (planeY - rayOrigin.y) / direction.y
    if dist < 0 {
        return nil
    }
    return rayOrigin + (direction * dist)
}

extension ARSCNView {
    func worldPositionFromScreenPosition(_ position: CGPoint,
                                         objectPos: SCNVector3?,
                                         infinitePlane: Bool = false) -> (position: SCNVector3?, planeAnchor: ARPlaneAnchor?, hitAPlane: Bool) {
        
        let sceneView = self
        let planeHitTestResults = sceneView.hitTest(position, types: .existingPlaneUsingExtent)
        if let result = planeHitTestResults.first {
            
            let planeHitTestPosition = SCNVector3.positionFromTransform(result.worldTransform)
            let planeAnchor = result.anchor
            return (planeHitTestPosition, planeAnchor as? ARPlaneAnchor, true)
        }

        let highQualityFeatureHitTestResult = false
        
        _ = sceneView.hitTestWithFeatures(position, coneOpeningAngleInDegrees: 5, minDistance: 0.1, maxDistance: 3.0)
    
        if highQualityFeatureHitTestResult {
        }
        
        let unfilteredFeatureHitTestResults = sceneView.hitTestWithFeatures(position)
        if !unfilteredFeatureHitTestResults.isEmpty {
            let result = unfilteredFeatureHitTestResults[0]
            return (result.position, nil, false)
        }
        
        return (nil, nil, false)
    }
    
}


extension ARSCNView {
    
    struct HitTestRay {
        let origin: SCNVector3
        let direction: SCNVector3
    }
    
    func hitTestRayFromScreenPos(_ point: CGPoint) -> HitTestRay? {
        
        guard let frame = self.session.currentFrame else {
            return nil
        }
        
        let cameraPos = SCNVector3.positionFromTransform(frame.camera.transform)
        
        let positionVec = SCNVector3(x: Float(point.x), y: Float(point.y), z: 1.0)
        let screenPosOnFarClippingPlane = self.unprojectPoint(positionVec)
        
        let rayDirection = screenPosOnFarClippingPlane - cameraPos
        
        return HitTestRay(origin: cameraPos, direction: rayDirection)
    }
    
    func hitTestWithInfiniteHorizontalPlane(_ point: CGPoint, _ pointOnPlane: SCNVector3) -> SCNVector3? {
        
        guard let ray = hitTestRayFromScreenPos(point) else {
            return nil
        }
        
        if ray.direction.y > -0.03 {
            return nil
        }
        return rayIntersectionWithHorizontalPlane(rayOrigin: ray.origin, direction: ray.direction, planeY: pointOnPlane.y)
    }
    
    struct FeatureHitTestResult {
        let position: SCNVector3
        let distanceToRayOrigin: Float
        let featureHit: SCNVector3
        let featureDistanceToHitResult: Float
    }
    
    func hitTestWithFeatures(_ point: CGPoint, coneOpeningAngleInDegrees: Float,
                             minDistance: Float = 0,
                             maxDistance: Float = Float.greatestFiniteMagnitude,
                             maxResults: Int = 1) -> [FeatureHitTestResult] {
        
        var results = [FeatureHitTestResult]()
        
        guard let features = self.session.currentFrame?.rawFeaturePoints else {
            return results
        }
        
        guard let ray = hitTestRayFromScreenPos(point) else {
            return results
        }
        
        let maxAngleInDeg = min(coneOpeningAngleInDegrees, 360) / 2
        let maxAngle = ((maxAngleInDeg / 180) * Float.pi)
        
        let points = features.points
        
        for i in 0...points.count {
            let pointer = UnsafePointer(points)
            let feature = pointer.advanced(by: Int(i))
            let featurePos = SCNVector3(feature.pointee)
            
            let originToFeature = featurePos - ray.origin
            
            let crossProduct = originToFeature.cross(ray.direction)
            let featureDistanceFromResult = crossProduct.length()
            
            let hitTestResult = ray.origin + (ray.direction * ray.direction.dot(originToFeature))
            let hitTestResultDistance = (hitTestResult - ray.origin).length()
            
            if hitTestResultDistance < minDistance || hitTestResultDistance > maxDistance {
                continue
            }
            let originToFeatureNormalized = originToFeature.normalized()
            let angleBetweenRayAndFeature = acos(ray.direction.dot(originToFeatureNormalized))
            
            if angleBetweenRayAndFeature > maxAngle {
                continue
            }
            
            results.append(FeatureHitTestResult(position: hitTestResult,
                                                distanceToRayOrigin: hitTestResultDistance,
                                                featureHit: featurePos,
                                                featureDistanceToHitResult: featureDistanceFromResult))
        }
        results = results.sorted(by: { (first, second) -> Bool in
            return first.distanceToRayOrigin < second.distanceToRayOrigin
        })
        var cappedResults = [FeatureHitTestResult]()
        var i = 0
        while i < maxResults && i < results.count {
            cappedResults.append(results[i])
            i += 1
        }
        return cappedResults
    }
    
    func hitTestWithFeatures(_ point: CGPoint) -> [FeatureHitTestResult] {
        var results = [FeatureHitTestResult]()
        guard let ray = hitTestRayFromScreenPos(point) else {
            return results
        }
        if let result = self.hitTestFromOrigin(origin: ray.origin, direction: ray.direction) {
            results.append(result)
        }
        return results
    }
    
    func hitTestFromOrigin(origin: SCNVector3, direction: SCNVector3) -> FeatureHitTestResult? {
        guard let features = self.session.currentFrame?.rawFeaturePoints else {
            return nil
        }
        let points = features.points
        var closestFeaturePoint = origin
        var minDistance = Float.greatestFiniteMagnitude
        
        for i in 0...points.count {
            let pointer = UnsafePointer(points)
            let feature = pointer.advanced(by: Int(i))
            let featurePos = SCNVector3(feature.pointee)
            
            let originVector = origin - featurePos
            let crossProduct = originVector.cross(direction)
            let featureDistanceFromResult = crossProduct.length()
            
            if featureDistanceFromResult < minDistance {
                closestFeaturePoint = featurePos
                minDistance = featureDistanceFromResult
            }
        }
        
        let originToFeature = closestFeaturePoint - origin
        let hitTestResult = origin + (direction * direction.dot(originToFeature))
        let hitTestResultDistance = (hitTestResult - origin).length()
        
        return FeatureHitTestResult(position: hitTestResult,
                                    distanceToRayOrigin: hitTestResultDistance,
                                    featureHit: closestFeaturePoint,
                                    featureDistanceToHitResult: minDistance)
    }
}

extension SCNNode {
    
    func setUniformScale(_ scale: Float) {
        self.scale = SCNVector3Make(scale, scale, scale)
    }
    
    func renderOnTop() {
        self.renderingOrder = 2
        if let geom = self.geometry {
            for material in geom.materials {
                material.readsFromDepthBuffer = false
            }
        }
        for child in self.childNodes {
            child.renderOnTop()
        }
    }
}


