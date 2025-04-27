import Foundation
import UIKit

// Int型を継承することで、enumの値をInt型として扱うことが可能になる
// 上から順に1,2,3,4...と値が割り振られる
enum MyColorType: Int {
    case `default`
    case red
    case orange
    case blue
    case pink
    case green
    case purple

    // 参照した段階で選択しているemunの値に応じて返す値を算出する
    var color: UIColor {
        switch self {
        case .default: return .white
        case .red:
            return UIColor.rgba(red: 210, green: 65, blue: 65, alpha: 1)
        case .orange:
            return UIColor.rgba(red: 248, green: 193, blue: 101, alpha: 1)
        case .blue:
            return UIColor.rgba(red: 65, green: 135, blue: 250, alpha: 1)
        case .pink:
            return UIColor.rgba(red: 240, green: 100, blue: 185, alpha: 1)
        case .green:
            return UIColor.rgba(red: 80, green: 170, blue: 65, alpha: 1)
        case .purple:
            return UIColor.rgba(red: 150, green: 90, blue: 210, alpha: 1)
        }
    }
}

// UIcolorクラスにrgbaを指定してUIColorクラスを返却するメソッドを追加する
extension UIColor {
    static func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat)
        -> UIColor
    {
        return UIColor(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: alpha)
    }
}
