//
// Created by Radaev Mikhail on 01.04.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SUtils
import ADKUtils
import AttributeStyle

class TableNodeByActiveButton: ASDisplayNode {
    struct Props {
        struct ActiveButton {
            let action: Command
            let title: NSAttributedString
        }

        let list: TableNode.Props
        let read: ActiveButton
    }

    private let table = TableNode()
    private let read = ASButtonNode().preferred(size: CGSize(width: 200, height: 44))
    var props: Props = Props(list: TableNode.Props(), read: Props.ActiveButton(action: .nop, title: .empty))

    override init() {
        super.init()

        self.automaticallyManagesSubnodes = true

        self.read.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.read.cornerRadius = self.read.style.preferredSize.height / 2.0

        self.table.dispatch(action: .perform(TableCommand { table in
            table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        }))
    }

    convenience init(props: Props) {
        self.init()
        self.props = props
    }

    override func didLoad() {
        super.didLoad()

        self.read.setAttributedTitle(self.props.read.title, for: .normal)
        self.read.add(command: self.props.read.action, event: .touchUpInside)

        self.table.props = self.props.list
    }

    func dispatch(action: TableNode.Action) {
        self.table.dispatch(action: action)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.table.overlay(self.read
                .relative(vertical: .end, horizontal: .center)
                .insets(UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)))
    }

    func with(factory: AnyItemFactory<DataProps>) -> Self {
        self.table.with(factory: factory)
        return self
    }
}
