//
// Created by Radaev Mikhail on 2019-08-13.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation
import ServiceSwift
import ConcurrentSwift
import SUtils

public class NewsDetailPresenter: LifeCycle {

    public typealias NewsDetailService = Service<(), News>

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
        newsDetailService.apply()
                .observe(queue: .main)
                .onSuccess { [weak self] news in
                    guard let `self` = self, let newsVM = NewsNode.ViewModel(news: news) else { return }
                    self.detailView.render(viewModel: .present(.init(
                            news: newsVM,
                            readButton: .init(title: "Читать подробнее", onTap: Command { [weak self] in
                                guard let `self` = self else { return }
                                self.router.goDetail(with: news.id)
                            }))))
                }
                .onFailure { [weak self] _ in
                    guard let `self` = self else { return }
                    self.detailView.render(viewModel: .empty("Не удалось загрузить новость"))
                }
    }
}