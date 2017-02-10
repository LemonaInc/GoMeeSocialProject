//
//  JSLayer.swift
//  JSMaterialKit 
//
//  Created by Jaxon Stevens on 04/20/15.
//  Copyright (c) 2016 Jaxon Stevens. All rights reserved.
//

import UIKit
import QuartzCore

enum JSTimingFunction {
    case linear
    case easeIn
    case easeOut
    case custom(Float, Float, Float, Float)
    
    var function : CAMediaTimingFunction {
        switch self {
        case .linear:
            return CAMediaTimingFunction(name: "linear")
        case .easeIn:
            return CAMediaTimingFunction(name: "easeIn")
        case .easeOut:
            return CAMediaTimingFunction(name: "easeOut")
        case .custom(let cpx1, let cpy1, let cpx2, let cpy2):
            return CAMediaTimingFunction(controlPoints: cpx1, cpy1, cpx2, cpy2)
        }
    }
}

enum JSRippleLocation {
    case center
    case left
    case right
    case tapLocation
}

class JSLayer {
    fileprivate var superLayer: CALayer!
    fileprivate let circleLayer = CALayer()
    fileprivate let backgroundLayer = CALayer()
    fileprivate let maskLayer = CAShapeLayer()
    var rippleLocation: JSRippleLocation = .tapLocation {
        didSet {
            var origin: CGPoint?
            switch rippleLocation {
            case .center:
                origin = CGPoint(x: superLayer.bounds.width/2, y: superLayer.bounds.height/2)
            case .left:
                origin = CGPoint(x: superLayer.bounds.width * 0.25, y: superLayer.bounds.height/2)
            case .right:
                origin = CGPoint(x: superLayer.bounds.width * 0.75, y: superLayer.bounds.height/2)
            default:
                origin = nil
            }
            if let originPoint = origin {
                setCircleLayerLocationAt(originPoint)
            }
        }
    }
    
    var circleGrowRatioMax: Float = 0.9 {
        didSet {
            if circleGrowRatioMax > 0 {
                let superLayerWidth = superLayer.bounds.width
                let superLayerHeight = superLayer.bounds.height
                let circleSize = CGFloat(max(superLayerWidth, superLayerHeight)) * CGFloat(circleGrowRatioMax)
                let circleCornerRadius = circleSize/2
                
                circleLayer.cornerRadius = circleCornerRadius
                setCircleLayerLocationAt(CGPoint(x: superLayerWidth/2, y: superLayerHeight/2))
            }
        }
    }
    
    init(superLayer: CALayer) {
        self.superLayer = superLayer
        
        let superLayerWidth = superLayer.bounds.width
        let superLayerHeight = superLayer.bounds.height
        
        // background layer
        backgroundLayer.frame = superLayer.bounds
        backgroundLayer.opacity = 0.0
        superLayer.addSublayer(backgroundLayer)
        
        // circlelayer
        let circleSize = CGFloat(max(superLayerWidth, superLayerHeight)) * CGFloat(circleGrowRatioMax)
        let circleCornerRadius = circleSize/2
       
        circleLayer.opacity = 0.0
        circleLayer.cornerRadius = circleCornerRadius
        setCircleLayerLocationAt(CGPoint(x: superLayerWidth/2, y: superLayerHeight/2))
        backgroundLayer.addSublayer(circleLayer)
        
        // mask layer
        setMaskLayerCornerRadius(superLayer.cornerRadius)
        backgroundLayer.mask = maskLayer
    }
    
