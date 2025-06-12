//
//  HotCornerView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/12/25.
//

import SwiftUI
import Cocoa

class HotCornerWidgetView: NSView {
    private let iconImageView = NSImageView()
    private let backgroundView = NSView()
    
    // 🎯 Delegate 패턴!
    weak var delegate: HotCornerViewDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        // 🎨 배경 뷰 - 사각형 모양, 그림자효과, 배경색상
        backgroundView.wantsLayer = true
        backgroundView.layer?.cornerRadius = 12
        
        let isDarkMode = NSApp.effectiveAppearance.name == .darkAqua
        let backgroundColor = isDarkMode ? NSColor.gray : NSColor.white
        backgroundView.layer?.backgroundColor = backgroundColor.withAlphaComponent(0.8).cgColor
        
        // 그림자 효과
        backgroundView.layer?.shadowColor = NSColor.black.cgColor
        backgroundView.layer?.shadowOpacity = isDarkMode ? 0.3 : 0.2
        backgroundView.layer?.shadowOffset = CGSize(width: 0, height: -2)
        backgroundView.layer?.shadowRadius = 4
        
        // 🎯 아이콘 설정
        let isDark = NSApp.effectiveAppearance.name == .darkAqua
        iconImageView.contentTintColor = isDark ? .white : .black
        
        addSubview(backgroundView)
        backgroundView.addSubview(iconImageView)
    }
    
    // 🎯 마우스 이벤트를 Delegate로 전달!
    override func mouseDown(with event: NSEvent) {
        delegate?.hotCornerViewDidClick()
    }
    
    override func mouseEntered(with event: NSEvent) {
        delegate?.hotCornerViewMouseEntered()
    }
    
    override func mouseExited(with event: NSEvent) {
        delegate?.hotCornerViewMouseExited()
    }
    
    // 위치에 따른 아이콘 업데이트
    func configure(for position: HotCornerPosition, containerFrame: NSRect) {
        backgroundView.frame = bounds
        iconImageView.image = getIconImage(for: position)
        iconImageView.frame = getIconPosition(for: position, widgetSize: containerFrame)
    }
    
    private func getIconImage(for position: HotCornerPosition) -> NSImage? {
        let symbolName: String
        switch position {
        case .bottomLeft:
            symbolName = "arrow.up.right.circle"
        case .bottomRight:
            symbolName = "arrow.up.left.circle"
        }
        return NSImage(systemSymbolName: symbolName, accessibilityDescription: nil)
    }
    
    private func getIconPosition(for position: HotCornerPosition, widgetSize: NSRect) -> NSRect {
        let iconSize: CGFloat = 20
        
        switch position {
        case .bottomLeft:
            return NSRect(
                x: widgetSize.width - iconSize - 8,
                y: widgetSize.height - iconSize - 8,
                width: iconSize,
                height: iconSize
            )
        case .bottomRight:
            return NSRect(
                x: 8,
                y: widgetSize.height - iconSize - 8,
                width: iconSize,
                height: iconSize
            )
        }
    }
}
