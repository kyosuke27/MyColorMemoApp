//
//  MemoDetailViewController.swift
//  MyColorMemoApp
//
//  Created by kyosuke on 2025/04/26.
//

import Foundation
import RealmSwift
import UIKit

class MemoDetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    var memoData = MemoDataModel()
    var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
        setDoneButton()
        textView.delegate = self
    }

    // 値の設定用のメソッド
    func configure(memo: MemoDataModel) {
        memoData.text = memo.text
        memoData.recordDate = memo.recordDate
    }

    // メモ詳細画面に映った際にUIに値を反映させるためのメソッド
    func displayData() {
        textView.text = memoData.text
        // NavigateionBarのタイトルに日時を設定する
        navigationItem.title = dateFormat.string(from: memoData.recordDate)
    }

    @objc func tapDoneButton() {
        view.endEditing(true)
    }

    func setDoneButton() {
        // キーボードに設定したいツールバーをインスタンス化
        let toolBar = UIToolbar(
            frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let doneButton = UIBarButtonItem(
            title: "完了",
            style: .done,
            target: self,
            action: #selector(tapDoneButton))
        toolBar.items = [doneButton]
        // テキストビューの入力キーボードにツールバーを設定
        textView.inputAccessoryView = toolBar
    }

    // Realmへデータ保存
    func saveData(with updateText: String){
        let realm = try! Realm()
        try! realm.write {
            memoData.text = updateText
            // 日時を更新する
            memoData.recordDate = Date()
            realm.add(memoData)
        }
    }
}

// テキストビューへの入力のたびに、値を保存するためにUITextViewDelegateを実装
extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let updateText = textView.text ?? ""
        saveData(with: updateText)
    }
}
