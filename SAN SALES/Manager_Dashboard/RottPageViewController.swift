//
//  RottPageViewController.swift
//  SAN SALES
//
//  Created by San eforce on 30/11/23.
//

import UIKit

class RottPageViewController: UIPageViewController, UIPageViewControllerDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    var titles = ["Attendance", "Summary", "Performance", "Location", "Coverage"]
    lazy var viewControllerList: [UIViewController] = {
        let sb = UIStoryboard(name: "ManagerDashboard", bundle: nil)

        let attendanceVC = sb.instantiateViewController(identifier: "AttendanceVC")
        let summaryVC = sb.instantiateViewController(identifier: "SummaryVC")
        let performanceVC = sb.instantiateViewController(identifier: "PerformanceVC")
        let locationVC = sb.instantiateViewController(identifier: "LocationVC")
        let coverageVC = sb.instantiateViewController(identifier: "CoverageVC")

        return [attendanceVC, summaryVC, performanceVC, locationVC, coverageVC]
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Manager Dashboard"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // Change this line to set the scrolling direction

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TopBarCollectionViewCell.self, forCellWithReuseIdentifier: "TopBarCell")

        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self

        // Add title label and collection view to the view
        self.view.addSubview(titleLabel)
        self.view.addSubview(collectionView)

        // Set up constraints for the title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50) // Adjust the height as needed
        ])

        // Set up constraints for the collection view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 30) // Adjust the height as needed
        ])

        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllerList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopBarCell", for: indexPath) as! TopBarCollectionViewCell
        
        cell.titleLabel.layer.cornerRadius = 10
        cell.titleLabel.clipsToBounds = true
        cell.titleLabel.layer.borderWidth = 1.0
        cell.titleLabel.layer.borderColor = UIColor(red: 0.74, green: 0.76, blue: 0.78, alpha: 1.00).cgColor
        cell.titleLabel.text = titles[indexPath.row]
        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedViewController = viewControllerList[indexPath.item]
        setViewControllers([selectedViewController], direction: .forward, animated: true, completion: nil)
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           // Return the size of each item in your collection view
           return CGSize(width: 50, height: 50)
       }


    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard viewControllerList.count > previousIndex else { return nil }
        return viewControllerList[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else { return nil }
        guard viewControllerList.count > nextIndex else { return nil }
        return viewControllerList[nextIndex]
    }
}



class TopBarCollectionViewCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0 // Allow multiple lines
        label.lineBreakMode = .byWordWrapping // Wrap words to the next line if needed
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    private func setupSubviews() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
