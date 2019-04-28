//
//  Copyright © 2019 An Tran. All rights reserved.
//

class ImageListViewModel: ViewModel {

    func fetchImage(searchTerm: String) {
        pixelBayService.fetch(searchTerm: searchTerm).done { imageList in
            print(imageList)
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
