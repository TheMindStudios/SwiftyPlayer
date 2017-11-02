
//
//  VideoPlayerSlider.swift
//  SwiftyPlayer_Example
//
//  Created by Sergey Degtyar on 11/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

final class VideoPlayerSlider: UISlider {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setThumbImage(UIImage(named: "playerSliderThumb"), for: .normal)
        setThumbImage(UIImage(named: "playerSliderThumb"), for: .highlighted)
        setThumbImage(UIImage(named: "playerSliderThumb"), for: .selected)
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        var rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        
        rect = rect.offsetBy(dx: -1, dy: 2)
        
        return rect
    }
}
