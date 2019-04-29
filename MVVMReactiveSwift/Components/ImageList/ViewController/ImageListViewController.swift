//
//  Copyright © 2019 An Tran. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
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
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        }

        let imageItem = viewModel.imageList.value.hits[indexPath.row]
        cell.textLabel?.text = imageItem.previewURL

        return cell
    }
}
