//
//  FavoritesViewController.swift
//  CinemaPoint
//
//  Created by diyor on 16/10/25.
//

import UIKit

final class FavoritesViewController: UIViewController {
    private let viewModel: FavoritesViewModel
    private var collectionView: UICollectionView!
    private var emptyStateView: EmptyStateView?
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchFavorites()
        addSwipeGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }

    private func setupUI() {
        title = "Favorites"
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieCollectionViewCell.reuseID)

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchFavorites() {
        viewModel.fetchFavorites { [weak self] in
            guard let self else { return }
            let isEmpty = self.viewModel.favoriteMovies.isEmpty
            self.emptyStateView?.removeFromSuperview()
            if isEmpty {
                let emptyView = EmptyStateView(
                    image: UIImage(systemName: "star"),
                    title: "No favorites yet",
                    subtitle: "Add movies to your favorites to see them here."
                )
                self.view.addSubview(emptyView)
                emptyView.frame = self.view.bounds
                self.emptyStateView = emptyView
            } else {
                self.emptyStateView?.removeFromSuperview()
            }
            self.collectionView.reloadData()
        }
    }
    private func addSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction = .left
        collectionView.addGestureRecognizer(swipeGesture)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }

        let movie = viewModel.favoriteMovies[indexPath.row]
        
        let alert = UIAlertController(
            title: "Delete from Favorites?",
            message: movie.title,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.removeMovie(at: indexPath.row) {
                self.collectionView.deleteItems(at: [indexPath])
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favoriteMovies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCollectionViewCell.reuseID,
            for: indexPath
        ) as! MovieCollectionViewCell

        let favMovie = viewModel.favoriteMovies[indexPath.row]
        let movie = Movie(
            id: Int(favMovie.id),
            title: favMovie.title ?? "Untitled",
            overview: favMovie.overview ?? "",
            posterPath: favMovie.posterPath,
            voteAverage: favMovie.voteAverage
        )

        cell.configure(with: movie)
        return cell
    }
}
