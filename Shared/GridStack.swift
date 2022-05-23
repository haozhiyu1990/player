//
//  GridStack.swift
//  player
//
//  Created by 7080 on 2022/4/27.
//

import SwiftUI

struct GridStack<Content: View>: View {
    
    let rows: Int
    let columns: Int
    let hSpacing: CGFloat = 1
    let vSpacing: CGFloat = 1
    
    @ViewBuilder let content: (Int, Int) -> Content
    
    var body: some View {
        VStack(spacing: vSpacing) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: hSpacing) {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}
