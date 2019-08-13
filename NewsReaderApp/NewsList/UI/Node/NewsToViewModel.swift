//
// Created by Radaev Mikhail on 2019-08-12.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation
import SUtils

public extension NewsNode.ViewModel {

    init?(news: News, goDetail: Command? = nil) {

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"

        let url = news.imageURL.flatMap { URL(string: $0) }
        guard let imageURL = url, let tag = news.tag else { return nil }

        self = NewsNode.ViewModel(
                image: .url(imageURL),
                title: news.title,
                detail: news.detail.isEmpty ? nil : news.detail,
                tag: tag,
                publishDate: formatter.string(from: news.publishDate),
                onTap: goDetail)
    }
}