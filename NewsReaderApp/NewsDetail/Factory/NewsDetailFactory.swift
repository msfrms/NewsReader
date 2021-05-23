//
// Created by Radaev Mikhail on 2019-08-13.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import UIKit

public class NewsDetailFactory {

    public func create(with newsID: String) -> UIViewController {
        let detailNode = NewsDetailNode(styles: .classic)
        let newsDetailService = NewsDetailServiceImpl(newsID: newsID)
        let router = SafariBrowserRouter()
        let presenter = NewsDetailPresenter(
                detailView: detailNode,
                newsDetailService: newsDetailService,
                router: router)
        let viewController = BaseViewController(node: detailNode, presenter: presenter)
        router.fromViewController = viewController
        return viewController
    }
}
