//
//  Copyright © 2019 An Tran. All rights reserved.
//

import ReactiveSwift
import PromiseKit

class ImageListViewModel: ViewModel {

    // MARK: Properties

    var searchTerm = MutableProperty("")
    var imageList = MutableProperty(ImageList(total: 0, totalHits: 0, hits: []))

    // MARK: APIs

    override init(service: ServiceProtocol) {
        super.init(service: service)

        searchTerm.signal.observeValues { [unowned self] value in
            if value.count > 2 {
                self.fetchImage(searchTerm: value)
            }
        }
    }

    func fetchImage(searchTerm: String) {
        pixelBayService.fetch(searchTerm: searchTerm)
            .done { [weak self] imageList in
                self?.imageList.value = imageList
                    }
            .catch { error in
                print(error)
            }
    }
}

extension ImageListViewModel {
    var pixelBayService: PixelBayService {
        return service as! PixelBayService
    }
}
