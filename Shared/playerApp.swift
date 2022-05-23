//
//  playerApp.swift
//  Shared
//
//  Created by 7080 on 2022/4/2.
//

import SwiftUI

@main
struct playerApp: App {
#if os(iOS) || os(tvOS)

#else
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
#endif
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
