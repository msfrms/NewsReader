//
// Created by Radaev Mikhail on 31.03.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import SUtils
import ADKUtils

class AnyItemFactory<Props> {
    func create(props: Props) -> ASCellNode {
        return ASCellNode()
    }
}

protocol Selectable {
    var onSelected: Command? { get }
}

protocol DataProps {}

typealias TableCommand = CommandWith<ASTableNode>

extension CommandWith where T == ASTableNode {
    static var nop: TableCommand { return TableCommand { table in } }
    static func reload(complete: Command) -> TableCommand {
        return TableCommand { $0.reloadData { complete.execute() } }
    }
}

class TableNode: ASDisplayNode, ASTableDataSource, ASTableDelegate {

    typealias Item = DataProps

    enum Action {
        case reload(Array<Item>)
        case perform(TableCommand)
        case loading
        case empty(NSAttributedString)
    }

    struct Props {

        let didReloadData: Command
        let willBeginDragging: Command
        let didScroll: TableCommand

        init(didReloadData: Command) { self.init(didReloadData: didReloadData, willBeginDragging: .nop, didScroll: .nop) }

        init(didReloadData: Command, willBeginDragging: Command, didScroll: TableCommand) {
            self.didReloadData = didReloadData
            self.willBeginDragging = willBeginDragging
            self.didScroll = didScroll
        }

        init() { self.init(didReloadData: .nop) }
    }

    private var table: ASTableNode = ASTableNode(style: .plain)
    private var loading = LoadingNode()
    private var empty = ASTextNode()
    private(set) var components: Array<Item> = []
    var props: TableNode.Props
    private var action: Action = .reload([])
    private var factory: AnyItemFactory<Item> = AnyItemFactory<Item>()

    init(props: TableNode.Props, components: Array<Item>) {
        self.props = props

        super.init()

        self.components = components
        self.table.delegate = self
        self.table.dataSource = self
        self.table.backgroundColor = .clear
        self.table.view.estimatedRowHeight = 0
        self.table.view.estimatedSectionFooterHeight = 0
        self.table.view.estimatedSectionHeaderHeight = 0
        self.table.view.tableFooterView = UIView()
        self.table.view.separatorStyle = .none
        self.table.view.separatorColor = .black
        self.table.view.keyboardDismissMode = .interactive

        self.loading.style.preferredSize = CGSize(width: 25.0, height: 25.0)

        self.automaticallyManagesSubnodes = true
    }
    @discardableResult
    func with(factory: AnyItemFactory<Item>) -> Self {
        self.factory = factory
        return self
    }

    convenience init(props: TableNode.Props) {
        self.init(props: props, components: [])
    }

    convenience override init() {
        self.init(props: TableNode.Props(), components: [])
    }

    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.props.willBeginDragging.execute()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.props.didScroll.execute(value: self.table)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        switch self.action {
        case .empty: return self.table.overlay(self.empty.center)
        default: return self.table.overlay(self.loading.center)
        }
    }

    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.components.count
    }

    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> () -> ASCellNode {
        return {
            let item = self.components[indexPath.row]
            return self.factory.create(props: item)
        }
    }

    func dispatch(action: Action) {
        self.action = action
        switch action {
        case .reload(let comps):
            self.loading.stop()
            self.components = comps
            self.dispatch(action: .perform(.reload(complete: self.props.didReloadData)))
        case .loading:
            self.components = []
            self.table.reloadData()
            self.loading.start()
            self.empty.attributedText = nil
        case .empty(let text):
            self.components = []
            self.table.reloadData()
            self.loading.stop()
            self.empty.attributedText = text
        case .perform(let command):
            command.execute(value: self.table)
        }

        self.setNeedsLayout()
    }
}

class SelectableTableNode: TableNode {

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {

        let item = self.components[indexPath.row]

        switch item {
        case let selected as Selectable: selected.onSelected?.execute()
        default: ()
        }
    }
}
