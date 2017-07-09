//
//  GradientView.swift
//  OnTheMap
//
//  Created by Petra Donka on 09.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var topColor: UIColor = UIColor.white {
        didSet {
            gradientColors[0] = topColor
        }
    }

    @IBInspectable var bottomColor: UIColor = UIColor.black {
        didSet {
            gradientColors[1] = bottomColor
        }
    }

    @IBInspectable var startPoint: CGPoint = CGPoint.init(x: 0, y: 0)
    @IBInspectable var endPoint: CGPoint = CGPoint.init(x: 1, y: 1)

    var gradientColors = [UIColor.white, UIColor.black]

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.layer.insertSublayer(getGradientLayer(), at: 0)
    }

    func getGradientLayer() -> CALayer {
        let gradientColors: [CGColor] = [self.gradientColors[0].cgColor,
                                         self.gradientColors[1].cgColor]
        let gradientLocations: [Double] = [0.0, 1.0]

        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.frame

        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint

        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]

        return gradientLayer
    }
}
