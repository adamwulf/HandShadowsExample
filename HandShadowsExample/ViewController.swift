//
//  ViewController.swift
//  HandShadowsExample
//
//  Created by Adam Wulf on 1/20/24.
//

import UIKit
import HandShadows

class ViewController: UIViewController {
    var shadowView: HandShadowView = HandShadowView(forHand: .leftHand)

    // index finger and thumb
    let pinchGesture = UIPinchGestureRecognizer()
    @IBOutlet var pinchGestureSwitch: UISwitch!

    // index and middle fingers
    let panGesture = UIPanGestureRecognizer()
    @IBOutlet var panGestureSwitch: UISwitch!

    // index finger
    let indexGesture = UIPanGestureRecognizer()
    @IBOutlet var indexGestureSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.isUserInteractionEnabled = true
        view.addSubview(shadowView)

        pinchGesture.addTarget(self, action: #selector(pinch(_:)))
        view.addGestureRecognizer(pinchGesture)

        pinchGestureSwitch.isOn = true

        panGesture.addTarget(self, action: #selector(pan(_:)))
        panGesture.minimumNumberOfTouches = 2
        view.addGestureRecognizer(panGesture)
        view.addSubview(panGestureSwitch)

        indexGesture.addTarget(self, action: #selector(finger(_:)))
        indexGesture.maximumNumberOfTouches = 1
        view.addGestureRecognizer(indexGesture)

        pinchGestureSwitch.isOn = true
        panGestureSwitch.isOn = false
        indexGestureSwitch.isOn = false

        toggleGesture(nil)
    }

    @IBAction func toggleGesture(_ aSwitch: UISwitch?) {
        pinchGesture.isEnabled = pinchGestureSwitch.isOn
        panGesture.isEnabled = panGestureSwitch.isOn
        indexGesture.isEnabled = indexGestureSwitch.isOn
    }

    @objc func pinch(_ panGesture: UIPinchGestureRecognizer) {
        if panGesture.numberOfTouches >= 2 {
            let touch1 = panGesture.location(ofTouch: 0, in: shadowView)
            let touch2 = panGesture.location(ofTouch: 1, in: shadowView)

            if panGesture.state == .began {
                shadowView.startPinch(with: touch1, and: touch2)
            } else if panGesture.state == .changed {
                shadowView.continuePinch(with: touch1, and: touch2)
            }
        }
        if panGesture.state == .ended || panGesture.state == .cancelled {
            shadowView.endPinch()
        }
    }

    @objc func pan(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.numberOfTouches >= 2 {
            let touch1 = panGesture.location(ofTouch: 0, in: shadowView)
            let touch2 = panGesture.location(ofTouch: 1, in: shadowView)

            if panGesture.state == .began {
                shadowView.startTwoFingerPan(with: touch1, and: touch2)
            } else if panGesture.state == .changed {
                shadowView.continueTwoFingerPan(with: touch1, and: touch2)
            }
        }
        if panGesture.state == .ended || panGesture.state == .cancelled {
            shadowView.endTwoFingerPan()
        }
    }

    @objc func finger(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.numberOfTouches == 1 {
            let point = panGesture.location(ofTouch: 0, in: shadowView)

            if panGesture.state == .began {
                shadowView.startPointing(at: point)
            } else if panGesture.state == .changed {
                shadowView.continuePointing(at: point)
            }
        }
        if panGesture.state == .failed || panGesture.state == .ended || panGesture.state == .cancelled {
            shadowView.endPointing()
        }
    }
}
