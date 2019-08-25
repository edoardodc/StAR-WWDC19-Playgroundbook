import UIKit
import SceneKit.SCNNode

class ARDetailView: UIView {
    
    var node: SCNNode?
    var delegate: ARDetailViewDelegate?
    
    var customConstraints: [NSLayoutConstraint] = []
    
    @objc func closeView(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            self.delegate?.didTapClose()
        }
    }
    
    let buttonClose: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "cross")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return button
    }()
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        label.textColor = UIColor.white
        return label
    }()
    
    let labelDescription: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        return label
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.spacing = 10
        return sv
    }()
    
    
    func setImageLabels(image: UIImage, title: String, description: String) {
        imageView.image = image
        labelTitle.text = title
        labelDescription.text = description
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 20
        backgroundColor = UIColor.FlatColor.Gray.cellBackgroundColor
        setupStackView()
        setUpButton()
    }
    
    private func setupStackView() {
        let labelsStackView = UIStackView(arrangedSubviews: [labelTitle, labelDescription])
        self.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(labelsStackView)
        labelsStackView.alignment = .center
        labelsStackView.axis = .vertical
        labelsStackView.distribution = .equalSpacing
        labelsStackView.spacing = 5
        labelsStackView.translatesAutoresizingMaskIntoConstraints  = false
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.32).isActive = true
        setUpStackViewConstraints()
    }
    
    private func setUpButton() {
        self.addSubview(buttonClose)
        buttonClose.translatesAutoresizingMaskIntoConstraints = false
        buttonClose.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        buttonClose.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        buttonClose.widthAnchor.constraint(equalToConstant: 25).isActive = true
        buttonClose.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func setUpStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.fillToSuperview(constant: 40, includeNotch: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func show() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        customConstraints = [centerXAnchor.constraint(equalTo: view.centerXAnchor),
                             centerYAnchor.constraint(equalTo: view.centerYAnchor),
                             widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                             heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(customConstraints)
        UIView.animate(withDuration: 0.3,  delay: 0, options: [.curveEaseOut], animations: {
            view.layoutIfNeeded()
        })
    }
}
