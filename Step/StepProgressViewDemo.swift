//
//  AppDelegate.swift
//  Step
//
//  Created by Yonat Sharon on 13/2/15.
//  Copyright (c) 2015 Yonat Sharon. All rights reserved.
//

import UIKit

class StepProgressViewController: UIViewController {

    var steps: StepProgressView!

    let firstSteps = ["First", "Second", "Third can be very long and include a lot of unintersting text that spans several lines.", "Last but not least"]
    let secondSteps = ["Lorem ipsum dolor sit amet", "consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam", "quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur", "Excepteur sint occaecat cupidatat non proident", "sunt in culpa qui officia deserunt mollit anim id est laborum"]
    let details = [1: "Short descriotion", 3: "Kind of long rambling explanation that no one reads in reality."]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.translatesAutoresizingMaskIntoConstraints = false

        // step progress
        steps = StepProgressView(frame: contentFrame.insetBy(dx: 0, dy: 32))
        steps.steps = firstSteps
        steps.details = details
        view.addSubview(steps)

        // current step slider
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = -1
        slider.maximumValue = Float(7)
        slider.value = -1
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        view.addSubview(slider)

        // steps switch
        let stepsLabel = UILabel(text: "Steps")
        view.addSubview(stepsLabel)
        let stepsSwitch = UISwitch(target: self, action: #selector(stepsChanged))
        view.addSubview(stepsSwitch)

        // color scheme switch
        let colorLabel = UILabel(text: "Colors")
        view.addSubview(colorLabel)
        let colorSwitch = UISwitch(target: self, action: #selector(colorsChanged))
        view.addSubview(colorSwitch)

        // sizes switch
        let sizeLabel = UILabel(text: "Sizes")
        view.addSubview(sizeLabel)
        let sizeSwitch = UISwitch(target: self, action: #selector(sizeChanged))
        view.addSubview(sizeSwitch)

        // shapes switch
        let shapeLabel = UILabel(text: "Shapes")
        view.addSubview(shapeLabel)
        let shapeSwitch = UISwitch(target: self, action: #selector(shapeChanged))
        view.addSubview(shapeSwitch)

        let bindings = [
            "slider": slider,
            "stepsLabel": stepsLabel, "stepsSwitch": stepsSwitch,
            "colorLabel": colorLabel, "colorSwitch": colorSwitch,
            "sizeLabel": sizeLabel, "sizeSwitch": sizeSwitch,
            "shapeLabel": shapeLabel, "shapeSwitch": shapeSwitch
        ]
        view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "|-[slider]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings) )
        view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:[stepsLabel]-[stepsSwitch]-(24)-[colorLabel]-[colorSwitch]-(24)-[slider]-(24)-|", options: .alignAllLeading, metrics: nil, views: bindings) )
        view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:[sizeLabel]-[sizeSwitch]-(24)-[shapeLabel]-[shapeSwitch]-(24)-[slider]", options: .alignAllTrailing, metrics: nil, views: bindings) )
    }

    @objc func sliderChanged(_ sender: UISlider) {
        steps.currentStep = Int(sender.value)
    }

    @objc func stepsChanged(_ sender: UISwitch) {
        steps.steps = sender.isOn ? secondSteps : firstSteps
        steps.details = sender.isOn ? [:] : details
    }

    @objc func colorsChanged(_ sender: UISwitch) {
        steps.pastStepColor = sender.isOn ? UIColor.black : UIColor.lightGray
        steps.pastTextColor = steps.pastStepColor
        steps.pastStepFillColor = steps.pastStepColor
        steps.currentStepColor = sender.isOn ? UIColor.red : nil
        steps.currentTextColor = steps.currentStepColor
        steps.currentDetailColor = sender.isOn ? UIColor.brown : UIColor.darkGray
        steps.futureStepColor = sender.isOn ? UIColor.gray : UIColor.lightGray
    }

    @objc func sizeChanged(_ sender: UISwitch) {
        steps.lineWidth = sender.isOn ? 3 : 1
        steps.textFont = sender.isOn ? UIFont.systemFont( ofSize: 1.5 * UIFont.buttonFontSize ) : UIFont.systemFont( ofSize: UIFont.buttonFontSize )
        steps.horizontalPadding  = sender.isOn ? 8 : 0
    }

    @objc func shapeChanged(_ sender: UISwitch) {
        steps.firstStepShape = sender.isOn ? .downTriangle : .circle
        steps.stepShape = sender.isOn ? .rhombus : .circle
        steps.lastStepShape = sender.isOn ? .triangle : .square
    }

    var contentFrame: CGRect {
        let fullFrame = view.bounds.divided(atDistance: UIApplication.shared.statusBarFrame.maxY, from: CGRectEdge.minYEdge).remainder
        return fullFrame.insetBy(dx: 16, dy: 16)
    }
}

private extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
        sizeToFit()
        translatesAutoresizingMaskIntoConstraints = false
    }
}

private extension UISwitch {
    convenience init(target: AnyObject, action: Selector) {
        self.init()
        addTarget(target, action: action, for: .valueChanged)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

@UIApplicationMain
class StepProgressViewDemo: UIResponder, UIApplicationDelegate {

    lazy var mainWindow = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        mainWindow.backgroundColor = UIColor.white
        mainWindow.rootViewController = StepProgressViewController()
        mainWindow.makeKeyAndVisible()
        return true
    }
}

