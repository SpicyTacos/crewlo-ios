//
//  CAGradientLayer+Convenience.swift
//  Crewlo
//
//  Created by Corey Howell on 1/10/16.
//  Copyright © 2016 Crewlo. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    func mainBlueGradient() -> CAGradientLayer {
        let topColor = UIColor(red: 42/255.0, green: 169/255.0, blue: 224/255.0, alpha: 1);
        let bottomColor = UIColor(red: 70/255.0, green: 166/255.0, blue: 175/255.0, alpha: 1);
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor];
        let gradientLocations: [Float] = [0.0, 1.0];
        let gradientLayer: CAGradientLayer = CAGradientLayer();
        gradientLayer.colors = gradientColors;
        gradientLayer.locations = gradientLocations;
        
        return gradientLayer;
    }
}
