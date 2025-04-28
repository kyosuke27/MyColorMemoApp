//
//  Memo.swift
//  MyColorMemoApp
//
//  Created by kyosuke on 2025/04/25.
//

import Foundation
import RealmSwift

// Realmを使うために、Objectクラスを継承する
class MemoDataModel: Object {
    // データを一意に識別するために使用するクラス
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var text: String = ""
    @objc dynamic var recordDate: Date = Date()
}
