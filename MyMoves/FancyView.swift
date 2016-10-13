//
//  FancyView.swift
//  MyMoves
//
//  Created by Travis Whitten on 10/13/16.
//  Copyright © 2016 Travis Whitten. All rights reserved.
//

import UIKit

class FancyView: UIView {

    override func awakeFromNib() {
    
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
    }

}