    func superLayerDidResize() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        backgroundLayer.frame = superLayer.bounds
        setMaskLayerCornerRadius(superLayer.cornerRadius)
        CATransaction.commit()
        setCircleLayerLocationAt(CGPoint(x: superLayer.bounds.width/2, y: superLayer.bounds.height/2))
    }
    
    func enableOnlyCircleLayer() {
        backgroundLayer.removeFromSuperlayer()
        superLayer.addSublayer(circleLayer)
    }
    
    func setBackgroundLayerColor(_ color: UIColor) {
        backgroundLayer.backgroundColor = color.cgColor
    }
    
    func setCircleLayerColor(_ color: UIColor) {
        circleLayer.backgroundColor = color.cgColor
    }
    
    func didChangeTapLocation(_ location: CGPoint) {
        if rippleLocation == .tapLocation {
            self.setCircleLayerLocationAt(location)
        }
    }
    
    func setMaskLayerCornerRadius(_ cornerRadius: CGFloat) {
        maskLayer.path = UIBezierPath(roundedRect: backgroundLayer.bounds, cornerRadius: cornerRadius).cgPath
    }
   
    func enableMask(_ enable: Bool = true) {
        backgroundLayer.mask = enable ? maskLayer : nil
    }
    
    func setBackgroundLayerCornerRadius(_ cornerRadius: CGFloat) {
        backgroundLayer.cornerRadius = cornerRadius
    }
    
    fileprivate func setCircleLayerLocationAt(_ center: CGPoint) {
        let bounds = superLayer.bounds
        let width = bounds.width
        let height = bounds.height
        let subSize = CGFloat(max(width, height)) * CGFloat(circleGrowRatioMax)
        let subX = center.x - subSize/2
        let subY = center.y - subSize/2
        
        // disable animation when changing layer frame
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circleLayer.frame = CGRect(x: subX, y: subY, width: subSize, height: subSize)
        CATransaction.commit()
    }
    
    // MARK - Animation
    func animateScaleForCircleLayer(_ fromScale: Float, toScale: Float, timingFunction: JSTimingFunction, duration: CFTimeInterval) {
        let circleLayerAnim = CABasicAnimation(keyPath: "transform.scale")
        circleLayerAnim.fromValue = fromScale
        circleLayerAnim.toValue = toScale
        
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 1.0
        opacityAnim.toValue = 0.0
        
        let groupAnim = CAAnimationGroup()
        groupAnim.duration = duration
        groupAnim.timingFunction = timingFunction.function
        groupAnim.isRemovedOnCompletion = false
        groupAnim.fillMode = kCAFillModeForwards
        
        groupAnim.animations = [circleLayerAnim, opacityAnim]
    
        circleLayer.add(groupAnim, forKey: nil)
    }
    
    func animateAlphaForBackgroundLayer(_ timingFunction: JSTimingFunction, duration: CFTimeInterval) {
        let backgroundLayerAnim = CABasicAnimation(keyPath: "opacity")
        backgroundLayerAnim.fromValue = 1.0
        backgroundLayerAnim.toValue = 0.0
        backgroundLayerAnim.duration = duration
        backgroundLayerAnim.timingFunction = timingFunction.function
        backgroundLayer.add(backgroundLayerAnim, forKey: nil)
    }
    
    func animateSuperLayerShadow(_ fromRadius: CGFloat, toRadius: CGFloat, fromOpacity: Float, toOpacity: Float, timingFunction: JSTimingFunction, duration: CFTimeInterval) {
        animateShadowForLayer(superLayer, fromRadius: fromRadius, toRadius: toRadius, fromOpacity: fromOpacity, toOpacity: toOpacity, timingFunction: timingFunction, duration: duration)
    }
    
    func animateMaskLayerShadow() {
        
    }
    
    fileprivate func animateShadowForLayer(_ layer: CALayer, fromRadius: CGFloat, toRadius: CGFloat, fromOpacity: Float, toOpacity: Float, timingFunction: JSTimingFunction, duration: CFTimeInterval) {
        let radiusAnimation = CABasicAnimation(keyPath: "shadowRadius")
        radiusAnimation.fromValue = fromRadius
        radiusAnimation.toValue = toRadius
        
        let opacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        opacityAnimation.fromValue = fromOpacity
        opacityAnimation.toValue = toOpacity
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = duration
        groupAnimation.timingFunction = timingFunction.function
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.animations = [radiusAnimation, opacityAnimation]
        
        layer.add(groupAnimation, forKey: nil)
    }
}

