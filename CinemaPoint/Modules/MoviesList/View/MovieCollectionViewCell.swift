//
//  MovieCollectionViewCell.swift
//  CinemaPoint
//
//  Created by diyor on 15/10/25.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    static let reuseID = "MovieCollectionViewCell"

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
//    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
//        gradientLayer.frame = posterImageView.bounds
    }

    // MARK: - UI Setup
    private func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.15
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 8

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 12

//        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
//        gradientLayer.locations = [0.5, 1.0]
//        posterImageView.layer.addSublayer(gradientLayer)

        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2

        ratingLabel.font = .systemFont(ofSize: 12, weight: .medium)
        ratingLabel.textColor = .systemYellow

        contentView.addSubview(posterImageView)
        posterImageView.addSubview(titleLabel)
        posterImageView.addSubview(ratingLabel)

        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -8),

            ratingLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 8),
            ratingLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -4)
        ])
        contentView.backgroundColor = Theme.background
        titleLabel.textColor = Theme.textPrimary
        layer.shadowColor = Theme.shadow.cgColor
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        ratingLabel.text = "⭐️ \(String(format: "%.1f", movie.voteAverage))"

        if let path = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            ImageLoader.shared.loadImage(from: url) { [weak self] image in
                self?.posterImageView.image = image
            }
        } else {
            posterImageView.image = UIImage(systemName: "film")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
}
