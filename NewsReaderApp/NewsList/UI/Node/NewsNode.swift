//
// Created by Radaev Mikhail on 31.03.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import AttributeStyle
import AsyncDisplayKit
import ADKUtils
import SUtils

public class NewsNode: ASDisplayNode, Renderer {

    public struct Styles {
        let image: ImageNode.Styles
        let imageHeight: CGFloat
        let insets: UIEdgeInsets
        let shadow: CommandWith<ASDisplayNode>
        let title: AttributeStyle
        let detail: AttributeStyle
        let tag: AttributeStyle
        let publishDate: AttributeStyle
    }
    
    public struct ViewModel {
        let image: ImageNode.ViewModel
        let title: String
        let detail: String?
        let tag: String
        let publishDate: String
        let onTap: Command?
    }

    private let background: ASDisplayNode = ASDisplayNode().stretch
    private let image: ImageNode
    private let title = ASTextNode()
    private let tag = ASTextNode()
    private let detail = ASTextNode()
    private let styles: Styles
    private var viewModel: ViewModel?

    public init(styles: Styles) {
        self.styles = styles
        image = ImageNode(styles: styles.image)
        super.init()
        self.automaticallyManagesSubnodes = true
    }

    public override func didLoad() {
        super.didLoad()

        styles.shadow.execute(value: background)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tap)
    }

    @objc private func didTap() {
        viewModel?.onTap?.execute()
    }

    public func render(viewModel: ViewModel) {
        image.render(viewModel: viewModel.image)
        title.attributedText = viewModel.title.with(style: styles.title)
        tag.attributedText = viewModel.tag.with(style: styles.tag) + " \(viewModel.publishDate)".with(style: styles.publishDate)
        detail.attributedText = viewModel.detail.map { $0.with(style: styles.detail) }
        self.viewModel = viewModel
    }

    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let detailLine: ASLayoutElement? = {
            guard detail.attributedText != nil else { return nil }
            return detail.insets(UIEdgeInsets(top: 8, left: 10, bottom: 10, right: 10))
        }()

        let nodes: [ASLayoutElement?] = [
            image.preferred(height: styles.imageHeight).stretch,
            title.insets(UIEdgeInsets(top: 13, left: 10, bottom: 0, right: 10)),
            tag.insets(UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10)),
            detailLine
        ]

        let contentLayout = ASStackLayoutSpec(
                direction: .vertical,
                spacing: 0,
                justifyContent: .start,
                alignItems: .start,
                children: nodes.compactMap { $0 })

        return ASBackgroundLayoutSpec(child: contentLayout, background: background).insets(self.styles.insets)
    }
}
