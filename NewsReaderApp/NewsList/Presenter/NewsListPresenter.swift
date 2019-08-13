//
// Created by Radaev Mikhail on 2019-08-12.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation
import ConcurrentSwift
import ServiceSwift
import SUtils

public class NewsListPresenter: LifeCycle {

    public typealias NewsListService = Service<(), [News]>

    private let listView: AnyRender<NewsListNode.ViewModel>
    private let newsListService: NewsListService
    private let router: NewsDetailRouter

    public init<R: Renderer>(listView: R, newsListService: NewsListService, router: NewsDetailRouter) where R.ViewModel == NewsListNode.ViewModel {
        self.listView = AnyRender(render: listView)
        self.newsListService = newsListService
        self.router = router
    }

    public func didLoad() {
        listView.render(viewModel: .inProgress)
        newsListService.apply()
                .observe(queue: .main)
                .onSuccess { [weak self] news in
                    guard let `self` = self else { return }
                    let newsVM = news.map { [weak self] item in
                        NewsNode.ViewModel(news: item, goDetail: Command {
                            guard let `self` = self else { return }
                            self.router.goDetail(with: item.id)
                        })
                    }
                    self.listView.render(viewModel: .present(newsVM.compactMap { $0 }))
                }
                .onFailure { [weak self] error in
                    guard let `self` = self else { return }
                    self.listView.render(viewModel: .empty("Не удалось загрузить список новостей"))
                }
    }
}
