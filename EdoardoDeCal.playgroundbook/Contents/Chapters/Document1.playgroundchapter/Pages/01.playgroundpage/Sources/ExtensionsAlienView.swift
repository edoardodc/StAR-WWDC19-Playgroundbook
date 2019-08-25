import Foundation
import UIKit

extension ViewController {
    func createHelpViewDraw() {
        view.addSubview(helpViewDraw)
        helpViewDraw.alpha = 1
        helpViewDraw.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 66).isActive = true
        helpViewDraw.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helpViewDraw.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func setUpHelpViewTracking() {
        view.addSubview(helpView)
        helpView.alpha = 1
        helpView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 66).isActive = true
        helpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
