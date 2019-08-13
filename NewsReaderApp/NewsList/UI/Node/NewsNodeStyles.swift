//
// Created by Radaev Mikhail on 2019-08-11.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation
import AttributeStyle
import SUtils
import AsyncDisplayKit

public extension NewsNode.Styles {

    static var classic: NewsNode.Styles {
        return NewsNode.Styles(
                image: .init(backgroundColor: UIColor(rgb: 0xC7C7CD)),
                imageHeight: 190,
                insets: UIEdgeInsets(top: 15, left: 15, bottom: 5, right: 15),
                shadow: CommandWith<ASDisplayNode> { node in
                    node.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
                    node.shadowOffset = CGSize(width: 0, height: 3)
                    node.shadowRadius = 3
                    node.shadowOpacity = 0.1
                    node.layer.masksToBounds = false
                    node.backgroundColor = .white
                },
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
                        .color(.foreground(UIColor(rgb: 0xC7C7CD))))
    }
}
