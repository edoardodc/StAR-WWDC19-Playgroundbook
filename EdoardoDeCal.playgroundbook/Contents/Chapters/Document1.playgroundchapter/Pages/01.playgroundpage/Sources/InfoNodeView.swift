import Foundation
import UIKit

class InfoNodeView: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .black
        label.contentMode = .scaleAspectFit
        label.textAlignment = .center
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "disclosure-indicator")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView = UIStackView(arrangedSubviews: [label, imageView])
        self.addSubview(stackView)
        setUpCostraints()
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    func setText(text: String) {
        label.text = text
    }
    
    private func setUpCostraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
}
