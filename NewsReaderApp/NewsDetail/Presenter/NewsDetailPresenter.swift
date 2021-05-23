//
// Created by Radaev Mikhail on 2019-08-13.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation
import SUtils

public class NewsDetailPresenter: LifeCycle {

    private let detailView: AnyRender<NewsDetailNode.ViewModel>
    private let newsDetailService: NewsDetailService
    private let router: NewsDetailRouter

    public init<R: Renderer>(detailView: R, newsDetailService: NewsDetailService, router: NewsDetailRouter) where R.ViewModel == NewsDetailNode.ViewModel {
        self.detailView = AnyRender(render: detailView)
        self.newsDetailService = newsDetailService
        self.router = router
    }

    public func didLoad() {
        detailView.render(viewModel: .inProgress)
        newsDetailService.fetch(callback: CommandWith { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let news):
                guard let newsVM = NewsNode.ViewModel(news: news) else { return }
                self.detailView.render(viewModel: .present(.init(
                        news: newsVM,
                        readButton: .init(title: "Читать подробнее", onTap: Command { [weak self] in
                            guard let `self` = self else { return }
                            self.router.goDetail(with: news.id)
                        }))))
            case .failure:
                self.detailView.render(viewModel: .empty("Не удалось загрузить новость"))
                
                
            }
        }.observe(queue: .main))
    }
}
