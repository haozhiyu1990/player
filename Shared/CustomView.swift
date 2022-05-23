//
//  CustomView.swift
//  player
//
//  Created by 7080 on 2022/5/19.
//

import SwiftUI

struct CustomView {
    let index: Int
    let itemH: CGFloat
    @Binding var clearnUp: Bool
    @Binding var mark: Bool
    @Binding var warState: WarSituation
    let action: (Int) -> ()
}

protocol CustomViewDelegate {
    func cleanUpAction(isClean: Bool)
    func markAction(isMark: Bool)
}

class Coordinator: CustomViewDelegate {
    var parent: CustomView
    
    init(_ parent: CustomView) {
        self.parent = parent
    }
    
    func cleanUpAction(isClean: Bool) {
        parent.clearnUp = isClean
    }
    
    func markAction(isMark: Bool) {
        parent.mark = isMark
    }
}

#if os(iOS) || os(tvOS)
extension CustomView: UIViewRepresentable {
    func updateUIView(_ nsView: CustomUIView, context: Context) {
        nsView.clearnUp = clearnUp
        nsView.mark = mark
        nsView.warState = warState
    }
    
    func makeUIView(context: Context) -> CustomUIView {
        let view = CustomUIView()
        view.index = index
        view.itemH = itemH
        view.clearnUp = clearnUp
        view.mark = mark
        view.delegate = context.coordinator
        view.warState = warState
        view.action = action
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class CustomUIView: UIView {
    var index: Int = 0
    var itemH: CGFloat = 0
    var clearnUp: Bool = false
    var mark: Bool = false
    var delegate: CustomViewDelegate?
    var warState: WarSituation?
    var action: ((Int) -> ())?
    
    init() {
        super.init(frame: .zero)
        let clean = UITapGestureRecognizer(target: self, action: #selector(cleanAction))
        let mark = UITapGestureRecognizer(target: self, action: #selector(markAction))
        clean.numberOfTapsRequired = 2
        mark.require(toFail: clean)
        addGestureRecognizer(clean)
        addGestureRecognizer(mark)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cleanAction() {
        if !clearnUp, !mark, warState == .waring {
            clearnUp = !clearnUp
            delegate?.cleanUpAction(isClean: clearnUp)
            action?(index)
        }
    }
    
    @objc func markAction() {
        if !clearnUp, warState == .waring {
            mark = !mark
            delegate?.markAction(isMark: mark)
            action?(index)
        }
    }
}
#else
extension CustomView: NSViewRepresentable {
    func updateNSView(_ nsView: CustomNSView, context: Context) {
        nsView.clearnUp = clearnUp
        nsView.mark = mark
        nsView.warState = warState
    }
    
    func makeNSView(context: Context) -> CustomNSView {
        let view = CustomNSView()
        view.index = index
        view.itemH = itemH
        view.clearnUp = clearnUp
        view.mark = mark
        view.delegate = context.coordinator
        view.warState = warState
        view.action = action
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class CustomNSView: NSView {
    var index: Int = 0
    var itemH: CGFloat = 0
    var clearnUp: Bool = false
    var mark: Bool = false
    var delegate: CustomViewDelegate?
    var warState: WarSituation?
    var action: ((Int) -> ())?
    
    override func mouseUp(with event: NSEvent) {
        if event.type == .leftMouseUp {
            let even_point = event.locationInWindow
            let poi = convert(even_point, from: nil)
            if poi.x >= 0, poi.x <= itemH, poi.y >= 0, poi.y <= itemH {
                if !clearnUp, !mark, warState == .waring {
                    clearnUp = !clearnUp
                    delegate?.cleanUpAction(isClean: clearnUp)
                    action?(index)
                }
            }
        }
    }
    
    override func rightMouseUp(with event: NSEvent) {
        if event.type == .rightMouseUp {
            let even_point = event.locationInWindow
            let poi = convert(even_point, from: nil)
            if poi.x >= 0, poi.x <= itemH, poi.y >= 0, poi.y <= itemH {
                if !clearnUp, warState == .waring {
                    mark = !mark
                    delegate?.markAction(isMark: mark)
                    action?(index)
                }
            }
        }
    }
}
#endif
