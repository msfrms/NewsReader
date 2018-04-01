//
// Created by Radaev Mikhail on 31.03.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SpinnerLayer: CAShapeLayer {

    var spinColor: UIColor = .black

    override init() { super.init() }

    override init(layer: Any) { super.init(layer: layer) }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

    func show(inFrame: CGRect) {

        let radius = inFrame.size.height / 2.0;
        let center = CGPoint(x: inFrame.width / 2.0, y: inFrame.height / 2.0)
        let pi_2 = CGFloat.pi / 2.0
        let startAngle = -pi_2
        let endAngle = CGFloat.pi * 2 - pi_2

        self.frame = CGRect(origin: .zero, size: CGSize(width: inFrame.height, height: inFrame.height))
        self.path = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true).cgPath
        self.fillColor = UIColor.clear.cgColor
        self.lineWidth = 2.0;
        self.strokeEnd = 0.4;
        self.isHidden = false

    }

    func start() {
        self.strokeColor = self.spinColor.cgColor
        self.isHidden = false

        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")

        rotate.fromValue = nil
        rotate.toValue = Double.pi * 2.0
        rotate.duration = 1.0
        rotate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        rotate.repeatCount = HUGE
        rotate.fillMode = kCAFillModeForwards
        rotate.isRemovedOnCompletion = false

        self.add(rotate, forKey:rotate.keyPath)
    }

    func stop() {
        self.removeAllAnimations()
        self.isHidden = true
    }
}

class LoadingNode: ASDisplayNode {

    private let spinner = SpinnerLayer()

    func start() {
        self.isHidden = false
        self.spinner.start()
    }

    func stop() {
        self.isHidden = true
        self.spinner.stop()
    }

    override init() {
        super.init()

        let node = ASDisplayNode(layerBlock: { [weak self] () -> CALayer in
            return (self?.spinner)!
        })

        self.addSubnode(node)
    }

    override func layout() {
        super.layout()
        self.spinner.show(inFrame: self.bounds)
    }
}
