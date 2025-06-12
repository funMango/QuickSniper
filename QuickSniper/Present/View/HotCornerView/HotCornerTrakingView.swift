//
//  HotCornerTrakingView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/12/25.
//

import Foundation
import AppKit

class HotCornerTrackingView: NSView {
    weak var delegate: HotCornerViewDelegate?
    
    override func mouseEntered(with event: NSEvent) {
        delegate?.hotCornerViewMouseEntered()
    }
    
    override func mouseExited(with event: NSEvent) {
        delegate?.hotCornerViewMouseExited()
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.hotCornerViewDidClick()
    }
}
