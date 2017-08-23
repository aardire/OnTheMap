//
//  CustomButton.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/23/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 6 : 0
    }
}
