//
//  CharacterListViewController.swift
//  Marvel
//
//  Created by Mohamed Osama on 28/12/2023.
//

import UIKit
import RxSwift
import RxRelay
import RxDataSources

class CharacterListViewController: UIViewController {

    private let viewModel = CharacterListViewModel()
    private let bag = DisposeBag()
    typealias Section = AnimatableSectionModel<String, Result>

    private lazy var shimmerView = CharacterShimmerView.loadFromXib()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerStackView: UIStackView!
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        setupNavigationBarView()
        loadAllCharacters()
        setupViewsBinding()
        setupCollectionViewDataSource()
    }

    private func setupViewsBinding() {
        containerStackView.addArrangedSubview(shimmerView)
        Observable.combineLatest(viewModel.resultBehaviorRelay, viewModel.isLoadingBehavior)
            .observe(on: MainScheduler.instance)
            .bind { [weak self] results, isLoading in
                guard let self else { return }
                if !isLoading {
                    shimmerView.isHidden = true
                    collectionView.isHidden = false
                } else {
                    shimmerView.isHidden = !results.isEmpty
                    collectionView.isHidden = results.isEmpty
                }
            }.disposed(by: bag)
    }

    private func setupNavigationBarView() {
        let imageView = UIImageView(image: UIImage(named: "icn-nav-marvel"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView

        let image = UIImage(named: "icn-nav-search")
        let rightBarButton = UIBarButtonItem(image: image?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(openSearchController))
        navigationItem.rightBarButtonItem = rightBarButton
    }

    private func loadAllCharacters() {
        Task {
             await viewModel.loadAllCharacters()
        }
    }

    @objc private func openSearchController() {
        let vc = SearchViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        
        present(nav, animated: true)
    }

    private func setupCollectionViewDataSource() {
        collectionView.collectionViewLayout = generateCollectionViewLayout()
        CharacterCVCell.register(collectionView: collectionView)

        let dataSource = RxCollectionViewSectionedAnimatedDataSource<Section>(animationConfiguration: .init(insertAnimation: .right)) { [unowned self] in
            self.configureCell(dataSource: $0, collectionView: $1, indexPath: $2, model: $3)
        }

        viewModel.resultBehaviorRelay
            .observe(on: MainScheduler.instance)
            .map {
                [Section(model: "", items: $0)]
            }.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        collectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self else { return }
                let results = viewModel.resultBehaviorRelay.value
                let result = results[indexPath.row]
                let detailsVM = DetailsViewModel(result: result)
                let vc = CharacterDetailsViewController(viewModel: detailsVM)
                show(vc, sender: nil)
            }.disposed(by: bag)

        collectionView.rx.willDisplayCell.map {
            $1
        }.withLatestFrom(viewModel.resultBehaviorRelay) {
            ($0, $1)
        }.filter {
            $1.count - 1 == $0.row
        }.bind { [weak self] _, _ in
            guard let self else { return }
            Task {
                await self.viewModel.loadMoreCharacters()
            }
        }.disposed(by: bag)
    }

    private func configureCell(
        dataSource: CollectionViewSectionedDataSource<Section>,
        collectionView: UICollectionView,
        indexPath: IndexPath,
        model: Result
    )  -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CharacterCVCell.self), for: indexPath) as! CharacterCVCell

        let viewModel = CharacterCellViewModel(result: model)
        cell.configure(viewModel)
        
        return cell
    }

    private func generateCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemsSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/4))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }
}
