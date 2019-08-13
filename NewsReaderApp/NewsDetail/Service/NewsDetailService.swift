//
// Created by Radaev Mikhail on 01.04.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import ServiceSwift
import ConcurrentSwift
import SUtils

public typealias NewsID = String

struct NewsDetailResponse: Decodable {
    let root: News
}

public class NewsDetailService: Service<(), News> {

    private let newsID: NewsID

    public init(newsID: NewsID) {
        self.newsID = newsID
    }

    public override func apply(request: Void) -> Future<News> {
        return TransformJsonTo<NewsDetailResponse>()
                .andThen(NetworkDataService())
                .apply(request: URLRequest(url: URL(string: "https://meduza.io/api/v3/" + newsID)!))
                .map { $0.root }
    }
}
