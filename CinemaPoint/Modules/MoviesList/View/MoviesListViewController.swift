//
//  MoviesListViewController.swift
//  CinemaPoint
//
//  Created by diyor on 15/10/25.
//

import UIKit

final class MoviesListViewController: UIViewController {
    private let viewModel: MoviesListViewModel
    private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    private let loader = UIActivityIndicatorView(style: .large)

    private let searchController = UISearchController(searchResultsController: nil)
    private var searchWorkItem: DispatchWorkItem?

    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureSearch()
        showLoader()
        viewModel.resetToPopular { [weak self] in
            self?.hideLoader()
            self?.collectionView.reloadData()
            self?.animateCells()
        }
    }

    private func setupUI() {
        title = "CinemaPoint"
        view.backgroundColor = .systemBackground

        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        let cellWidth = (UIScreen.main.bounds.width - spacing * 3) / 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.6)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieCollectionViewCell.reuseID)

        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl

        loader.hidesWhenStopped = true
        view.addSubview(collectionView)
        view.addSubview(loader)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func configureSearch() {
        searchController.searchBar.placeholder = "Search movies"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true

        searchController.searchBar.delegate = self
    }

    @objc private func refreshData() {
        viewModel.resetToPopular { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
        searchController.searchBar.text = nil
    }

    private func showLoader() {
        loader.startAnimating()
        collectionView.isHidden = true
    }
    private func hideLoader() {
        loader.stopAnimating()
        collectionView.isHidden = false
    }

    private func animateCells() {
        let cells = collectionView.visibleCells
        let h = collectionView.bounds.size.height
        for c in cells { c.transform = CGAffineTransform(translationX: 0, y: h) }
        for (i, c) in cells.enumerated() {
            UIView.animate(withDuration: 0.7, delay: 0.05 * Double(i),
                           usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5,
                           options: .curveEaseInOut) { c.transform = .identity }
        }
    }
}

// MARK: - DataSource/Delegate + Infinite Scroll
extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCollectionViewCell.reuseID,
            for: indexPath
        ) as! MovieCollectionViewCell
        cell.configure(with: viewModel.movies[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.coordinator?.showMovieDetails(for: viewModel.movies[indexPath.item])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentH = scrollView.contentSize.height
        let frameH = scrollView.frame.size.height
        if offsetY > contentH - frameH * 1.5 {
            viewModel.fetchNextPage { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UISearchBarDelegate (debounce)
extension MoviesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWorkItem?.cancel()
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            if text.isEmpty {
                self.viewModel.resetToPopular {
                    self.collectionView.reloadData()
                }
            } else {
                self.viewModel.startSearch(query: text) {
                    self.collectionView.reloadData()
                }
            }
        }
        searchWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: work) // 350 мс
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.resetToPopular { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        viewModel.startSearch(query: text) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
