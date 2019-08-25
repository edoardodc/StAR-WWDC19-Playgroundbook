import Foundation
import UIKit

class CountDown: UIView {
    
    var timer1 = Timer()
    var timer2 = Timer()
    
    var seconds = 6
    var stateRocket = ["Engine running", "Full of gasoline", "Checking..."]
    var numStateRocket = 0
    
    let labelTimer: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Preparing rocket"
        label.font = UIFont(name: "HelveticaNeue-bold", size: 32)
        return label
    }()
    
    let labelLaunch: UILabel = {
        let label = UILabel()
        label.text = "Preparing for launch"
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-bold", size: 30)
        return label
    }()
    
    
    
    @objc func clock() {
        seconds -= 1
        labelLaunch.text = "Preparing for launch"
        labelLaunch.text = "Launch in:"
        labelTimer.text = String(seconds)
        labelTimer.font = UIFont(name: "HelveticaNeue-bold", size: 40)
        if seconds == -1 {
            labelLaunch.text = "Ready"
            labelTimer.bounce(damping: 0.6, option: .autoreverse)
            labelTimer.text = "Launched!"
            timer2.invalidate()
        }
    }
    
    func removeLabelTitle() {
        labelLaunch.isHidden = true
    }
    
    func startTimer() {
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clock), userInfo: nil, repeats: true)
        labelTimer.bounce(damping: 0.6, option: .repeat)
    }
    
    func startStateRocket() {
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stateRocketLabels), userInfo: nil, repeats: true)
        labelTimer.bounce(damping: 0.6, option: .repeat)
    }
    
    @objc func stateRocketLabels() {
        if numStateRocket < 3 {
            numStateRocket += 1
            labelTimer.text = stateRocket[numStateRocket-1]
        }else{
            timer1.invalidate()
            startTimer()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.FlatColor.Gray.cellBackgroundColor
        layer.cornerRadius = 15
        let labelsStackView = UIStackView(arrangedSubviews: [labelLaunch, labelTimer])
        labelsStackView.alignment = .center
        labelsStackView.spacing = 10
        labelsStackView.distribution = .fillEqually
        labelsStackView.axis = .vertical
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelsStackView)
        labelsStackView.fillToSuperview(constant: 15, includeNotch: false)
        labelsStackView.widthAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

