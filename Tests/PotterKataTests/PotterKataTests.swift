import XCTest
@testable import PotterKata

final class PotterKataTests: XCTestCase {
    var sut: PotterBookStore!

    override func setUp() {
        super.setUp()
        sut = PotterBookStore()
    }

    func test_selectOneBook_getFullPrice() {
        let books = [1]
        let result: Double = 8

        let discount = sut.calculateTotalPrice(books: books)

        XCTAssertEqual(discount, result)
    }

    func test_select2SameBooks_getFullPrice() {
        let books = [1, 1]
        let result: Double = 2 * 8

        let discount = sut.calculateTotalPrice(books: books)

        XCTAssertEqual(discount, result)
    }

    func test_select2DifferentBooks_getPriceWithDiscount() {
        let books = [1, 2]
        let result: Double = 2 * 8 * 0.95

        let discount = sut.calculateTotalPrice(books: books)

        XCTAssertEqual(discount, result)
    }

    func test_select1_2_2Books_getPriceWithDiscount(){
        let books = [1, 2, 2]
        let result: Double = (8 + 8) * 0.95 + 8

        let discount = sut.calculateTotalPrice(books: books)

        XCTAssertEqual(discount, result)
    }

    func test_select1_2x2_3x2Books_getPriceWithDiscount(){
        let books = [1, 2, 2, 3, 3]
        let result: Double = (8 + 8 + 8) * 0.9 + (8 + 8) * 0.95

        let discount = sut.calculateTotalPrice(books: books)

        XCTAssertEqual(discount, result)
    }

    func test_select1_2x2_3x2_4x2Books_getPriceWithDiscount(){
        let books = [1, 2, 2, 3, 3, 4, 4]
        let result: Double = 8 * 4 * 0.85 + 8 * 3 * 0.9

        let discount = sut.calculateTotalPrice(books: books)

        XCTAssertEqual(discount, result)
    }

    func test_select1_2x2_3x2_4x2_5x2_Books_getPriceWithDiscount(){
        let books = [1, 2, 2, 3, 3, 4, 4, 5, 5]
        let result: Double =  8 * 5 * 0.75 + 8 * 4 * 0.85

        let discount = sut.calculateTotalPrice(books: books)

        XCTAssertEqual(discount, result)
    }

    func test_select1_2x2_3x2_4x2_5x2_6x1Books_getPriceWithDiscount(){
        let books = [1, 2, 2, 3, 3, 4, 4, 5, 5, 6]
        let result: Double =  8 * 6 * 0.7 + 8 * 4 * 0.85

        let discount = sut.calculateTotalPrice(books: books)

        XCTAssertEqual(discount, result)
    }
 
}

