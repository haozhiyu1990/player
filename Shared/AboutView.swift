//
//  AboutView.swift
//  player
//
//  Created by 7080 on 2022/5/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("关于\(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")")
                .padding(.top)
            Spacer()
            Image(systemName: "hare.fill")
                .font(.largeTitle)
                .padding(.bottom)
            Text("扫雷")
                .font(.largeTitle)
            Text("这是一个测试demo，同时支持 macOS 和 iOS")
                .padding(.top)
                .font(.caption)
            Spacer()
            Text("© 2022 haoZhiyu. 保留所有权利。")
                .font(.caption)
                .padding(.bottom)
        }
        .frame(width: 400, height: 400)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
