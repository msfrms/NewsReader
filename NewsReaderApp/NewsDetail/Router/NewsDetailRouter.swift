//
// Created by Radaev Mikhail on 2019-08-13.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation
import SafariServices.SFSafariViewController

public protocol NewsDetailRouter {
    func goDetail(with newsID: String)
}

public class SafariBrowserRouter: NewsDetailRouter {

    public weak var fromViewController: UIViewController?

    public func goDetail(with newsID: String) {
        let web = SFSafariViewController(url: URL(string: "https://meduza.io/" + newsID)!)
        fromViewController?.present(web, animated: true)
    }
}

public class NewsRouter: NewsDetailRouter {

    public weak var fromViewController: UIViewController?

    public func goDetail(with newsID: String) {
        fromViewController?.navigationController?.pushViewController(NewsDetailFactory().create(with: newsID), animated: true)
    }
}