//
// Created by Radaev Mikhail on 2019-08-12.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation
import AttributeStyle
import AsyncDisplayKit
import SUtils

public extension NewsDetailNode.Styles {

    static var classic: NewsDetailNode.Styles {
        return NewsDetailNode.Styles(
                titleButton: AttributeStyle()
                        .font(.systemFont(ofSize: 12, weight: .regular))
                        .color(.foreground(.white)),
                empty: AttributeStyle()
                        .font(.systemFont(ofSize: 14, weight: .regular))
                        .color(.foreground(UIColor(rgb: 0x8F8E94)))
                        .spacing(.line(5)),
                content: NewsNode.Styles(
                        image: .init(backgroundColor: UIColor(rgb: 0xC7C7CD)),
                        imageHeight: 330,
                        insets: .zero,
                        shadow: CommandWith<ASDisplayNode> { _ in },
                        title: AttributeStyle()
                                .font(.systemFont(ofSize: 17, weight: .regular))
                                .color(.foreground(.black)),
                        detail: AttributeStyle()
                                .font(.systemFont(ofSize: 14, weight: .regular))
                                .color(.foreground(UIColor(rgb: 0x8F8E94)))
                                .spacing(.line(5)),
                        tag: AttributeStyle()
                                .font(.systemFont(ofSize: 12, weight: .regular))
                                .color(.foreground(UIColor(rgb: 0xB8E986))),
                        publishDate: AttributeStyle()
                                .font(.systemFont(ofSize: 14, weight: .regular))
                                .color(.foreground(UIColor(rgb: 0xC7C7CD)))))
    }
}
