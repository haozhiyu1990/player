//
//  CustomFormatStyle.swift
//  player
//
//  Created by 7080 on 2022/5/23.
//

import Foundation

struct CustomFormatStyle: ParseableFormatStyle {
    var parseStrategy: CustomParseStrategy {
        CustomParseStrategy()
    }
    
    func format(_ value: Int) -> String {
        "\(value)"
    }
}

struct CustomParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> Int {
        if let num = Int(value) {
            if num <= 1 {
                return 1
            } else if num >= 150 {
                return 150
            } else {
                return num
            }
        }
        return 50
    }
}

extension FormatStyle where Self == CustomFormatStyle {
    static var boom: CustomFormatStyle {
        CustomFormatStyle()
    }
}
