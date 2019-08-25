import UIKit

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func blink() {
        self.alpha = 0.2
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
    
    func bounce(damping: CGFloat, option: AnimationOptions) {
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: 8,
                       options: option,
                       animations: { [weak self] in
                        self?.transform = .identity
            },
                       completion: nil)
    }
    
    
    internal func addEdgeConstrainedSubView(view: UIView) {
        addSubview(view)
        edgeConstrain(subView: view)
    }
    
    
    
    internal func edgeConstrain(subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Top
            NSLayoutConstraint(item: subView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0),
            // Bottom
            NSLayoutConstraint(item: subView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0),
            // Left
            NSLayoutConstraint(item: subView,
                               attribute: .left,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .left,
                               multiplier: 1.0,
                               constant: 0),
            // Right
            NSLayoutConstraint(item: subView,
                               attribute: .right,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .right,
                               multiplier: 1.0,
                               constant: 0)
            ])
    }
    
    public func fillToSuperview(constant: CGFloat = 0, includeNotch: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let left = leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: constant)
            let right = rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor, constant: -constant)
            let top = includeNotch ? topAnchor.constraint(equalTo: superview.topAnchor, constant: constant) : topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: constant)
            let bottom = bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -constant)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }
    
    public func centerToSuperview(verticalOffset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let centerX = centerXAnchor.constraint(equalTo: superview.centerXAnchor)
            let centerY = centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: verticalOffset)
            NSLayoutConstraint.activate([centerX, centerY])
        }
    }
}


extension UIColor {
    struct FlatColor {
        struct Gray {
            static let cellBackgroundColor = UIColor.init(red: 0.086, green: 0.090, blue: 0.094, alpha: 1)
        }
    }
}

