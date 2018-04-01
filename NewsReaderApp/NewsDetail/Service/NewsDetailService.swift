//
// Created by Radaev Mikhail on 01.04.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import ServiceSwift
import ConcurrentSwift
import SUtils

extension String: Swift.Error {}

struct NewsDetailResponse: Decodable {
    let root: News
}

class NewsDetailServiceBuilder {
    func build(_ id: String) -> Future<News> {
        return TransformJsonTo<NewsDetailResponse>()
                .andThen(NetworkDataService())
                .apply(request: URLRequest(url: URL(string: "https://meduza.io/api/v3/" + id)!))
                .map { $0.root }
    }
}