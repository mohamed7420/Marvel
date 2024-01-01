//
//  SearchViewController.swift
//  Marvel
//
//  Created by Mohamed Osama on 31/12/2023.
//

import UIKit
import RxSwift
import RxDataSources

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerStackView: UIStackView!
    
    private lazy var shimmerView = SearchShimmerView.loadFromXib()
    typealias Section = AnimatableSectionModel<String, Result>
    private let viewModel = SearchViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchView()
        setupViewsBinding()
        setupCollectionViewDataSource()
        setupSearchBinding()
    }

    private func setupSearchView() {
        searchTextField.becomeFirstResponder()
        searchStackView.layer.cornerRadius = 8.0
        searchStackView.clipsToBounds = true
    }

    private func setupSearchBinding() {
        searchTextField.rx
            .text.orEmpty
            .filter { !$0.isEmpty }
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] text in
                guard let self else { return }
                Task {
                    await self.viewModel.loadAllCharacters(text: text)
                }
            }.disposed(by: bag)
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

    private func setupCollectionViewDataSource() {
        collectionView.collectionViewLayout = generateCollectionViewLayout()
        SearchCVCell.register(collectionView: collectionView)

        let dataSource = RxCollectionViewSectionedAnimatedDataSource<Section>(animationConfiguration: .init(insertAnimation: .right)) { [unowned self] in
            self.configureCell(dataSource: $0, collectionView: $1, indexPath: $2, model: $3)
        }

        viewModel.resultBehaviorRelay
            .observe(on: MainScheduler.instance)
            .map {
                [Section(model: "", items: $0)]
            }.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }

    private func configureCell(
        dataSource: CollectionViewSectionedDataSource<Section>,
        collectionView: UICollectionView,
        indexPath: IndexPath,
        model: Result
    )  -> SearchCVCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCVCell.identifier, for: indexPath) as! SearchCVCell

        let viewModel = SearchCellViewModel(result: model)
        cell.configure(viewModel: viewModel)

        return cell
    }


    private func generateCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(75))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

