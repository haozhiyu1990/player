//
//  ContentView.swift
//  Shared
//
//  Created by 7080 on 2022/4/2.
//

import SwiftUI

enum WarSituation {
    case winner
    case loser
    case waring
    case loading
}

let boomLevelArr = [10, 20, 30, 50, 70, 90, 110, 130, 150, 180]

struct ContentView: View {
#if os(iOS) || os(tvOS)
    let itemH: CGFloat = UIScreen.main.bounds.width / 21
#else
    let itemH: CGFloat = 28
#endif
    var indexArr = [Int](0..<400)
    @State private var selectLevel = boomLevelArr[3]
    @State private var boomNum = boomLevelArr[3]
    @State private var surplusBoomNum = boomLevelArr[3]
    @State private var boomArr: [Int] = Array(repeating: 0, count: 400)
    @State private var cleanUpArr: [Bool] = Array(repeating: false, count: 400)
    @State private var markArr: [Bool] = Array(repeating: false, count: 400)
    @State private var warState: WarSituation = .waring
    @State private var loseIdx: Int = -1
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                
                VStack(spacing: 1) {
                    GridStack(rows: 20, columns: 20) { row, col in
                        CustomView(index: row * 20 + col, itemH: itemH, clearnUp: $cleanUpArr[row * 20 + col], mark: $markArr[row * 20 + col], warState: $warState) { idx in
                            checkClean(idx: idx)
                        }
                        .frame(width: itemH, height: itemH)
                        .background(
                            cleanUpArr[row * 20 + col] ? .gray : .blue
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .strokeBorder(.purple, lineWidth: 1)
                        )
                        .overlay {
                            overlayView(idx: row * 20 + col)
                                .allowsHitTesting(false)
                        }
                    }
                    
                    HStack {
#if os(iOS) || os(tvOS)
                        VStack {
                            Text("双击翻起")
                                .padding([.top, .leading])
                            Text("单击标记")
                                .padding(.leading)
                                .padding([.top], 10)
                        }
                        .font(.body)
                        .foregroundColor(.white)
#else
                        Text("左键翻起")
                            .foregroundColor(.white)
                            .font(.body)
                            .padding()
                        Text("右键标记")
                            .foregroundColor(.white)
                            .font(.body)
                            .padding()
#endif
                        Spacer()
                        
                        Button {
                            switch warState {
                            case .winner:
                                warState = .loading
                            case .loser:
                                warState = .loading
                            case .waring:
                                break
                            case .loading:
                                resetBoomData()
                            }
                        } label: {
                            Text(buttonTitle())
#if os(iOS) || os(tvOS)
                                .font(.body)
#else
                                .font(.largeTitle)
#endif
                                .foregroundColor(.red)
                        }
                        .disabled(warState == .waring)
                        .buttonStyle(.plain)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.blue)
                        )
                        .padding([.top, .leading, .trailing])
                        
                        Spacer()

#if os(iOS) || os(tvOS)
                        VStack {
                            Text("剩余雷数：\(surplusBoomNum)")
                                .foregroundColor(.white)
                                .font(.body)
                                .padding()
                            
                            Picker(selection: $selectLevel) {
                                ForEach(boomLevelArr, id: \.self) { i in
                                    Text("\(i)")
                                }
                            } label: {
                                Text("级别：")
                            }
                            .disabled(warState != .loading)
                            .foregroundColor(.white)
                            .padding(.trailing)
                        }
                        .padding()
#else
                        Text("剩余雷数：\(surplusBoomNum)")
                            .foregroundColor(.white)
                            .font(.body)
                            .padding()
                        
                        Picker(selection: $selectLevel) {
                            ForEach(boomLevelArr, id: \.self) { i in
                                Text("\(i)")
                            }
                        } label: {
                            Text("级别：")
                        }
                        .disabled(warState != .loading)
                        .foregroundColor(.white)
                        .padding(.trailing)
                        .frame(width: 150)
#endif
                    }
