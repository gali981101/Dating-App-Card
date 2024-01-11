//
//  DateViewController.swift
//  DateCard
//
//  Created by Terry Jason on 2024/1/11.
//

import UIKit

class DatingViewController: UIViewController {
    
    private var girls = (1...9).map { Dating(featuredImage: UIImage(named: "img-\($0)")) }
    
    lazy var dataSource = configureDataSource()
    
    // MARK: - Section
    
    enum Section {
        case all
    }
    
    // MARK: - @IBOulet
    
    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
}

// MARK: - Life Cycle

extension DatingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImageView.image = UIImage(named: "bg")
        
        let blurEffect = UIBlurEffect(style: .light)
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        bgImageView.addSubview(blurEffectView)
        
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .clear
        
        updateSnapshot()
    }
    
}

// MARK: - Override Methods

extension DatingViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

// MARK: - LayOut

extension DatingViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

// MARK: - Diffable Data Source

extension DatingViewController {
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, Dating> {
        
        let dataSource = UICollectionViewDiffableDataSource<Section, Dating>(collectionView: collectionView) { collectionView, indexPath, imageName in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DatingCollectionViewCell
            
            cell.delegate = self
            cell.layer.cornerRadius = 10.0
            
            guard let girl = self.dataSource.itemIdentifier(for: indexPath) else { fatalError() }
            
            cell.imageView.image = girl.featuredImage
            cell.isLiked = girl.isLiked
            
            return cell
        }
        
        return dataSource
        
    }
    
    private func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Dating>()
        snapshot.appendSections([.all])
        snapshot.appendItems(girls, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    
}

// MARK: - TripCollectionCellDelegate

extension DatingViewController: DatingCollectionCellDelegate {
    
    func didLikeButtonPressed(cell: DatingCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        girls[indexPath.row].isLiked = girls[indexPath.row].isLiked ? false : true
        // cell.isLiked = girls[indexPath.row].isLiked
        updateSnapshot()
    }
    
}
