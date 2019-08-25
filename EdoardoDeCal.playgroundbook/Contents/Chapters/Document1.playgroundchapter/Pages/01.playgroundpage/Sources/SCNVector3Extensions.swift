import Foundation
import SceneKit

extension SCNVector3
{
    
    mutating func negated() -> SCNVector3 {
        self = negate()
        return self
    }
    
    
    mutating func normalize() -> SCNVector3 {
        self = normalized()
        return self
    }
    
    func negate() -> SCNVector3 {
        return self * -1
    }
    
    func dot(vector: SCNVector3) -> Float {
        return x * vector.x + y * vector.y + z * vector.z
    }
    
    func distance(vector: SCNVector3) -> Float {
        return (self - vector).length()
    }
    
    
    func cross(vector: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(y * vector.z - z * vector.y, z * vector.x - x * vector.z, x * vector.y - y * vector.x)
    }
}


func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}


func *= (left: inout  SCNVector3, right: SCNVector3) {
    left = left * right
}


func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}


func /= (left: inout  SCNVector3, right: SCNVector3) {
    left = left / right
}


func SCNVector3Negate(vector: SCNVector3) -> SCNVector3 {
    return vector * -1
}


func SCNVector3Length(_ vector: SCNVector3) -> Float
{
    return sqrtf(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z)
}


func SCNVector3Distance(vectorStart: SCNVector3, vectorEnd: SCNVector3) -> Float {
    return SCNVector3Length(vectorEnd - vectorStart)
}


func SCNVector3Normalize(vector: SCNVector3) -> SCNVector3 {
    return vector / SCNVector3Length(vector)
}

func SCNVector3DotProduct(_ left: SCNVector3, right: SCNVector3) -> Float {
    return left.x * right.x + left.y * right.y + left.z * right.z
}


func SCNVector3CrossProduct(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.y * right.z - left.z * right.y, left.z * right.x - left.x * right.z, left.x * right.y - left.y * right.x)
}

func SCNVector3Lerp(vectorStart: SCNVector3, vectorEnd: SCNVector3, t: Float) -> SCNVector3 {
    return SCNVector3Make(vectorStart.x + ((vectorEnd.x - vectorStart.x) * t), vectorStart.y + ((vectorEnd.y - vectorStart.y) * t), vectorStart.z + ((vectorEnd.z - vectorStart.z) * t))
}

func SCNVector3Project(vectorToProject: SCNVector3, projectionVector: SCNVector3) -> SCNVector3 {
    let scale: Float = SCNVector3DotProduct(projectionVector, right: vectorToProject) / SCNVector3DotProduct(projectionVector, right: projectionVector)
    let v: SCNVector3 = projectionVector * scale
    return v
}

