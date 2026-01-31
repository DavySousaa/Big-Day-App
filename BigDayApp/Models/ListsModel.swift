import UIKit
import Foundation

struct UserList: Codable {
    let id: String?
    let title: String
    let iconName: String
}

struct ListItem {
    let id: String
    var title: String
    var isCompleted: Bool
}
