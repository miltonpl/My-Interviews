//
//  OrderViewController.swift
//  CheckoutInterview
//
//  Created by Milton Palaguachi on 3/12/24.
//
import Combine
import UIKit

class OrderViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    enum Section: Hashable {
        case items
    }

    let service = CheckoutService()
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "ItemCollectionViewCell")
        return collectionView
    }()
    lazy var dataSource = makeDataSource()

    var subscribers = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(button)
        button.setTitle("Submit", for: .normal)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
        ])
        
        service
            .$order
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { order in
                self.applySnapshot(order: order)
            }
            .store(in: &subscribers)
    
        service.fetchOrder()
    }

    func applySnapshot(order: Order)  {
        var snapshot = Snapshot()
        snapshot.appendSections([.items])
        snapshot.appendItems(order.items, toSection: .items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    var collectionViewLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            
            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize , subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group:  group)
            section.interGroupSpacing = 4
            return section
        }
        return layout
    }

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as? ItemCollectionViewCell else {
                    return UICollectionViewCell()
                }
            cell.configure(title: item.name, subtitle: item.displayPrice ?? "Free")
            return cell
        }
        return dataSource
    }

    @objc
    func didTapButton() {
        service
            .$submit
            .receive(on: DispatchQueue.main)
            .compactMap { $0}
            .first()
            .sink { submit in
                let viewController = PreparingViewController(status: submit.status)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: &subscribers)
        service.submitOrder()
        button.setTitle("Submitting..", for: .normal)
    }
}
