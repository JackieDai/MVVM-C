//
//  MVVM_CTests.swift
//  MVVM-CTests
//
//  Created by LingXiao Dai on 2023/7/26.
//

import XCTest
import RxSwift
import RxCocoa
@testable import MVVM_C

final class MVVM_CTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDoOnNext() {
        let disposeBag = DisposeBag()
        
        Observable.of("🍎", "🍐", "🍊", "🍋")
            .do(onNext: { print("Intercepted:", $0) },
                afterNext: { print("Intercepted after:", $0) },
                onError: { print("Intercepted error:", $0) },
                afterError: { print("Intercepted after error:", $0) },
                onCompleted: { print("Completed")  },
                afterCompleted: { print("After completed")  })
            .subscribe(onNext: { print($0 + "====subscribe") })
            .disposed(by: disposeBag)
                
                /*
                 Intercepted: 🍎
                 🍎====subscribe
                 Intercepted after: 🍎
                 Intercepted: 🍐
                 🍐====subscribe
                 Intercepted after: 🍐
                 Intercepted: 🍊
                 🍊====subscribe
                 Intercepted after: 🍊
                 Intercepted: 🍋
                 🍋====subscribe
                 Intercepted after: 🍋
                 Completed
                 After completed
                 */
    }

}
