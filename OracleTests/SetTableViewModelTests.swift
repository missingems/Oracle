//
//  SetTableViewModelTests.swift
//  OracleTests
//
//  Created by Jun on 13/3/24.
//

import XCTest
@testable import Oracle

final class SetTableViewModelTests: XCTestCase {
  func test_initialDataSource_isEmpty() {
    XCTAssertTrue(viewModel().dataSource.isEmpty)
  }
  
  func test_updateViewDidLoad_shouldShowIsLoading() {
    let viewModel = viewModel(isSuccess: true)
    
    viewModel.didUpdate = {
      XCTAssertEqual($0, .isLoading)
    }
    
    viewModel.update(.viewDidLoad)
  }
  
  func test_updatePullToRefreshInvoked_shouldFetchSets() {
    let viewModel = viewModel(isSuccess: true)
    var capturedMessages: [SetTableViewModel.Message] = []
    viewModel.didUpdate = { capturedMessages.append($0) }
    viewModel.update(.pullToRefreshInvoked)
    XCTAssertEqual(capturedMessages, [.shouldEndRefreshing, .shouldReloadData])
  }
  
  func test_when_dataSourceChanged_calls_didUpdateShouldReloadData() {
    let viewModel = viewModel(isSuccess: true)
    var capturedMessages: [SetTableViewModel.Message] = []
    viewModel.didUpdate = { capturedMessages.append($0) }
    viewModel.update(.viewWillAppear)
    XCTAssertEqual(capturedMessages, [.shouldReloadData])
  }
  
  func test_when_dataSourceChanged_compareReceivedDataSource() throws {
    let viewModel = viewModel(isSuccess: true)
    viewModel.update(.viewWillAppear)
    let cardSet = try XCTUnwrap(viewModel.dataSource.first as? TestCardSet, "ViewModel should have 1 card set after fetching sets")
    // Make sure CardSet is not mutated
    XCTAssertEqual(cardSet, TestCardSet())
  }
  
  func test_when_error_calls_didUpdateShouldDisplayErrorMessage() {
    let viewModel = viewModel(isSuccess: false)
    var capturedMessages: [SetTableViewModel.Message] = []
    viewModel.didUpdate = { capturedMessages.append($0) }
    viewModel.update(.viewWillAppear)
    XCTAssertEqual(capturedMessages, [.shouldDisplayError(TestError.testError)])
  }
  
  func test_configuration() {
    let viewModel = viewModel()
    XCTAssertEqual(viewModel.configuration.title, "Sets")
    XCTAssertEqual(viewModel.configuration.tabBarSelectedSystemImageName, "book.pages.fill")
    XCTAssertEqual(viewModel.configuration.tabBarDeselectedSystemImageName, "book.pages")
  }
  
  private func viewModel(isSuccess: Bool = false) -> SetTableViewModel {
    SetTableViewModel(client: TestSetNetworkService(isSuccess: isSuccess))
  }
}

private struct TestCardSet: CardSet {
  var name: String { "Test" }
  var code: String { "1234" }
  var iconURI: String { "https://icon.svg" }
  var numberOfCards: Int { 123 }
  var parentCode: String? { "P123" }
}

private enum TestError: Error {
  case testError
}

private struct TestSetNetworkService: SetNetworkService {
  private let isSuccess: Bool
  
  init(isSuccess: Bool) {
    self.isSuccess = isSuccess
  }
  
  func fetchSets(_ completion: @escaping (Result<[any Oracle.CardSet], any Error>) -> ()) {
    if isSuccess {
      completion(.success([TestCardSet()]))
    } else {
      completion(.failure(TestError.testError))
    }
  }
}
