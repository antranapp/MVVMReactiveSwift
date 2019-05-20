//
//  Copyright © 2019 An Tran. All rights reserved.
//

import ReactiveSwift
import PromiseKit

class ImageListViewModel: ViewModel {

    // MARK: Properties

    var searchTerm = MutableProperty("")
    var imageList = MutableProperty(ImageList(total: 0, totalHits: 0, hits: []))

    let activity = Signal<Bool, Never>.pipe()

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
        activity.input.send(value: true)
        pixelBayService.fetch(searchTerm: searchTerm)
            .done { [weak self] imageList in
                self?.imageList.value = imageList
            }
            .catch { error in
                print(error)
            }.finally {
                self.activity.input.send(value: false)
            }
    }
}

extension ImageListViewModel {
    var pixelBayService: PixelBayService {
        return service as! PixelBayService
    }
}
