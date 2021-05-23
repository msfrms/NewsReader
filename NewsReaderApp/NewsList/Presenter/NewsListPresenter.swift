//
// Created by Radaev Mikhail on 2019-08-12.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation
import SUtils

public class NewsListPresenter: LifeCycle {

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
        newsListService.fetch(callback: CommandWith { [weak self] result in
            switch result {
            case .success(let news):
                guard let `self` = self else { return }
                let newsVM = news.map { [weak self] item in
                    NewsNode.ViewModel(news: item, goDetail: Command {
                        guard let `self` = self else { return }
                        self.router.goDetail(with: item.id)
                    })
                }
                self.listView.render(viewModel: .present(newsVM.compactMap { $0 }))
            case .failure:
                guard let `self` = self else { return }
                self.listView.render(viewModel: .empty("Не удалось загрузить список новостей"))
                
            }
        }.observe(queue: .main))
    }
}
