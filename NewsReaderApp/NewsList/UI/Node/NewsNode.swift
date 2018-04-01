//
// Created by Radaev Mikhail on 31.03.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import AttributeStyle
import AsyncDisplayKit
import ADKUtils
import SUtils

class NewsNode: BaseCellNode {
    struct Styles {
        let imageHeight: CGFloat
        let shouldShadow: Bool
        let insets: UIEdgeInsets

        init(imageHeight: CGFloat, shouldShadow: Bool, insets: UIEdgeInsets) {
            self.imageHeight = imageHeight
            self.shouldShadow = shouldShadow
            self.insets = insets
        }

        init() { self.init(imageHeight: 190, shouldShadow: true, insets: UIEdgeInsets(top: 15, left: 15, bottom: 5, right: 15)) }
    }

    enum Action {
        case short
        case full
    }

    struct Props: Selectable {
        let imageURL: URL?
        let title: NSAttributedString?
        let detail: NSAttributedString
        let tag: NSAttributedString
        private(set) var onSelected: Command?

        init(detail: NSAttributedString, tag: NSAttributedString, imageURL: URL?, title: NSAttributedString?, onSelected: Command? = nil) {
            self.imageURL = imageURL
            self.title = title
            self.detail = detail
            self.tag = tag
            self.onSelected = onSelected
        }

        init() { self.init(detail: .empty, tag: .empty, imageURL: nil, title: nil) }
    }

    private var props: Props = Props()
    private var background: ASDisplayNode = ASDisplayNode().stretch
    private var image = ASNetworkImageNode().stretch.preferred(height: 190)
    private var title = ASTextNode()
    private var tag = ASTextNode()
    private var detail = ASTextNode()
    private var action: Action = .full
    private var styles = Styles()

    convenience init(props: Props) {
        self.init()
        self.props = props
    }

    convenience init(props: Props, styles: Styles) {
        self.init(props: props)
        self.styles = styles
    }
    
    override func didLoad() {
        super.didLoad()

        self.background.backgroundColor = .white

        if self.styles.shouldShadow {
            self.background.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
            self.background.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.background.layer.shadowRadius = 3
            self.background.layer.shadowOpacity = 0.1
            self.background.layer.masksToBounds = false
        }

        self.image.backgroundColor = UIColor(rgb: 0xC7C7CD)
        self.image.url = self.props.imageURL
        let _ = self.image.preferred(height: self.styles.imageHeight)

        self.title.attributedText = self.props.title
        self.tag.attributedText = self.props.tag
        self.detail.attributedText = self.props.detail
    }

    func dispatch(action: Action) {
        self.action = action
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        var nodes: [ASLayoutElement] = []
        nodes.append(self.image)
        nodes.append(self.title.insets(UIEdgeInsets(top: 13, left: 20, bottom: 0, right: 20)))

        switch self.action {
        case .full:
            nodes.append(self.tag.insets(UIEdgeInsets(top: 8, left: 20, bottom: 0, right: 20)))
            nodes.append(self.detail.insets(UIEdgeInsets(top: 8, left: 20, bottom: 10, right: 20)))
        case .short:
            nodes.append(self.tag.insets(UIEdgeInsets(top: 8, left: 20, bottom: 10, right: 20)))
        }

        let contentLayout = ASStackLayoutSpec(
                direction: .vertical,
                spacing: 0,
                justifyContent: .start,
                alignItems: .start,
                children: nodes)

        return ASBackgroundLayoutSpec(child: contentLayout, background: self.background).insets(self.styles.insets)
    }
}
