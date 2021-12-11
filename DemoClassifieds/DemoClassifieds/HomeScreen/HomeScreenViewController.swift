//
//  ViewController.swift
//  DemoClassifieds
//
//  Created by Aravind on 09/12/2021.
//

import UIKit

class HomeScreenViewController: UICollectionViewController {

    static private let reuseIdentifier = "ItemCell"

    var viewModel: HomeScreenViewModel?
    @IBOutlet private weak var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        collectionView.collectionViewLayout = generateLayout()
        bindViewModel()
        viewModel?.fethItems()
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "What are you looking for?"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func reloadData() {
        self.collectionView.reloadData()
    }
    
    private func reloadItemCell(_ indexPath: IndexPath) {
        self.collectionView.reloadItems(at: [indexPath])
    }

    private func showError(error: NetworkError?) {
        let alert = UIAlertController(title: "Failed", message: "Failed to fetch items", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func bindViewModel() {
        viewModel?.bind(view: self) { [weak self] state in
            guard let strongSelf = self else { return }
            switch state {
            case .itemsFetched:
                strongSelf.spinner.stopAnimating()
                strongSelf.reloadData()
            case .errorFetchingItems(let error):
                strongSelf.showError(error: error)
            case .thumbnailFetched(let indexPath):
                strongSelf.reloadItemCell(indexPath)
            }
        }
    }
}

extension HomeScreenViewController {
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
      ) -> Int {
        let count = viewModel?.displayItems?.count ?? 0
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenViewController.reuseIdentifier, for: indexPath) as! ItemCell
        guard let item = viewModel?.displayItems?[indexPath.row] else {
            return cell
        }
        viewModel?.willShow(item: item, at: indexPath)
        cell.setItem(item: item)
        guard item.cachedThumbnailImages.count == 0 else {
            return cell
        }
        viewModel?.fetchItemThumbnail(item, indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.clickedOnItem(at: indexPath.row)
    }
}

extension HomeScreenViewController {
    func generateLayout() -> UICollectionViewLayout {
        let bigItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        bigItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2)
        
        let smallItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1/2)
            )
        )
        smallItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
        )
        
        let smallItemGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1.0)
            ),
            subitem: smallItem,
            count: 2
        )
        
        let finalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0)
            ),
            subitems: [bigItem, smallItemGroup]
        )
        
        let section = NSCollectionLayoutSection(group: finalGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
        
    }
}

extension HomeScreenViewController: UICollectionViewDataSourcePrefetching {
  func collectionView(_ collectionView: UICollectionView,
      prefetchItemsAt indexPaths: [IndexPath]) {
    
    for indexPath in indexPaths {
        guard let item = viewModel?.displayItems?[indexPath.row] else {
            continue
        }
        guard item.cachedThumbnailImages.count == 0 else {
            continue
        }
        viewModel?.fetchItemThumbnail(item, indexPath, needsReload: false)
    }
  }
}

extension HomeScreenViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.filter(text: searchController.searchBar.text)
    }
}
