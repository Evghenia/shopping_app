//
//  SearchProductViewController.swift
//  shopping_app
//
//  Created by Evghenia Moroz on 10/15/20.
//

import UIKit

class SearchProductViewController: UIViewController, UITableViewDelegate {
    
    var productViewModel: ProductViewModel!
    let searchController = UISearchController(searchResultsController: nil)
    var initialPage = 1
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.productViewModel = ProductViewModel()
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier:String(describing: ProductTableViewCell.self))
        createSearchBar()
        
    }
    
    func createSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "What are you looking for?"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func createSpinnerView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func search(requestModel: RequestModel, loadMore: Bool,
                completion: @escaping () -> Void) {
        productViewModel.fetchData(request: requestModel, loadMore: loadMore) { error in
            if let error = error {
                self.showError(error: error)
            } else {
                self.reloadTableView()
            }
            completion()
        }
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension SearchProductViewController: UIScrollViewDelegate {
    
    func isReachedBottom(scrollView: UIScrollView) -> Bool {
        let position = scrollView.contentOffset.y
        if position > tableView.contentSize.height - 100 - scrollView.frame.size.height {
            return true
        }
        return false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let model = productViewModel.resultModel {
            if productViewModel.shouldLoadMore() && self.isReachedBottom(scrollView: scrollView) {
                tableView.tableFooterView = createSpinnerView()
                let requestModel = RequestModel(query: searchController.searchBar.text!, page: model.currentPage + 1)
                self.search(requestModel: requestModel, loadMore: true, completion: {
                    DispatchQueue.main.async {
                        self.tableView.tableFooterView = nil
                    }
                })
            }
        }
    }
}

extension SearchProductViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar.text
        if !isSearchBarEmpty {
            let requestModel = RequestModel(query: searchBar!, page: initialPage)
            self.search(requestModel: requestModel, loadMore: false, completion:{})
        } else {
            productViewModel.deleteProducts()
            self.reloadTableView()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        productViewModel.deleteProducts()
        self.reloadTableView()
    }
}

extension SearchProductViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = productViewModel.resultModel {
            return model.products.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self), for: indexPath) as! ProductTableViewCell
        if let model = productViewModel.resultModel {
            let product = model.products[indexPath.row]
            cell.configure(product: product)
        }
        return cell
    }
}
