//
//  CustomRestManagerTests.swift
//  CustomRestManagerTests
//
//  Created by Tariq Najib on 31/08/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import XCTest
@testable import CustomRestManager

class CustomRestManagerTests: XCTestCase {

    var customAPIClient: CustomRestManager!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        customAPIClient = CustomRestManager.shared
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMakeGetRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { fatalError("Error with URL") }
        let method = CustomRestManager.HttpsMethods.get
        weak var apiExpectation = expectation(description: "json data")
        var testableMockData: MockData?
        for _ in 0..<5 {
            customAPIClient.makeRequest(toURL: url, withHttpMethod: method) { (results) in
                if let data = results.data {
                    do {
                        let mockData = try JSONDecoder().decode(MockData.self, from: data)
                        testableMockData = mockData
                        print("json: \(mockData.title)")
                        apiExpectation?.fulfill()
                        apiExpectation = nil
                    } catch {
                        print(error)
                    }
                    
                } else {
                    XCTFail("Failed API call")
                }
                
            }
        }
        
        waitForExpectations(timeout: 5){ error in
           XCTAssertNotNil(testableMockData)
            
        }
    }
    func testMakePostRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { fatalError("Error with URL") }
        let method = CustomRestManager.HttpsMethods.post
        weak var apiExpectation = expectation(description: "json data")
        var testableMockData: MockDataPost?
        customAPIClient.requestHeaders.add(value: "application/json", forKey: "Content-Type")
        customAPIClient.httpBodyParameters.add(value: "Hello World", forKey: "title")
        customAPIClient.httpBodyParameters.add(value: "A Wonderful Day", forKey: "body")
        customAPIClient.httpBodyParameters.addAny(value: 123, forKey: "userId")
        
        for _ in 0..<1 {
            customAPIClient.makeRequest(toURL: url, withHttpMethod: method) { (results) in
                if let data = results.data {
                    do {
                        let mockData = try JSONDecoder().decode(MockDataPost.self, from: data)
                        testableMockData = mockData
                        print("json: \(String(describing: testableMockData?.body))")
                        apiExpectation?.fulfill()
                        apiExpectation = nil
                    } catch {
                        print(error)
                    }
                    
                } else {
                    XCTFail("Failed API call")
                }
                
            }
        }
        
        waitForExpectations(timeout: 5){ error in
            XCTAssertNotNil("")
            
        }
    }
    func testImageDownload() {
        guard let url = URL(string: "https://images.unsplash.com/photo-1464550883968-cec281c19761")
            else { return }
        weak var apiExpectation = expectation(description: "image data")
        let method = CustomRestManager.HttpsMethods.get
        var testableMockData: UIImage?
        for _ in 0..<5 {
            customAPIClient.makeRequest(toURL: url, withHttpMethod: method) { (results) in
                if let data = results.data {
                    do {
                        let image = UIImage(data: data)
                        testableMockData = image
                        print("image size: \(String(describing: image?.size))")
                        apiExpectation?.fulfill()
                        apiExpectation = nil
                    } catch {
                        print(error)
                    }
                    
                } else {
                    XCTFail("Failed API call")
                }
                
            }
        }
        
        waitForExpectations(timeout: 5){ error in
            XCTAssertNotNil(testableMockData)
            
        }
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
struct MockData: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}
struct MockDataPost: Codable {
    let id: Int
    let title, body: String
    let userID: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, body
        case userID = "userId"
    }
}
