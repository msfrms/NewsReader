//
// Created by Radaev Mikhail on 31.03.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import ServiceSwift
import ConcurrentSwift
import SUtils

public extension DateFormatter {
    public static var publish: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

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

extension News: Decodable {
    enum CodingKeys : String, CodingKey {
        case id = "url"
        case title = "title"
        case detail = "second_title"
        case imageURL = "image"
        case publishDate = "pub_date"
        case tag
        case description
    }

    struct Image: Decodable {
        enum CodingKeys : String, CodingKey {
            case smallUrl = "small_url"
        }

        let smallUrl: String

        init(from decoder: Decoder) throws {
            let mapper = try decoder.container(keyedBy: CodingKeys.self)
            smallUrl = try mapper.decode(String.self, forKey: .smallUrl)
        }
    }

    init(from decoder: Decoder) throws {
        let mapper = try decoder.container(keyedBy: CodingKeys.self)
        title = try mapper.decode(String.self, forKey: .title)

        detail = try mapper.decode(String.self, forKey: .detail)

        let shortURL = try mapper.decodeIfPresent(Image.self, forKey: .imageURL).map { $0.smallUrl }
        imageURL = shortURL.flatMap { "https://meduza.io/api/v3" + $0 }

        let tags = try mapper.decodeIfPresent([String: String].self, forKey: .tag).getOrElse([:])

        tag = tags["name"]?.uppercased()

        description = try mapper.decodeIfPresent(String.self, forKey: .description)

        let date = try mapper.decode(String.self, forKey: .publishDate)

        publishDate = DateFormatter.publish.date(from: date)!

        id = try mapper.decode(String.self, forKey: .id)
    }
}

class NewsListServiceBuilder {
    func build() -> Future<[News]> {
        return TransformJsonTo<NewsListResponse>()
                .andThen(NetworkDataService())
                .apply(request: URLRequest(url: URL(string: "https://meduza.io/api/v3/search?chrono=articles&locale=ru&page=0&per_page=24")!))
                .map { $0.documents.map { $0.value } }
    }
}
