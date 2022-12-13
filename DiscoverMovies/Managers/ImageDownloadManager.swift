//
//  ImageDownloadManager.swift
//  DiscoverMovies
//
//  Created by Yunus Tek on 14.12.2022.
//

import Nuke
import UIKit

// MARK: Nuke Image

class ImageDownloadManager {

    private enum Constant {

        static let dataCacheKey = "Nuke"
    }

    // MARK: Variables

    static let shared = ImageDownloadManager()

    private var pipeline: ImagePipeline {

        return ImagePipeline {

            $0.isTaskCoalescingEnabled = false
            $0.isProgressiveDecodingEnabled = true
            $0.dataLoader = DataLoader(configuration: {
                let conf = DataLoader.defaultConfiguration
                conf.urlCache = nil
                return conf
            }())
            $0.imageCache = ImageCache()
            $0.dataCachePolicy = .storeAll
            $0.dataCache = try? DataCache(name: Constant.dataCacheKey)
        }
    }

    func downloadImage(imageView: UIImageView? = nil,
                       url urlString: String?,
                       profilePlaceHolderImage: UIImage? = nil,
                       failureImage: UIImage? = nil,
                       priority: ImageRequest.Priority = .normal,
                       fadeDuration: TimeInterval = 0,
                       fadeInCache: Bool = false,
                       isPrepareForReuse: Bool = true,
                       isRound: Bool = false,
                       resolution: CGSize? = nil,
                       contentMode: UIImageView.ContentMode? = nil,
                       resulClosure: ((_ isFinished: Bool, _ image: UIImage?) -> Void)? = nil) {

        DispatchQueue.main.async { [unowned self] in

            let resultImageView = imageView ?? UIImageView()
            resultImageView.contentMode = imageView?.contentMode ?? contentMode ?? .scaleAspectFill
            resultImageView.frame.size = resolution ?? imageView?.frame.size ?? .zero
            resultImageView.tag = 1

            if let profilePlaceHolderImage = profilePlaceHolderImage {
                resultImageView.image = profilePlaceHolderImage
            }

            guard let urlString = urlString,
                  let url = URL(string: urlString) else {

                resultImageView.image = failureImage
                resulClosure?(true, failureImage)
                return
            }

            let contentMode = contentMode ?? resultImageView.contentMode
            var pixelSize: CGFloat {
                let size = resolution ?? resultImageView.frame.size
                return max(size.height, size.width)
            }
            var resizedImageProcessors: [ImageProcessing] {
                var processors: [ImageProcessing] = []
                if pixelSize != .zero {
                    processors.append(ImageProcessors.Resize(size: CGSize(width: pixelSize, height: pixelSize),
                                                             contentMode: contentMode == .scaleAspectFit ? .aspectFit : .aspectFill))
                }
                if isRound {
                    processors.append(ImageProcessors.Circle())
                }

                return processors
            }

            let request = ImageRequest(
                url: url,
                processors: resizedImageProcessors,
                priority: priority,
                options: []
            )

            var loadingOptions = ImageLoadingOptions(
                placeholder: profilePlaceHolderImage,
                transition: .fadeIn(duration: fadeDuration),
                failureImage: failureImage,
                failureImageTransition: .fadeIn(duration: fadeDuration),
                contentModes: .init(success: contentMode, failure: contentMode, placeholder: contentMode)
            )

            loadingOptions.isPrepareForReuseEnabled = isPrepareForReuse
            loadingOptions.alwaysTransition = fadeInCache
            loadingOptions.pipeline = self.pipeline

            Nuke.loadImage(with: request, options: loadingOptions, into: resultImageView) { (_, _, _) in
                // Progress
            } completion: { result in

                switch result {
                case .success(let response):

                    let image = response.image
                    resultImageView.image = image

                    resulClosure?(true, response.image)
                case .failure(let error):

                    resultImageView.image = failureImage
                    print("Image Download Error url: \(urlString)\nerror:", error.localizedDescription)
                    resulClosure?(true, failureImage)
                }
            }
        }
    }

    func removeImage(_ urlString: String?) {

        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }

        let request = ImageRequest(url: url)
        pipeline.cache.removeCachedImage(for: request)
    }

    func storeImage(_ image: UIImage?, urlString: String?) {

        guard let urlString = urlString,
              let url = URL(string: urlString),
              let image = image else { return }

        let request = ImageRequest(url: url)
        let imagec = ImageContainer(image: image)

        pipeline.cache.storeCachedImage(imagec, for: request)
    }
}
