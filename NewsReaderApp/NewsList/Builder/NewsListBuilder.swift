//
// Created by Radaev Mikhail on 31.03.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import AttributeStyle
import SUtils

extension NewsNode.Props: DataProps {}

struct NewsListStyles {
    static let h1 = AttributeStyle()
            .font(.systemFont(ofSize: 17, weight: .regular))
            .color(.foreground(.black))

    static let h2 = AttributeStyle()
            .font(.systemFont(ofSize: 14, weight: .regular))
            .color(.foreground(UIColor(rgb: 0x8F8E94)))
            .spacing(.line(5))

    static let h3 = AttributeStyle()
            .font(.systemFont(ofSize: 12, weight: .regular))
            .color(.foreground(UIColor(rgb: 0xB8E986)))

    static let h4 = AttributeStyle()
            .font(.systemFont(ofSize: 14, weight: .regular))
            .color(.foreground(UIColor(rgb: 0xC7C7CD)))
}

func create(news: News, onSelected: Command? = nil) -> NewsNode.Props {

    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"

    let detail = news.description
        .flatMap { $0.with(style: NewsListStyles.h2) }
        .getOrElse(news.detail.with(style: NewsListStyles.h2))
    let title = news.title.with(style: NewsListStyles.h1)
    let tag = news.tag.map { $0 + "  " }.getOrElse("").with(style: NewsListStyles.h3)
            + formatter.string(from: news.publishDate).with(style: NewsListStyles.h4)

    return NewsNode.Props(
            detail: detail,
            tag: tag,
            imageURL: news.imageURL.flatMap { URL(string: $0) },
            title: title,
            onSelected: onSelected)
}

class NewsItemFactory: AnyItemFactory<DataProps> {
    override func create(props: DataProps) -> ASCellNode {

        let news: NewsNode.Props = props as! NewsNode.Props

        let node = NewsNode(props: news)

        if news.detail.length > 0 {
            node.dispatch(action: .full)
        } else {
            node.dispatch(action: .short)
        }

        return node
    }
}

func route(_ fromViewController: UIViewController, toNews: News) -> Command {
    return Command {
        fromViewController.navigationController?.pushViewController(NewsDetailBuilder().build(toNews.id), animated: true)
    }
}

class NewsListBuilder {

    func build() -> BaseViewController {
        let table = SelectableTableNode().with(factory: NewsItemFactory())
        table.dispatch(action: .loading)
        table.backgroundColor = UIColor(rgb: 0xFAFAFA)

        let viewController = BaseViewController(node: table)
        viewController.title = "Новости"

        table.dispatch(action: .loading)

        NewsListServiceBuilder()
                .build()
                .map { $0.map { create(news: $0, onSelected: route(viewController, toNews: $0)) } }
                .observe(queue: .main)
                .onSuccess { news in
                    table.dispatch(action: .reload(news))
                }
                .onFailure { _ in
                    let text = "Произошла непредвиденная ошибка".with(style: NewsListStyles.h2)
                    table.dispatch(action: .empty(text))
                }

        return viewController
    }
}
