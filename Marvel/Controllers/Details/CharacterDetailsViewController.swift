//
//  CharacterDetailsViewController.swift
//  Marvel
//
//  Created by Mohamed Osama on 31/12/2023.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    private let viewModel: DetailsViewModel
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var galleryView = GalleryView.loadFromXib()
    private lazy var infoView = DetailsInfoView.loadFromXib()
    private lazy var sectionedItemsView = SectionedItemsView.loadFromXib()

    @IBOutlet weak var containerStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sectionedItemsView.updateCollectionHeight()
    }

    private func setupViews() {
        setupNavigationBar()

        containerStackView.addArrangedSubview(galleryView)
        containerStackView.addArrangedSubview(infoView)
        containerStackView.addArrangedSubview(sectionedItemsView)

        galleryView.configure(image: viewModel.thumbnail)
        infoView.configure(name: viewModel.name, description: viewModel.description)
        sectionedItemsView.set(comics: viewModel.comics,
                               series: viewModel.series,
                               events: viewModel.events,
                               stories: viewModel.stories,
                               links: viewModel.links)
    }

    private func setupNavigationBar() {
        let backImage = UIImage(named: "icn-nav-back-white")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
}
