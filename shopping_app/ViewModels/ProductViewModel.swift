//
//  ProductViewModel.swift
//  shopping_app
//
//  Created by Evghenia Moroz on 10/15/20.
//

import Foundation
class ProductViewModel {
    var resultModel:Products?
    var products = [Product]()
    
    func fetchData(request: RequestModel, loadMore: Bool, completion: @escaping (Error?) -> Void) {
        guard !ServiceManager.shared.isRunning else {
            return
        }
        ServiceManager.shared.fetchData(params: request) {[weak self] (result) in
            switch result {
            case .success(let model):
                self?.resultModel = model
                if let products = model?.products {
                    if loadMore {
                        self?.products.append(contentsOf: products)
                    } else {
                        self?.products = products
                    }
                    self?.resultModel?.products = self?.products ?? []
                }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func shouldLoadMore() -> Bool {
        if let model = resultModel {
            if model.currentPage + 1 <= model.pageCount {
                return true
            }
        }
        return false
    }
    
    func deleteProducts() {
        resultModel = nil
    }
}

