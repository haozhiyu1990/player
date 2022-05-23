//
//  AppDelegate.swift
//  player
//
//  Created by 7080 on 2022/5/21.
//

import Foundation

#if os(iOS) || os(tvOS)
                    
#else
import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillBecomeActive(_ notification: Notification) {
        let mainMenu = NSApp.mainMenu
        mainMenu?.removeAllItems()
        
        let itemRoot = NSMenuItem(title: "root", action: #selector(clickMenu), keyEquivalent: "")
        let rootMenu = NSMenu(title: "rootMenu")
        mainMenu?.setSubmenu(rootMenu, for: itemRoot)
        mainMenu?.insertItem(itemRoot, at: 0)
        
        let item1 = NSMenuItem(title: "关于\(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")", action: #selector(clickMenu), keyEquivalent: "")
        item1.target = self;
        let item2 = NSMenuItem(title: "退出\(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")", action: #selector(clickMenu), keyEquivalent: "q")
        item2.target = self;
        rootMenu.addItem(item1)
        rootMenu.addItem(.separator())
        rootMenu.addItem(item2)
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        let mainMenu = NSApp.mainMenu
        mainMenu?.removeAllItems()
        
        let itemRoot = NSMenuItem(title: "root", action: #selector(clickMenu), keyEquivalent: "")
        let rootMenu = NSMenu(title: "rootMenu")
        mainMenu?.setSubmenu(rootMenu, for: itemRoot)
        mainMenu?.insertItem(itemRoot, at: 0)
        
        let item1 = NSMenuItem(title: "关于\(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")", action: #selector(clickMenu), keyEquivalent: "")
        item1.target = self;
        let item2 = NSMenuItem(title: "退出\(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")", action: #selector(clickMenu), keyEquivalent: "q")
        item2.target = self;
        rootMenu.addItem(item1)
        rootMenu.addItem(.separator())
        rootMenu.addItem(item2)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
    @objc func clickMenu(menuItem: NSMenuItem) {
        if menuItem.title.contains("退出") {
            exit(0)
        } else {
            print(Bundle.main.infoDictionary!)
            print(Bundle.main.infoDictionary!["CFBundleIconFile"]!)
            let panel = AboutThisAppPanel()
            panel.makeKeyAndOrderFront(nil)
        }
    }
}

public final class AboutThisAppPanel: NSPanel {

    public let aboutViewController: NSViewController

    public init() {
        aboutViewController = AboutThisAppViewController()

        super.init(contentRect: .zero, styleMask: [.titled, .closable], backing: .buffered, defer: false)

        contentViewController = aboutViewController
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        becomesKeyOnlyIfNeeded = false

        let screenFrame = NSScreen.main!.frame
        let leftPoint = NSPoint(x: screenFrame.midX - 200, y: screenFrame.midY + 200)
        setFrameTopLeftPoint(leftPoint)
    }
}

public final class AboutThisAppViewController: NSViewController {
    public override func loadView() {
        view = NSHostingView(rootView: AboutView())
    }
}

#endif

