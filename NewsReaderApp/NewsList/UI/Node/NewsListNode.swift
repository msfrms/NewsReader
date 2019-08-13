//
// Created by Radaev Mikhail on 2019-08-11.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import AttributeStyle

public class NewsListNode: ASDisplayNode, ASTableDataSource, ASTableDelegate, Renderer {

    public enum ViewModel {
        case inProgress
        case present([NewsNode.ViewModel])
        case empty(String)
    }

    public struct Styles {
        let empty: AttributeStyle
        let newsItem: () -> NewsNode.Styles
    }

    private let listNode: ASTableNode = ASTableNode(style: .plain)
    private let loadingNode = LoadingNode()
    private let emptyTextNode = ASTextNode()
    private var viewModel: ViewModel?
    private let styles: Styles
    private var newsList: [NewsNode.ViewModel] = []

    public init(styles: Styles) {
        self.styles = styles
        super.init()
        self.automaticallyManagesSubnodes = true
    }

    public override func didLoad() {
        super.didLoad()

        listNode.delegate = self
        listNode.dataSource = self
        listNode.backgroundColor = .clear
        listNode.view.estimatedRowHeight = 0
        listNode.view.estimatedSectionFooterHeight = 0
        listNode.view.estimatedSectionHeaderHeight = 0
        listNode.view.tableFooterView = UIView()
        listNode.view.separatorStyle = .none
        listNode.view.separatorColor = .black
        listNode.view.keyboardDismissMode = .interactive
        backgroundColor = .white
    }

    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        switch viewModel {
        case .empty?:
            return emptyTextNode.center
        case .inProgress?:
            return loadingNode.preferred(size: CGSize(width: 25.0, height: 25.0)).center
        case .present?:
            return listNode.insets(.zero)
        case .none:
            return ASLayoutSpec()
        }
    }

    public func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }

    public func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
       return newsList.count
    }

    public func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> () -> ASCellNode {
        return {
            guard self.newsList.indices.contains(indexPath.row) else { fatalError() }
            let news = self.newsList[indexPath.row]
            let node = NewsNode(styles: self.styles.newsItem())
            node.render(viewModel: news)
            return ASCellNodeWrapper(with: node)
        }
    }

    public func render(viewModel: ViewModel) {
        self.viewModel = viewModel
        switch viewModel {
        case .inProgress:
            loadingNode.start()
        case .empty(let text):
            loadingNode.stop()
            emptyTextNode.attributedText = text.with(style: styles.empty)
        case .present(let news):
            loadingNode.stop()
            self.newsList = news
            listNode.reloadData()
        }
        setNeedsLayout()
    }
}
