//
// Created by Radaev Mikhail on 2019-08-12.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import AsyncDisplayKit
import SUtils
import ADKUtils
import AttributeStyle

public class NewsDetailNode: ASDisplayNode, Renderer {

    public enum ViewModel {
        public struct Content {
            public struct Button {
                let title: String
                let onTap: Command
            }
            let news: NewsNode.ViewModel
            let readButton: Button
        }
        case inProgress
        case present(Content)
        case empty(String)
    }

    public struct Styles {
        let titleButton: AttributeStyle
        let empty: AttributeStyle
        let content: NewsNode.Styles
    }

    private let detail: NewsNode
    private let emptyTextNode = ASTextNode()
    private let readButton = ASButtonNode().preferred(size: CGSize(width: 200, height: 44))
    private let loadingNode = LoadingNode().preferred(size: CGSize(width: 25.0, height: 25.0))
    private let styles: Styles
    private var viewModel: ViewModel?

    public init(styles: Styles) {
        self.styles = styles
        detail = NewsNode(styles: styles.content)
        super.init()
        automaticallyManagesSubnodes = true
    }

    public override func didLoad() {
        super.didLoad()
        backgroundColor = .white
        readButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        readButton.cornerRadius = readButton.style.preferredSize.height / 2.0
    }

    public func render(viewModel: ViewModel) {
        switch viewModel {
        case .present(let content):
            loadingNode.stop()
            detail.render(viewModel: content.news)
            readButton.setAttributedTitle(content.readButton.title.with(style: styles.titleButton), for: .normal)
            readButton.add(command: content.readButton.onTap, event: .touchUpInside)
        case .empty(let text):
            loadingNode.stop()
            emptyTextNode.attributedText = text.with(style: styles.empty)
        case .inProgress:
            loadingNode.start()
        }
        self.viewModel = viewModel
        setNeedsLayout()
    }

    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        switch viewModel {
        case .inProgress?:
            return loadingNode.center
        case .empty?:
            return emptyTextNode.center
        case .present?:
            return detail
                    .overlay(readButton
                            .relative(vertical: .end, horizontal: .center)
                            .insets(UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)))
                    .insets(.zero)
        case .none:
            return ASLayoutSpec()
        }
    }
}
