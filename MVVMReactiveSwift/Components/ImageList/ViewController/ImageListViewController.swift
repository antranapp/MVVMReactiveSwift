//
//  Copyright © 2019 An Tran. All rights reserved.
//

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

        viewModel.fetchImage(searchTerm: "sky")
    }
}
