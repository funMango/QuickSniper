//
//  HotCornerPosition.swift
//  QuickSniper
//
//  Created by 이민호 on 6/12/25.
//

import Foundation
import AppKit

enum HotCornerPosition: String, CaseIterable, Codable {
    case bottomLeft = "bottomLeft"
    case bottomRight = "bottomRight"
    case off = "hotcornerOff"
    
    var displayName: String {
        switch self {
        case .bottomLeft:
            return String(localized: "bottomLeft")
        case .bottomRight:
            return String(localized: "bottomRight")
        case .off:
            return String(localized: "hotcornerOff")
        }
    }
    
    /// 감지 영역 계산 (하단만)
    func detectionRect(for screen: NSScreen) -> NSRect {
        let fullFrame = screen.frame
        let width: CGFloat = 20
        let height: CGFloat = 40
        
        switch self {
        case .bottomLeft:
            return NSRect(
                x: fullFrame.minX,
                y: fullFrame.minY,
                width: width,
                height: height
            )
        case .bottomRight:
            return NSRect(
                x: fullFrame.maxX - width,
                y: fullFrame.minY,
                width: width,
                height: height
            )
        case .off:
            return NSRect.zero
        }
    }
    
    /// 위젯 시작 위치 계산
    func widgetStartRect(for screen: NSScreen) -> NSRect {
        let fullFrame = screen.frame
        let width: CGFloat = 60
        let height: CGFloat = 50
        
        switch self {
        case .bottomLeft:
            return NSRect(
                x: fullFrame.minX - 40,
                y: fullFrame.minY - 30,
                width: width,
                height: height
            )
        case .bottomRight:
            return NSRect(
                x: fullFrame.maxX + 10,
                y: fullFrame.minY - 30,
                width: width,
                height: height
            )
        case .off:
            return NSRect.zero
        }
    }
    
    /// 위젯 최종 위치 계산
    func widgetEndRect(for screen: NSScreen) -> NSRect {
        let fullFrame = screen.frame
        let width: CGFloat = 60
        let height: CGFloat = 50
        
        switch self {
        case .bottomLeft:
            return NSRect(
                x: fullFrame.minX - 20,
                y: fullFrame.minY - 10,
                width: width,
                height: height
            )
        case .bottomRight:
            return NSRect(
                x: fullFrame.maxX - 40,
                y: fullFrame.minY - 10,
                width: width,
                height: height
            )
        case .off:
            return NSRect.zero
        }
    }
}
