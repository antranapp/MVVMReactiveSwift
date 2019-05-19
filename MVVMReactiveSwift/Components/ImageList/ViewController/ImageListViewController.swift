//
//  Copyright © 2019 An Tran. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import Kingfisher
import UIKit

class ImageListViewController: ViewController {

    // MARK: Properties

    // Public

    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    // Private

    private var activityIndicator: UIActivityIndicatorView!

    // MARK: Setup ViewModel

    lazy var viewModel = ImageListViewModel(service: context.pixelBayService)

    // MARK: Lifecyles

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        activityIndicator = UIActivityIndicatorView(style: .gray)
        let rightButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = rightButton

        // UI Binding
        viewModel.searchTerm <~ searchTermTextField.reactive.continuousTextValues

        // Observe Property
        viewModel.imageList.signal.observeValues { [unowned self] _ in
            self.tableView.reloadData()
        }

        // Observe Signal
        viewModel.activity.output.observe { [unowned self] event in
            guard let value = event.value else {
                return
            }

            DispatchQueue.main.async {
                value ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
        }

        tableView.register(UINib(nibName: "ImageListTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageListTableViewCell")

        title = "List"
    }
}

extension ImageListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.imageList.value.hits.count
    }
}

extension ImageListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ImageListTableViewCell") as! ImageListTableViewCell

        let imageItem = viewModel.imageList.value.hits[indexPath.row]
        cell.titleLabel?.text = imageItem.previewURL
        guard let url = URL(string: imageItem.previewURL) else {
            return cell
        }

        cell.previewImageView.kf.setImage(with: url)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageItem = viewModel.imageList.value.hits[indexPath.row]
        let detailViewController = ImageDetailViewController(context: context, image: imageItem)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
