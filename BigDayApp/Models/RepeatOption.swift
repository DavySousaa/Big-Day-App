import UIKit
import Foundation

struct RepeatOption {
    let title: String
    var isSelected: Bool
}

struct RepeatOptionsSuport {
    static var repeatOptions: [RepeatOption] = [
        RepeatOption(title: "não", isSelected: true),
        RepeatOption(title: "seg", isSelected: false),
        RepeatOption(title: "ter", isSelected: false),
        RepeatOption(title: "qua", isSelected: false),
        RepeatOption(title: "qui", isSelected: false),
        RepeatOption(title: "sex", isSelected: false),
        RepeatOption(title: "sáb", isSelected: false),
        RepeatOption(title: "dom", isSelected: false)
    ]
}



