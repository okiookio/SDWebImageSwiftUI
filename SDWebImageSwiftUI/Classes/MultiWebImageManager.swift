//
//  File.swift
//
//
//  Created by Duong To on 7/19/24.
//

import Foundation

public class MultiWebImageManager: SDWebImageManager {
    @discardableResult
    public func loadWebImage(with url: MultiWebImageURL, options: SDWebImageOptions = [], progress progressBlock: SDImageLoaderProgressBlock?, completed completedBlock: @escaping SDInternalCompletionBlock) -> SDWebImageCombinedOperation? {
        loadWebImage(with: url, options: options, context: nil, progress: progressBlock, completed: completedBlock)
    }

    @discardableResult
    public func loadWebImage(with url: MultiWebImageURL, options: SDWebImageOptions = [], context: [SDWebImageContextOption: Any]?, progress progressBlock: SDImageLoaderProgressBlock?, completed completedBlock: @escaping SDInternalCompletionBlock) -> SDWebImageCombinedOperation? {
        super.loadImage(with: url.primaryUrl, options: options, context: context, progress: progressBlock) { [weak self] image, data, error, cacheType, finished, imageURL in

            guard let self = self else {
                return
            }
            if let error = error as? SDWebImageError, error.code == .cancelled {
                // Ignore user cancelled
                // There are race condition when quick scroll
                // Indicator modifier disapper and trigger `WebImage.body`
                // So previous View struct call `onDisappear` and cancel the currentOperation
                return
            } else if error != nil {
//                load(url: url?.secondaryURL, options: options, context: context)
                self.loadImage(with: url.secondaryURL, options: options, context: context, progress: progressBlock, completed: completedBlock)
                return
            }

            completedBlock(image, data, error, cacheType, finished, imageURL)
        }
    }

    @discardableResult
    override public func loadImage(with url: URL?, options: SDWebImageOptions = [], context: [SDWebImageContextOption: Any]?, progress progressBlock: SDImageLoaderProgressBlock?, completed completedBlock: @escaping SDInternalCompletionBlock) -> SDWebImageCombinedOperation? {
        super.loadImage(with: url, options: options, context: context, progress: progressBlock, completed: completedBlock)
    }
}
