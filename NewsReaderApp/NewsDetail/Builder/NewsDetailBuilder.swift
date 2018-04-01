//
// Created by Radaev Mikhail on 01.04.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import SUtils
import AttributeStyle
import SafariServices.SFSafariViewController

class NewsDetailItemFactory: AnyItemFactory<DataProps> {
    override func create(props: DataProps) -> ASCellNode {

        let news: NewsNode.Props = props as! NewsNode.Props

        let node = NewsNode(props: news, styles: NewsNode.Styles(
                imageHeight: 330,
                shouldShadow: false,
                insets: .zero))

        node.dispatch(action: .full)

        return node
    }
}

class NewsDetailBuilder {
    func build(_ id: String) -> BaseViewController {

        let table = TableNodeByActiveButton().with(factory: NewsDetailItemFactory())
        table.dispatch(action: .loading)
        table.backgroundColor = .white

        let viewController = BaseViewController(node: table)
        viewController.title = "News"

        let props = TableNodeByActiveButton.Props(
                list: TableNode.Props(),
                read: TableNodeByActiveButton.Props.ActiveButton(
                        action: Command {
                            let web = SFSafariViewController(url: URL(string: "https://meduza.io/" + id)!)
                            viewController.present(web, animated: true)
                        },
                        title: "Читать подробнее".uppercased().with(style: AttributeStyle()
                                .font(.systemFont(ofSize: 12, weight: .regular))
                                .color(.foreground(.white)))))

        table.props = props

        table.dispatch(action: .loading)

        NewsDetailServiceBuilder()
                .build(id)
                .map { create(news: $0) }
                .observe(queue: .main)
                .onSuccess { news in
                    table.dispatch(action: .reload([news]))
                }
                .onFailure { _ in
                    let text = "Произошла непредвиденная ошибка".with(style: NewsListStyles.h2)
                    table.dispatch(action: .empty(text))
                }

        return viewController
    }
}
