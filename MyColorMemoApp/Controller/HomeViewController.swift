import Foundation
import RealmSwift
import UIKit

class HomeViewController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    var memoDataList: [MemoDataModel] = []
    let themeColorTypeKey = "themeColorTypeKey"
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        setMemo()
        createTapAddButton()
        setNavigationBarButtonIcon()
        let themeColorType = UserDefaults.standard.integer(forKey: themeColorTypeKey)
        // rawValue(1,2,3...)を指定してenum型を取得
        let themeColor = MyColorType(rawValue: themeColorType) ?? .default
        setThemeColor(type: themeColor)
    }

    func setMemo() {
        let realm = try! Realm()
        let result = realm.objects(MemoDataModel.self)
        memoDataList = Array(result)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setMemo()
        tableView.reloadData()
    }

    // 新規めも作成ボタン押下時の処理
    @objc func addMemoButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // storyBoard idを指定して遷移先のControllerを取得
        let addMemoViewController =
            storyboard.instantiateViewController(
                identifier: "MemoDetailViewController")
            as! MemoDetailViewController
        // 画面遷移処理実行
        navigationController?.pushViewController(
            addMemoViewController, animated: true)
    }

    // ボタン作成処理
    func createTapAddButton() {
        let rightBarButton = UIBarButtonItem(
            barButtonSystemItem: .add, target: self,
            action: #selector(addMemoButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
    }

    // ナビゲーションエリアにカラー変更処理を設定する
    func setNavigationBarButtonIcon() {
        let buttonActionSelector: Selector = #selector(didTapColorSettingButton)
        let leftButtonImage = UIImage(named: "colorSettingIcon")
        let leftButton = UIBarButtonItem(
            image: leftButtonImage, style: .plain, target: self,
            action: buttonActionSelector)
        navigationItem.leftBarButtonItem = leftButton
    }

    // navigationBarButtonのアイコンが押下された時の処理
    @objc func didTapColorSettingButton() {
        // UIalertActionを用いてアラートの選択項目を作成
        let defaultAction = UIAlertAction(
            title: "デフォルト", style: .default,
            handler: { _ -> Void in
                self.setThemeColor(type: .default)
            })
        let orangeAction = UIAlertAction(
            title: "オレンジ", style: .default,
            handler: { _ -> Void in
                self.setThemeColor(type: .orange)
            })
        let redAction = UIAlertAction(
            title: "レッド", style: .default,
            handler: { _ -> Void in
                self.setThemeColor(type: .red)
            })
        let greenAction = UIAlertAction(
            title: "グリーン", style: .default,
            handler: { _ -> Void in
                self.setThemeColor(type: .green)
            })
        let blueAction = UIAlertAction(
            title: "ブルー", style: .default,
            handler: { _ -> Void in
                self.setThemeColor(type: .blue)
            })
        let purpleAction = UIAlertAction(
            title: "パープル", style: .default,
            handler: { _ -> Void in
                self.setThemeColor(type: .purple)
            })
        let cancelAction = UIAlertAction(
            title: "キャンセル", style: .cancel,
            handler: nil)

        let alert = UIAlertController(
            title: "テーマカラーを選択してください", message: "", preferredStyle: .actionSheet)

        // alertにアクションを追加
        alert.addAction(defaultAction)
        alert.addAction(orangeAction)
        alert.addAction(redAction)
        alert.addAction(cancelAction)
        alert.addAction(greenAction)
        alert.addAction(blueAction)
        alert.addAction(purpleAction)
        
        present(alert, animated: true)

    }

    // typeはenum型のいずれか
    func setThemeColor(type: MyColorType) {
        let isDefault = type == .default
        let tintColor: UIColor = isDefault ? .black : .white
        print("type.color: \(type.color)")
        // ナビテーションバーの文字色を変更する
        navigationController?.navigationBar.tintColor = tintColor
        // ナビゲーションバーの色を変更
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = type.color
        
        navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: tintColor
        ]
        // UserDefaultsにテーマカラーの情報を保存する
        saveThemeColor(type: type)
    }
    
    func saveThemeColor(type: MyColorType) {
        // UserDefaultsに保存
        UserDefaults.standard.setValue(type.rawValue,forKey: themeColorTypeKey)
    }
}

extension HomeViewController: UITableViewDataSource {
    // tableの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return memoDataList.count
    }

    // セルを作成して返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let memoDataModel = memoDataList[indexPath.row]
        cell.textLabel?.text = memoDataModel.text
        cell.detailTextLabel?.text = "\(memoDataModel.recordDate)"
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    // セルのタップした際の処理を記載
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // 遷移先のControllerを取得している
        // 遷移先で指定した、メソッドだったり、プロパティの操作をすることが可能
        let memoDetailViewController =
            storyboard.instantiateViewController(
                identifier: "MemoDetailViewController")
            as! MemoDetailViewController
        memoDetailViewController.configure(memo: memoDataList[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(
            memoDetailViewController, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        let targetMemoData = memoDataList[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(targetMemoData)
        }
        memoDataList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

}
