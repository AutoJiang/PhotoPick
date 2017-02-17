//
//  PhotoZoomScrollView.swift
//  GKitPhotoPick
//
//  Created by Auto Jiang on 2017/2/17.
//  Copyright © 2017年 Auto Jiang. All rights reserved.
//

import UIKit

class PhotoZoomScrollView: UIScrollView, UIScrollViewDelegate {
    
    lazy var zoomImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.isUserInteractionEnabled = true
        imageV.contentMode = .scaleAspectFit
        
        return imageV
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(zoomImageView)
        
        delegate = self
        minimumZoomScale = 1.0
        maximumZoomScale = 3.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomImageView
    }
    
    func setMaxMinZoomScalesForCurrentBounds() {
        // Reset
        maximumZoomScale = 1;
        minimumZoomScale = 1;
        zoomScale = 1;
        
        guard let image = zoomImageView.image else {
            return
        }
        zoomImageView.frame = zoomImageView.bounds
        
        let boundsSize = UIScreen.main.bounds.size;
        let imageSize = image.size;
        
        let xScale = boundsSize.width / imageSize.width;
        let yScale = boundsSize.height / imageSize.height;
        
        var minScale = [xScale, yScale].max();
        let maxScale = [xScale, yScale].min();
        
        if (xScale >= 1 && yScale >= 1) {
            minScale = [xScale, yScale].min();
        }
        
        if (xScale >= yScale * 2) {
            maximumZoomScale = 1.0;
            minimumZoomScale = maxScale!;
        }else {
            maximumZoomScale = yScale * 1.2;
            minimumZoomScale = xScale;
        }
        
        zoomScale = self.minimumZoomScale
        
        if (self.zoomScale != minScale) {
            if (yScale >= xScale) {
                isScrollEnabled = false;
            }
        }
        setNeedsLayout()
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var rect = zoomImageView.frame
        rect.origin.x = 0
        rect.origin.y = 0
        
        let width = frame.size.width
        let height = frame.size.height
        if rect.size.width < width {
            rect.origin.x = floor((width - rect.size.width) / 2.0)
        }
        if rect.size.height < height {
            rect.origin.y = floor((height - rect.size.height) / 2.0)
        }
        zoomImageView.frame = rect
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if touch.tapCount >= 2 {
            let touchPoint = touch.location(in: zoomImageView)
            zoomDoubleTapWithPoint(touchPoint: touchPoint)
        }
    }
    
    func zoomDoubleTapWithPoint(touchPoint: CGPoint) {
        if zoomScale > minimumZoomScale {
            //双击缩小
            setZoomScale(minimumZoomScale, animated: true)
        }
        else{
            //双击放大
            let width = bounds.size.width / maximumZoomScale
            let height = bounds.size.height / maximumZoomScale
            zoom(to: CGRect(x: touchPoint.x - width / 2, y: touchPoint.y - height / 2, width: width, height: height), animated: true)
        }
    }
}
