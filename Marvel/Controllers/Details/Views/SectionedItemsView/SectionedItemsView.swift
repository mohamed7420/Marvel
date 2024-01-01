//
//  SectionedItemsView.swift
//  Marvel
//
//  Created by Mohamed Osama on 31/12/2023.
//

import UIKit

class SectionedItemsView: UIView {
    enum Section {
        case comics
        case series
        case stories
        case events
        case links
    }

    enum Item: Hashable, Equatable {
        case comic(ComicsItem)
        case series(ComicsItem)
        case story(StoriesItem)
        case event(ComicsItem)
        case links(URLElement)
        static func == (lhs: SectionedItemsView.Item, rhs: SectionedItemsView.Item) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }

    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!

    var comics: [ComicsItem] = []
    var series: [ComicsItem] = []
    var events: [ComicsItem] = []
    var stories: [StoriesItem] = []
    var links: [URLElement] = []

    private var datasource : UICollectionViewDiffableDataSource<Section, Item>?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionDataSource()
    }

    public func set(
        comics: [ComicsItem],
        series: [ComicsItem],
        events: [ComicsItem],
        stories: [StoriesItem],
        links: [URLElement]
    ) {
        self.comics = comics
        self.series = series
        self.events = events
        self.stories = stories
        self.links = links
        populateCollectionView()
    }

    public func updateCollectionHeight() {
//        heightConstraints.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
//        self.layoutIfNeeded()
    }

    private func setupCollectionDataSource() {
        ItemCVCell.register(collectionView: collectionView)
        URLElementCVCell.register(collectionView: collectionView)
        collectionView.register(ItemsHeaderView.self, forSupplementaryViewOfKind: "\(ItemsHeaderView.self)", withReuseIdentifier: "\(ItemsHeaderView.self)")
        collectionView.collectionViewLayout = generateCollectionLayout()

        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .comic(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCVCell.identifier, for: indexPath) as! ItemCVCell
                cell.configure(title: item.name, image: item.resourceURI)
                return cell
            case .series(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCVCell.identifier, for: indexPath) as! ItemCVCell
                cell.configure(title: item.name, image: item.resourceURI)
                return cell
            case .event(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCVCell.identifier, for: indexPath) as! ItemCVCell
                cell.configure(title: item.name, image: item.resourceURI)
                return cell
            case .story(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCVCell.identifier, for: indexPath) as! ItemCVCell
                cell.configure(title: item.name, image: item.resourceURI ?? "")
                return cell
            case .links(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: URLElementCVCell.identifier, for: indexPath) as! URLElementCVCell
                cell.titleLabel.text = item.type.capitalized
                cell.action = { [weak self] in
                    guard let self else { return }
                }
                return cell
            }
        })

        datasource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: "\(ItemsHeaderView.self)", withReuseIdentifier: "\(ItemsHeaderView.self)", for: indexPath) as! ItemsHeaderView
            let section = self.datasource?.snapshot().sectionIdentifiers[indexPath.section]
            if section == .comics {
                headerView.set(title: "comics".uppercased())
            } else if section == .series {
                headerView.set(title: "series".uppercased())
            } else if section == .stories {
                headerView.set(title: "stories".uppercased())
            } else if section == .events {
                headerView.set(title: "events".uppercased())
            } else {
                headerView.set(title: "related links".uppercased())
            }
            return headerView
        }
    }

    private func populateCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.comics, .series, .events, .stories, .links])
        let comicsItems: [Item] = comics.map { .comic($0) }
        snapshot.appendItems(comicsItems, toSection: .comics)

        let serieItems: [Item] = series.map { .series($0) }
        snapshot.appendItems(serieItems, toSection: .series)

        let eventItems: [Item] = events.map { .comic($0) }
        snapshot.appendItems(eventItems, toSection: .events)

        let storiesItems: [Item] = stories.map { .story($0) }
       snapshot.appendItems(storiesItems, toSection: .stories)

        let linksItems: [Item] = links.map { .links($0) }
        snapshot.appendItems(linksItems, toSection: .links)
        datasource?.apply(snapshot, animatingDifferences: true)
    }

    private func generateCollectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (section, env) -> NSCollectionLayoutSection? in
            guard let self, let section = datasource?.snapshot().sectionIdentifiers[section] else { return nil }
            
            switch section {
            case .comics, .events, .series, .stories:
                return itemCollectionViewSection()
            case .links:
                return URLElementCollectionViewSection()
            }
        }
    }

    private func itemCollectionViewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .absolute(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 6, bottom: 0, trailing: 6)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.top = 10
        group.contentInsets.bottom = 10

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [headerViewSupplmentaryView()]
        return section
    }

    private func URLElementCollectionViewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerViewSupplmentaryView()]
        return section
    }

    private func headerViewSupplmentaryView() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerViewSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerViewSize, elementKind: "\(ItemsHeaderView.self)", alignment: .top)
    }
}

