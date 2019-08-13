//
// Created by Radaev Mikhail on 2019-08-12.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation
import AttributeStyle

public extension NewsListNode.Styles {

    static var classic: NewsListNode.Styles {
        return NewsListNode.Styles(
                empty: AttributeStyle()
                        .font(.systemFont(ofSize: 14, weight: .regular))
                        .color(.foreground(UIColor(rgb: 0x8F8E94)))
                        .spacing(.line(5)),
                newsItem: { NewsNode.Styles.classic })
    }
}
