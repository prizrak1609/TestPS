//
//  Server.swift
//  TestPS
//
//  Created by Dima Gubatenko on 22.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ServerDelegate : class {
    func error(_: Error)
}

final class Server {
    private let baseURL = "http://www.recipepuppy.com/api/"
    private let dataBase = Database()

    weak var delegate: ServerDelegate!

    init(delegate: ServerDelegate) {
        self.delegate = delegate
        if case .failure(let error) = dataBase.openOrCreate() {
            delegate.error(error)
        }
    }

    func getReceipts(text: String = "", _ completion: @escaping (Result<[RecipeModel]>) -> Void) {
        completion(dataBase.getAllReceipes())
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: NSLocalizedString("Can't create URL from \(baseURL)", comment: ""), code: 0, userInfo: nil)))
            return
        }
        let parameters: Parameters
        let searchText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if searchText.isEmpty {
            parameters = ["i" : "onions,garlic", "q" : "omelet", "p" : "3"]
        } else {
            parameters = ["q" : text]
        }
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let welf = self else { return }
            let result = welf.parseJSON(from: response)
            if case .failure(let error) = result {
                completion(.failure(error))
                return
            }
            if case .success(let json) = result {
                let resultArray = json["results"].arrayValue.map { jsonElement -> RecipeModel in
                    var model = RecipeModel()
                    model.title = jsonElement["title"].stringValue
                    model.thumbnail = jsonElement["thumbnail"].stringValue
                    model.siteURLPath = jsonElement["href"].stringValue
                    model.ingredients = jsonElement["ingredients"].stringValue
                    return model
                }
                let resultDelete = welf.dataBase.deleteReceipes()
                if case .failure(let error) = resultDelete {
                    completion(.failure(error))
                }
                if case .success(_) = resultDelete, case .failure(let error) = welf.dataBase.create(recipes: resultArray) {
                    completion(.failure(error))
                }
                completion(.success(resultArray))
            }
        }
    }

    private func parseJSON(from response: DataResponse<Any>) -> Result<JSON> {
        if let error = response.error ?? response.result.error {
            return .failure(NSError(domain: error.localizedDescription, code: 0, userInfo: nil))
        }
        if let json = response.result.value {
            return .success(JSON(json))
        } else {
            return .failure(NSError(domain: NSLocalizedString("Can't get response value", comment: "Server parseJSON func"), code: 0, userInfo: nil))
        }
    }
}
