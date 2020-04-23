//
//  File.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation

class ProductsAPI {
    // MARK: Constant keys
    private static let categoriesJsonFilename: String = "CategoriesSlice"
    private static let productsJsonFilename: String = "ProductsSlice"
    private static let mockResponseTime: Double = 0.1
    private static let pixabayApiKey: String = "15867181-13b00815ca37913d74aebef79"
    private static let pixabayUrl: URL = {
        var c = URLComponents()
        c.scheme = "https"
        c.host = "pixabay.com"
        c.path = "/api"
        c.queryItems = [
            URLQueryItem(name: "key", value: ProductsAPI.pixabayApiKey),
            URLQueryItem(name: "safesearch", value: "true")
        ]
        return c.url!
    }()
    private static var shoppingCartCache: Set<Int> = []
    private static let imageCache = NSCache<NSString, NSData>()
    
    // MARK: Mock Implementations
    static func getMockAllCategories() -> [Category]? {
        let res: [Category]? = JSONUtil.loadJSON(fileName: categoriesJsonFilename)
        return res
    }
    
    static func getMockTopCategories() -> [Category] {
        guard let res = getMockAllCategories()?.shuffled() else {
            return []
        }
        return Array(res[0...5])
    }
    
    static func getMockItemsByCategory(id catgId: String, onDone: @escaping ([Product]?) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + mockResponseTime) {
            let allProducts: [Product]? = JSONUtil.loadJSON(fileName: productsJsonFilename)
            let res = allProducts?.filter{ p in p.category.map{ c in c.id }.contains(catgId) }
            onDone(res)
        }
    }
    
    static func getMockItemsByQuery(query: String, onDone: @escaping ([Product]?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + mockResponseTime) {
            let allProducts: [Product]? = JSONUtil.loadJSON(fileName: productsJsonFilename)
            let res = allProducts?.filter{ p in p.name.range(of: query, options: .caseInsensitive) != nil }
            onDone(res)
        }
    }
    
    static func addItemToCart(itemSKU: Int, onDone: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + mockResponseTime) {
            shoppingCartCache.insert(itemSKU)
            onDone()
        }
    }
    
    static func getNumberOfItemsInCart(onDone: @escaping (Int) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + mockResponseTime) {
            onDone(shoppingCartCache.count)
        }
    }
    
    static func getShoppingCartItems(onDone: @escaping ([Product]) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + mockResponseTime) {
            let allProducts: [Product]? = JSONUtil.loadJSON(fileName: productsJsonFilename)
            let res = allProducts?.filter{ p in shoppingCartCache.contains(p.sku) }
            onDone(res ?? [])
        }
    }
    
    static func removeItemFromCart(itemSKU: Int, onDone: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + mockResponseTime) {
            shoppingCartCache.remove(itemSKU)
            onDone()
        }
    }
    
    static func getAllCategories(onDone: @escaping ([Category]?) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + mockResponseTime) {
            let res: [Category]? = JSONUtil.loadJSON(fileName: categoriesJsonFilename)
            onDone(res)
        }
    }
    
    // MARK: HTTP Calls
    static func downloadData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func downloadImageData(from url: String, onDone: @escaping (Data?) -> ()) {
        let cacheID = NSString(string: url)
        if let cachedData = imageCache.object(forKey: cacheID) {
            onDone((cachedData as Data))
            return
        }
        guard let imgUrl = URL(string: url) else { return }
        downloadData(from: imgUrl) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async() { onDone(nil) }
                return
            }
            imageCache.setObject(data as NSData, forKey: cacheID)
            DispatchQueue.main.async() { onDone(data) }
        }
    }
    
    static func getCategoryImage(keywords catKeyword: String, onDone: @escaping (Data?) -> ()) {
        var urlC = URLComponents(url: pixabayUrl, resolvingAgainstBaseURL: true)
        urlC?.queryItems?.append(URLQueryItem(name: "q", value: ProductsAPI.formatKeywordsForCall(keywords: catKeyword)))
        downloadData(from: (urlC?.url)!) { data, response, error in
            guard let data = data, error == nil else { return }
            guard let metadata: PixbayResponse? = JSONUtil.parseDataToModel(from: data) else { return }
            
            if metadata?.totalHits == 0 {
                DispatchQueue.main.async() { onDone(nil)  }
                return
            }

            let resourceUrl = (metadata?.hits[0].previewURL)!
            
            downloadImageData(from: resourceUrl, onDone: onDone)
        }
    }
    
    static func isItemInCart(sku: Int, onDone: @escaping (Bool) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + mockResponseTime) {
            onDone(shoppingCartCache.contains(sku))
        }
    }
    
    // MARK: Utils
    private static func formatKeywordsForCall(keywords input: String) -> String {
        var res = input
            .replacingOccurrences(of: #"[^\w\s-]+"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"[\s]{2,}"#, with: " ", options: .regularExpression)
            .replacingOccurrences(of: #"\b[A-Z][a-z]{1,2}\b[^-]"#, with: "", options: .regularExpression)
        let range = res.range(of: #"[\w-]+\s[\w-]+"#, options: .regularExpression) ?? res.range(of: res)
        res = String(res[range!])
            .replacingOccurrences(of: #"\s"#, with: "-", options: .regularExpression)
        return res
    }
}
