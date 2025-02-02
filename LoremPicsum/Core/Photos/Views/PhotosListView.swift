//
//  PhotosListView.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 24/06/24.
//

import UIKit

protocol PhotosListViewDelegate: AnyObject {
    func didSelect(_ photo: Photo, isChecked: Bool)
}

class PhotosListView: UIView {
    
    // MARK: - Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        return tableView
    }()
    
    private lazy var emptyTableViewLabel: UILabel = {
        let label = UILabel()
        label.text = "No photos to display. Pull to refresh"
        label.textColor = .secondaryText
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Properties
    
    private let viewModel: ViewModel
    weak var delegate: PhotosListViewDelegate?
    
    // MARK: - Init
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupView()
        bindViewModel()
        viewModel.fetchInitialPhotos()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension PhotosListView {
    private func setupView() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onPhotosUpdate = { [weak self] type in
            guard let self else { return }
            
            switch type {
            case .reload:
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            case .newRows(let indexPaths):
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            guard let self else { return }
            
            switch (isLoading, viewModel.photos.isEmpty) {
            case (true, true):
                self.tableView.backgroundView = self.makeTableViewLoadingIndicator()
            case (true, false):
                self.tableView.tableFooterView = self.makeTableViewLoadingFooter()
            case (false, true):
                self.tableView.backgroundView = emptyTableViewLabel
            case (false, false):
                self.tableView.backgroundView = nil
                self.tableView.tableFooterView = nil
            }
        }
    }
    
    @objc
    private func refresh() {
        viewModel.refresh()
    }
    
    /// Returns a view with an activity indicator at its center
    private func makeTableViewLoadingFooter() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        
        view.addSubview(activityIndicator)
        
        return view
    }
    
    /// Returns a spinning activity indicator
    private func makeTableViewLoadingIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        
        return activityIndicator
    }
    
    /// Determines if the scroll view should paginate based on its scroll position
    private func shouldPaginate(_ scrollView: UIScrollView) -> Bool {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        let threshold = (height / 2)
        
        return offsetY > contentHeight - height - threshold
    }
}

// MARK: - UITableViewDataSource

extension PhotosListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.reuseIdentifier) as? PhotoTableViewCell else {
            fatalError("Failed to dequeue cell: \(PhotoTableViewCell.reuseIdentifier)")
        }
        
        cell.configure(with: viewModel.viewModel(for: indexPath))
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PhotosListView: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldPaginate(scrollView) {
            viewModel.loadMorePhotos()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModel.viewModel(for: indexPath)
        delegate?.didSelect(viewModel.photo, isChecked: viewModel.isChecked)
    }
}
