//
// Created by Radaev Mikhail on 2019-08-12.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import UIKit

public class NewsListFactory {

    public func create() -> UIViewController {
        let listNews = NewsListNode(styles: .classic)
        let router = NewsRouter()
        let newsListPresenter = NewsListPresenter(
                listView: listNews,
                newsListService: NewsListServiceImpl(),
                router: router)
        let viewController = BaseViewController(node: listNews, presenter: newsListPresenter)
        viewController.title = "НОВОСТИ"
        router.fromViewController = viewController
        return viewController
    }
}
