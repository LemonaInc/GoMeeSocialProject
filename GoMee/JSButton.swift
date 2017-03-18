//
//  JSButton.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

// Here is the place where we make those cool annimations. 
import UIKit

@IBDesignable
class JSButton : UIButton
{
    @IBInspectable var maskEnabled: Bool = true {
        didSet {
            jsLayer.enableMask(maskEnabled)
        }
    }
    @IBInspectable var rippleLocation: JSRippleLocation = .tapLocation {
        didSet {
            jsLayer.rippleLocation = rippleLocation
        }
    }
    @IBInspectable var circleGrowRatioMax: Float = 0.9 {
        didSet {
            jsLayer.circleGrowRatioMax = circleGrowRatioMax
        }
    }
    @IBInspectable var backgroundLayerCornerRadius: CGFloat = 0.0 {
        didSet {
            jsLayer.setBackgroundLayerCornerRadius(backgroundLayerCornerRadius)
        }
    }
    // animations
    @IBInspectable var shadowAniEnabled: Bool = true
    @IBInspectable var backgroundAniEnabled: Bool = true {
        didSet {
            if !backgroundAniEnabled {
                jsLayer.enableOnlyCircleLayer()
            }
        }
    }
    @IBInspectable var aniDuration: Float = 0.65
    @IBInspectable var circleAniTimingFunction: JSTimingFunction = .linear
    @IBInspectable var backgroundAniTimingFunction: JSTimingFunction = .linear
    @IBInspectable var shadowAniTimingFunction: JSTimingFunction = .easeOut
    
    @IBInspectable var cornerRadius: CGFloat = 2.5 {
        didSet {
            layer.cornerRadius = cornerRadius
            jsLayer.setMaskLayerCornerRadius(cornerRadius)
        }
    }
    // color
    @IBInspectable var circleLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5) {
        didSet {
            jsLayer.setCircleLayerColor(circleLayerColor)
        }
    }
    @IBInspectable var backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25) {
        didSet {
            jsLayer.setBackgroundLayerColor(backgroundLayerColor)
        }
    }
    override var bounds: CGRect {
        didSet {
            jsLayer.superLayerDidResize()
        }
    }
    
    fileprivate lazy var jsLayer: JSLayer = JSLayer(superLayer: self.layer)
    
    // MARK - initilization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupLayer()
    }
    
    // MARK - setup methods
    fileprivate func setupLayer() {
        adjustsImageWhenHighlighted = false
        self.cornerRadius = 2.5
        jsLayer.setBackgroundLayerColor(backgroundLayerColor)
        jsLayer.setCircleLayerColor(circleLayerColor)
    }
   
    // MARK - location tracking methods
     override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if rippleLocation == .tapLocation {
            jsLayer.didChangeTapLocation(touch.location(in: self))
        }
        
        // circleLayer animation
        jsLayer.animateScaleForCircleLayer(0.45, toScale: 1.0, timingFunction: circleAniTimingFunction, duration: CFTimeInterval(aniDuration))
        
        // backgroundLayer animation
        if backgroundAniEnabled {
            jsLayer.animateAlphaForBackgroundLayer(backgroundAniTimingFunction, duration: CFTimeInterval(aniDuration))
        }
        
        // shadow animation for self
        if shadowAniEnabled {
            let shadowRadius = self.layer.shadowRadius
            let shadowOpacity = self.layer.shadowOpacity
            
            //if mkType == .Flat {
            //    jsLayer.animateMaskLayerShadow()
            //} else {
                jsLayer.animateSuperLayerShadow(10, toRadius: shadowRadius, fromOpacity: 0, toOpacity: shadowOpacity, timingFunction: shadowAniTimingFunction, duration: CFTimeInterval(aniDuration))
            //}
        }
        
        return super.beginTracking(touch, with: event)
    }
}

