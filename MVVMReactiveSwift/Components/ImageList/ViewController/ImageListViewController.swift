//
//  Copyright © 2019 An Tran. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import Kingfisher
import UIKit

class ImageListViewController: ViewController {

    // MARK: Properties

    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    // MARK: Setup ViewModel

    lazy var viewModel = ImageListViewModel(service: context.pixelBayService)

    // MARK: Setup

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        viewModel.searchTerm <~ searchTermTextField.reactive.continuousTextValues

        viewModel.imageList.signal.observeValues { [unowned self] _ in
            self.tableView.reloadData()
        }

        tableView.register(UINib(nibName: "ImageListTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageListTableViewCell")

        viewModel.searchTerm.value = "flower"
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
}
