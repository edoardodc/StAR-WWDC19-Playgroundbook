import UIKit

class StarNameView: UIVisualEffectView {
    
    var customConstraints: [NSLayoutConstraint] = []

    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()
    
    override init(effect: UIVisualEffect?) {
        let blurEffect = UIBlurEffect(style: .dark)
        super.init(effect: blurEffect)
        if textLabel.text == "" {
            self.alpha = 0
        }
        layer.cornerRadius = 14
        self.clipsToBounds = true
        contentView.addSubview(textLabel)
        textLabel.fillToSuperview(constant: 13)
    }
    
    func setUpText(text: String) {
        textLabel.text = text
    }
    
    public func viewBlink() {
        self.blink()
    }
    
    public func smallViewBounce() {
        self.bounce(damping: 0.4, option: .curveEaseInOut)
    }
    
    public func viewBounce() {
        self.bounce(damping: 0.6, option: .curveEaseInOut)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
