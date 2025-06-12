//
//  HotCornerViewDelegate.swift
//  QuickSniper
//
//  Created by 이민호 on 6/12/25.
//

import Foundation

protocol HotCornerViewDelegate: AnyObject {
    func hotCornerViewDidClick()
    func hotCornerViewMouseEntered()
    func hotCornerViewMouseExited()
}
