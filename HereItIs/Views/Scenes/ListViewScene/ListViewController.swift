//
//  ListViewController.swift
//  HereItIs
//
//  Created by Pierre Navarre on 27/01/2023.
//

import UIKit

@MainActor
protocol ListViewControllerInput: AnyObject {
    func showLoader(_ isRunning: Bool)
    func showContent(_ model: [AdCellModel])
    func showError(_ model: ErrorViewModel?)  // Remove error view if model == nil
    func presentDetail(for ad: ClassifiedAd, category: String?)
}

final class ListViewController: UICollectionViewController {
    
    private enum Constants {
        static let horizontalInset: CGFloat = 8
        static let minimumInteritemSpacing: CGFloat = 10
        static let minimumCellWidth: CGFloat = 300
    }
    
    // CollectionView sections type
    private enum Section {
        case main
    }
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AdCellModel>
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, AdCellModel>
    
    // MARK: - Properties
    private var interactor: ListViewInteractorInput!
    private var dataSource: DiffableDataSource!
    
    private weak var loarder: UIActivityIndicatorView!
    private var models: [AdCellModel] = []
    
    private weak var errorView: UIView?

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Here It Is!"
        self.navigationItem.backButtonTitle = ""
        self.collectionView.register(AdCell.self, forCellWithReuseIdentifier: AdCell.ReuseIdentifier)
        self.interactor = ListViewInteractor(presenter: ListViewPresenter(viewController: self))
        self.congigureUI()
        self.setDataSource()
        self.collectionView.prefetchDataSource = self
        Task { await self.interactor.loaadData() }
    }

}

// MARK: - Private methods
private extension ListViewController {
    func congigureUI() {
        let loader = UIActivityIndicatorView()
        loader.color = Style.Color.brand.color
        self.view.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        self.loarder = loader
        
        self.collectionView.backgroundColor = UIColor.systemBackground
        
        let flow = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flow?.minimumInteritemSpacing = Constants.minimumInteritemSpacing
    }
    
    func setDataSource() {
        let cellProvider: DiffableDataSource.CellProvider = { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueReusableCell(withReuseIdentifier: AdCell.ReuseIdentifier, for: indexPath)
        }
        self.dataSource = DiffableDataSource(collectionView: self.collectionView, cellProvider: cellProvider)
    }
    
    func displayList(animatingDifferences: Bool) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.models)
        self.dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}

// MARK: - UICollectionViewDelegate
extension ListViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? AdCell else { return }
        cell.update(with: self.models[indexPath.row])
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let adId = self.models[indexPath.row].id
        Task { await self.interactor.didSelectItem(withId: adId) }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0, left: Constants.horizontalInset,
            bottom: 0, right: Constants.horizontalInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let width = collectionView.bounds.width-(inset.left+inset.right)
        let columns = floor(width/Constants.minimumCellWidth)
        
        return CGSize(
            width: (width-(columns-1)*Constants.minimumInteritemSpacing)/columns,
            height: AdCell.cellHeight
        )
    }
    
}

// MARK: - UICollectionViewDataSourcePrefetching
extension ListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let adIds: [Int64] = indexPaths.map { indexPath in
            self.models[indexPath.row].id
        }
        Task { await self.interactor.prefetchItems(withIds: adIds) }
    }
}

// MARK: - ListViewControllerInput
extension ListViewController: ListViewControllerInput {
    func showLoader(_ isRunnng: Bool) {
        if isRunnng { self.loarder.startAnimating() } else { self.loarder.stopAnimating() }
    }
    
    func showContent(_ model: [AdCellModel]) {
        self.models = model
        self.displayList(animatingDifferences: false)
    }
    
    func showError(_ model: ErrorViewModel?) {
        guard let model = model else {
            self.errorView?.removeFromSuperview()
            return
        }
        
        let errorView = ErrorView(frame: self.view.bounds)
        errorView.update(with: model)
        self.view.addSubview(errorView)
        self.errorView = errorView
    }
    
    func presentDetail(for ad: ClassifiedAd, category: String?) {
        let detail = DetailViewController(ad: ad, category: category)
        self.splitViewController?.showDetailViewController(detail, sender: nil)
    }
}
