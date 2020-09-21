//
//  LocationSearchViewModel.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/18/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject {
    var didSearchRequestError: Bool {
        return searchResults != nil && (try? searchResults!.get()) == nil
    }
    var isSearching: Bool
    var isTableViewHidden: Bool {
        return self.isSearching || didSearchRequestError
    }
    private var mapAPI: MapAPI
    var numRows: Int {
        guard let results = searchResults, let numResults = try? results.get().count else {
            return 0
        }
        return numResults
    }
    var searchResults: LocationSearchResult?
    var selectedRowIndex: Int?
    var selectedResult: MKMapItem? {
        guard let index = selectedRowIndex, let results = try? searchResults?.get() else {
            return nil
        }
        return results[index]
    }
    var view: LocationSearchView
    var query: String?
    
    init(view: LocationSearchView) {
        self.isSearching = false
        self.mapAPI = AppleMapsService()
        self.view = view
        super.init()
    }
    
    func sendSearchRequest() {
        isSearching = true
        view.refresh()
        guard let query = query else {
            return
        }
        mapAPI.sendSearchRequestFor(query: query) { (result) in
            self.searchResults = result
            self.isSearching = false
            self.view.refresh()
        }
    }
    
    func labelTextForResultAt(index: Int) -> String? {
        guard let results = try? searchResults?.get(), index < results.count else {
            return nil
        }
        let result = results[index]
        return "\(result.name ?? "")"
    }
}