#if os(iOS) || os(tvOS)
                    .frame(width: itemH * 21)
#else
                    .frame(width: itemH * 22)
#endif
                }
                
                showWarView()
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .padding()
                    .background(.black)
            }
        }
#if os(iOS) || os(tvOS)
        .ignoresSafeArea()
#else
        .frame(minWidth: itemH * 22, maxWidth: .infinity, minHeight: itemH * 22 + 100, maxHeight: .infinity)
#endif
        .onAppear {
            resetBoomData()
        }
        .onChange(of: warState) { newValue in
            if newValue == .loading {
                cleanUpArr = Array(repeating: true, count: 400)
            }
        }
        .onChange(of: selectLevel) { newValue in
            boomNum = newValue
        }
    }
    
    func buttonTitle() -> String {
        switch warState {
        case .winner:
            return "确定"
        case .loser:
            return "确定"
        case .waring:
            return "重新开始"
        case .loading:
            return "重新开始"
        }
    }
        
    func resetBoomData() {
        cleanUpArr = Array(repeating: false, count: 400)
        markArr = Array(repeating: false, count: 400)
        boomArr = Array(repeating: 0, count: 400)
        surplusBoomNum = boomNum
        loseIdx = -1
        warState = .waring
        
        var idxs = Set<Int>()
        
        while idxs.count != boomNum {
            idxs.insert(Int.random(in: 0..<400))
        }
        
        for idx in idxs {
            boomArr[idx] = 9
        }
        
        for (idx, num) in boomArr.enumerated() {
            if num == 9 {
                continue
            }
            
            var top = false, bottom = false, left = false, right = false
            
            let topIdx = idx - 20
            if topIdx >= 0 {
                top = true
                if boomArr[topIdx] == 9 {
                    boomArr[idx] += 1
                }
            }
            
            let bottomIdx = idx + 20
            if bottomIdx < 400 {
                bottom = true
                if boomArr[bottomIdx] == 9 {
                    boomArr[idx] += 1
                }
            }
            
            let leftIdx = idx - 1
            if leftIdx >= 0, leftIdx / 20 == idx / 20 {
                left = true
                if boomArr[leftIdx] == 9 {
                    boomArr[idx] += 1
                }
            }
            
            let rightIdx = idx + 1
            if rightIdx < 400, rightIdx / 20 == idx / 20 {
                right = true
                if boomArr[rightIdx] == 9 {
                    boomArr[idx] += 1
                }
            }
            
            if top, left {
                if boomArr[leftIdx - 20] == 9 {
                    boomArr[idx] += 1
                }
            }
            
            if bottom, left {
                if boomArr[leftIdx + 20] == 9 {
                    boomArr[idx] += 1
                }
            }
            
            if top, right {
                if boomArr[rightIdx - 20] == 9 {
                    boomArr[idx] += 1
                }
            }
            
            if bottom, right {
                if boomArr[rightIdx + 20] == 9 {
                    boomArr[idx] += 1
                }
            }
        }
    }
    
    func showWarView() -> Text? {
        switch warState {
        case .winner:
            return Text("你赢了！！！")
        case .loser:
            return Text("你输了！！！")
        case .waring:
            return nil
        case .loading:
            return nil
        }
    }
    
    func checkClean(idx: Int) {
        if cleanUpArr[idx] {
            if boomArr[idx] == 9 {
                loseIdx = idx
                warState = .loser
            } else if boomArr[idx] == 0 {
                var top = false, bottom = false, left = false, right = false
                
                let topIdx = idx - 20
                if topIdx >= 0 {
                    top = true
                    if !cleanUpArr[topIdx], !markArr[topIdx] {
                        cleanUpArr[topIdx] = true
                        checkClean(idx: topIdx)
                    }
                }
                
                let bottomIdx = idx + 20
                if bottomIdx < 400 {
                    bottom = true
                    if !cleanUpArr[bottomIdx], !markArr[bottomIdx] {
                        cleanUpArr[bottomIdx] = true
                        checkClean(idx: bottomIdx)
                    }
                }
                
                let leftIdx = idx - 1
                if leftIdx >= 0, leftIdx / 20 == idx / 20 {
                    left = true
                    if !cleanUpArr[leftIdx], !markArr[leftIdx] {
                        cleanUpArr[leftIdx] = true
                        checkClean(idx: leftIdx)
                    }
                }
                
                let rightIdx = idx + 1
                if rightIdx < 400, rightIdx / 20 == idx / 20 {
                    right = true
                    if !cleanUpArr[rightIdx], !markArr[rightIdx] {
                        cleanUpArr[rightIdx] = true
                        checkClean(idx: rightIdx)
                    }
                }
                
                if top, left {
                    if !cleanUpArr[leftIdx - 20], !markArr[leftIdx - 20] {
                        cleanUpArr[leftIdx - 20] = true
                        checkClean(idx: leftIdx - 20)
                    }
                }
                
                if bottom, left {
                    if !cleanUpArr[leftIdx + 20], !markArr[leftIdx + 20] {
                        cleanUpArr[leftIdx + 20] = true
                        checkClean(idx: leftIdx + 20)
                    }
                }
                
                if top, right {
                    if !cleanUpArr[rightIdx - 20], !markArr[rightIdx - 20] {
                        cleanUpArr[rightIdx - 20] = true
                        checkClean(idx: rightIdx - 20)
                    }
                }
                
                if bottom, right {
                    if !cleanUpArr[rightIdx + 20], !markArr[rightIdx + 20] {
                        cleanUpArr[rightIdx + 20] = true
                        checkClean(idx: rightIdx + 20)
                    }
                }
            }
            
            if surplusBoomNum == 0 {
                checkWin()
            }
        } else {
            let markCount = markArr.filter({ $0 }).count
            surplusBoomNum = (boomNum - markCount) >= 0 ? (boomNum - markCount) : 0
            
            if surplusBoomNum == 0 {
                checkWin()
            }
        }
    }
    
    func checkWin() {
        let markCount = markArr.filter({ $0 }).count
        let cleanCount = cleanUpArr.filter({ $0 }).count
        let cleanMap = Dictionary(uniqueKeysWithValues: zip(indexArr, cleanUpArr))
        let noCleanIdx = cleanMap.compactMap { idx, value -> Int? in
            if !value {
                return idx
            }
            return nil
        }
        let blankCount = noCleanIdx.filter({ boomArr[$0] == 0 }).count
        
        if cleanCount + markCount + blankCount == 400 {
            let markMap = Dictionary(uniqueKeysWithValues: zip(indexArr, markArr))
            let boomMap = Dictionary(uniqueKeysWithValues: zip(indexArr, boomArr))
            
            let markIdx = markMap.compactMap({ idx, value -> Int? in
                if value {
                    return idx
                }
                return nil
            }).sorted()
            
            let boomIdx = boomMap.compactMap({ idx, value -> Int? in
                if value == 9 {
                    return idx
                }
                return nil
            }).sorted()
            
            if markIdx == boomIdx {
                warState = .winner
            }
        }
    }
    
    func overlayView(idx: Int) -> Text? {
        if markArr[idx], cleanUpArr[idx] {
            if boomArr[idx] == 9 {
                return Text("✅")
            } else {
                return Text("❌")
            }
        } else if markArr[idx] {
            return Text("🚩")
        } else if cleanUpArr[idx], idx == loseIdx {
            return Text("💥")
        } else if cleanUpArr[idx] {
            return Text(boomString(num: boomArr[idx]))
        } else {
            return nil
        }
    }
    
    func boomString(num: Int) -> String {
        if num == 9 {
            return "💣"
        } else if num == 0 {
            return ""
        } else {
            return "\(num)"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
