//
//  KeyEventNSView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/13/25.
//

import Foundation
import SwiftUI

struct KeyboardEventView: NSViewRepresentable {
    let onKeyEvent: (NSEvent) -> Void
    
    func makeNSView(context: Context) -> KeyEventNSView {
        let view = KeyEventNSView()
        view.onKeyEvent = onKeyEvent
        return view
    }
    
    func updateNSView(_ nsView: KeyEventNSView, context: Context) {}
}

class KeyEventNSView: NSView {
    var onKeyEvent: ((NSEvent) -> Void)?
    
    override var acceptsFirstResponder: Bool { true }
    
    override func keyDown(with event: NSEvent) {
        onKeyEvent?(event)
    }
}
