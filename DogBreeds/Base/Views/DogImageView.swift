//
//  DogImageView.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

class DogImageView: UIView {
    // MARK: UI
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: .regular)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = CGRect(x: 0, y: 0, width: 500, height: 125)
        view.addSubview(blurredEffectView)
        return view
    }()
    
    private lazy var dogBreedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.textColorDarkBg
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var favorieButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .white
        button.addGestureRecognizer(
            CustomTapGestureRecognizer(target: self, action: #selector(didTapFavorite))
        )
        return button
    }()
    
    private weak var delegate: DogImagesFavoriteDelegate?
    private var imageItem: ImageItem?
    
    private var isFavorite: Bool {
        imageItem?.isFavorite ?? false
    }

    // MARK: Configure
    func configure(
        imageItem: ImageItem,
        showLabel: Bool,
        delegate: DogImagesFavoriteDelegate
    ) {
        self.delegate = delegate
        self.imageItem = imageItem
        
        favorieButton.setImage(isFavorite ? Assets.heartFill : Assets.heart, for: .normal)
        favorieButton.imageView?.tintColor = isFavorite ? .red : .white
        
        addSubview(imageView)
        addSubview(favorieButton)
        imageView.addSubview(blurView)
        
        imageView.image = imageItem.image
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            blurView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            favorieButton.heightAnchor.constraint(equalToConstant: 45),
            favorieButton.widthAnchor.constraint(equalToConstant: 45),
            favorieButton.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 5),
            favorieButton.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -5),
        ])
        
        if showLabel {
            dogBreedLabel.text = imageItem.dog.breed.capitalized
            blurView.addSubview(dogBreedLabel)
            NSLayoutConstraint.activate([
                dogBreedLabel.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
                dogBreedLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 15),
                
                favorieButton.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -15),
            ])
        } else {
            setupDoubleTapGesture()
            NSLayoutConstraint.activate([
                favorieButton.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            ])
        }
    }
    
    func setupDoubleTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapFavorite))
        tap.numberOfTapsRequired = 2
        addGestureRecognizer(tap)
    }
    
    @objc func didTapFavorite() {
        guard let imageItem else { return }
        imageItem.isFavorite.toggle()
        favorieButton.imageView?.image = isFavorite ? Assets.heartFill : Assets.heart
        favorieButton.imageView?.tintColor = isFavorite ? .red : .white
        layoutSubviews()
        delegate?.didTapFavorite(imageItem)
    }
}
