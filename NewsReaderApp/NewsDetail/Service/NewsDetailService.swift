//
// Created by Radaev Mikhail on 01.04.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import SUtils

public typealias NewsID = String

struct NewsDetailResponse: Decodable {
    let root: News
}

public protocol NewsDetailService {
    func fetch(callback: CommandWith<Result<News, Error>>)
}

public class NewsDetailServiceImpl: NewsDetailService {

    private let newsID: NewsID

    public init(newsID: NewsID) {
        self.newsID = newsID
    }

    public func fetch(callback: CommandWith<Result<News, Error>>) {
        let request = URLRequest(url: URL(string: "https://meduza.io/api/v3/" + newsID)!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            switch (response, data, error) {
            case (_, .some(let data), _):
                let response = try? JSONDecoder().decode(NewsDetailResponse.self, from: data)
                guard let news = response?.root else {
                    return
                }
                callback.execute(value: .success(news))
            
            default:
                callback.execute(value: .failure(error!))
            }
        }

        task.resume()
    }
}
