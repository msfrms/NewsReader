//
// Created by Radaev Mikhail on 31.03.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import SUtils

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

public protocol NewsListService {
    func fetch(callback: CommandWith<Result<[News], Error>>)
}

public class NewsListServiceImpl: NewsListService {

    public func fetch(callback: CommandWith<Result<[News], Error>>) {
        let request = URLRequest(url: URL(string: "https://meduza.io/api/v3/search?chrono=articles&locale=ru&page=0&per_page=24")!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            switch (response, data, error) {
            case (_, .some(let data), _):
                let response = try? JSONDecoder().decode(NewsListResponse.self, from: data)
                guard let news = (response.map { $0.documents.values }) else {
                    return
                }
                callback.execute(value: .success([News](news)))
            
            default:
                callback.execute(value: .failure(error!))
            }
        }

        task.resume()
    }
}
