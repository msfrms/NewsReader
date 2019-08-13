//
// Created by Radaev Mikhail on 31.03.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import ServiceSwift
import ConcurrentSwift

struct NewsListResponse: Decodable {

    enum CodingKeys : String, CodingKey {
        case documents
    }

    let documents: [String: News]

    init(from decoder: Decoder) throws {
        let mapper = try decoder.container(keyedBy: CodingKeys.self)
        documents = try mapper.decode([String: News].self, forKey: .documents)
    }
}

public class NewsListService: Service<(), [News]> {

    public override func apply(request: ()) -> Future<[News]> {
        return TransformJsonTo<NewsListResponse>()
                .andThen(NetworkDataService())
                .apply(request: URLRequest(url: URL(string: "https://meduza.io/api/v3/search?chrono=articles&locale=ru&page=0&per_page=24")!))
                .map { $0.documents.map { $0.value } }
    }
}
