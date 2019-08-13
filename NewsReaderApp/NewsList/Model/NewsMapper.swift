//
// Created by Radaev Mikhail on 2019-08-12.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation

extension News: Decodable {

    private enum CodingKeys : String, CodingKey {
        case id = "url"
        case title = "title"
        case detail = "second_title"
        case imageURL = "image"
        case publishDate = "pub_date"
        case tag
        case description
    }

    private struct Image: Decodable {
        enum CodingKeys : String, CodingKey {
            case smallUrl = "small_url"
        }

        let smallUrl: String

        init(from decoder: Decoder) throws {
            let mapper = try decoder.container(keyedBy: CodingKeys.self)
            smallUrl = try mapper.decode(String.self, forKey: .smallUrl)
        }
    }

    public init(from decoder: Decoder) throws {
        let mapper = try decoder.container(keyedBy: CodingKeys.self)
        title = try mapper.decode(String.self, forKey: .title)

        detail = try mapper.decode(String.self, forKey: .detail)

        let shortURL = try mapper.decodeIfPresent(Image.self, forKey: .imageURL).map { $0.smallUrl }
        imageURL = shortURL.flatMap { "https://meduza.io" + $0 }

        let tags = try mapper.decodeIfPresent([String: String].self, forKey: .tag).getOrElse([:])

        tag = tags["name"]?.uppercased()

        description = try mapper.decodeIfPresent(String.self, forKey: .description)

        let date = try mapper.decode(String.self, forKey: .publishDate)

        publishDate = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: date)!
        }()

        id = try mapper.decode(String.self, forKey: .id)
    }
}