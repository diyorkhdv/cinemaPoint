//
//  MovieDetailsViewController.swift
//  CinemaPoint
//
//  Created by diyor on 15/10/25.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    private let viewModel: MovieDetailsViewModel
    weak var coordinator: MoviesCoordinator?

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let similarLabel = UILabel()
    private var similarCollection: UICollectionView!
    
    private let reviewsLabel = UILabel()
    private var reviewsStack = UIStackView()

    // MARK: - Init
    init(viewModel: MovieDetailsViewModel, coordinator: MoviesCoordinator?) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configure()
        setupSimilarSection()

        // Similar
        viewModel.fetchSimilar { [weak self] in
            self?.similarCollection.reloadData()
        }
    }

    // MARK: - Setup UI
    private func setupLayout() {
        view.backgroundColor = Theme.background

        // ScrollView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // ContentView
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Poster
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 12
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        // Title
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Theme.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Overview
        overviewLabel.font = .systemFont(ofSize: 16)
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = Theme.textPrimary.withAlphaComponent(0.8)
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false

        // Favorite button
        favoriteButton.layer.cornerRadius = 12
        favoriteButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            overviewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }

    private func setupSimilarSection() {
        similarLabel.text = "Similar Movies"
        similarLabel.font = .boldSystemFont(ofSize: 20)
        similarLabel.textColor = Theme.textPrimary
        similarLabel.translatesAutoresizingMaskIntoConstraints = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 120, height: 190)

        similarCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        similarCollection.backgroundColor = .clear
        similarCollection.showsHorizontalScrollIndicator = false
        similarCollection.dataSource = self
        similarCollection.delegate = self
        similarCollection.register(MovieCollectionViewCell.self,
                                   forCellWithReuseIdentifier: MovieCollectionViewCell.reuseID)
        similarCollection.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(similarLabel)
        contentView.addSubview(similarCollection)

        NSLayoutConstraint.activate([
            similarLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            similarLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            similarCollection.topAnchor.constraint(equalTo: similarLabel.bottomAnchor, constant: 10),
            similarCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            similarCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            similarCollection.heightAnchor.constraint(equalToConstant: 210),

            favoriteButton.topAnchor.constraint(equalTo: similarCollection.bottomAnchor, constant: 24),
            favoriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 220),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - Configure
    private func configure() {
        titleLabel.text = viewModel.movie.title
        overviewLabel.text = viewModel.movie.overview

        if let path = viewModel.movie.posterPath {
            let urlString = "https://image.tmdb.org/t/p/w500\(path)"
            if let url = URL(string: urlString) {
                ImageLoader.shared.loadImage(from: url) { [weak self] image in
                    self?.posterImageView.image = image
                }
            }
        }

        updateFavoriteButton()
    }

    private func updateFavoriteButton() {
        let isFav = FavoritesManager.shared.isFavorite(id: viewModel.movie.id)
        let title = isFav ? "Remove from Favorites" : "Add to Favorites"
        favoriteButton.setTitle(title, for: .normal)
        favoriteButton.backgroundColor = isFav
            ? Theme.accent.withAlphaComponent(0.6)
            : Theme.accent
        favoriteButton.setTitleColor(.white, for: .normal)
        titleLabel.textColor = Theme.textPrimary
        overviewLabel.textColor = Theme.textPrimary.withAlphaComponent(0.8)
    }

    // MARK: - Actions
    @objc private func favoriteTapped() {
        let isFav = FavoritesManager.shared.isFavorite(id: viewModel.movie.id)
        if isFav {
            FavoritesManager.shared.removeFromFavorites(id: viewModel.movie.id)
            Toast.show(message: "Removed from Favorites", in: view)
        } else {
            FavoritesManager.shared.addToFavorites(movie: viewModel.movie)
            Toast.show(message: "Added to Favorites", in: view)
        }
        updateFavoriteButton()
    }
}

// MARK: - Similar Movies
extension MovieDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.similarMovies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCollectionViewCell.reuseID,
            for: indexPath
        ) as! MovieCollectionViewCell
        let movie = viewModel.similarMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.similarMovies[indexPath.row]
        coordinator?.showMovieDetails(for: movie)
    }
}
