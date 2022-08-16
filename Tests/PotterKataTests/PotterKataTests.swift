import XCTest
@testable import PotterKata

final class PotterKataTests: XCTestCase {
    private var sut: PotterBookStore!
    private let bookPrice = Constants.bookPrice

    override func setUp() {
        super.setUp()
        sut = PotterBookStore()
    }

    func test_selectNoBooks_getZeroPrice() {
        assertPrice(for: [], expectedPrice: .zero)
    }

    func test_selectSameBooks_getFullPrice() {
        assertPrice(for: [0], expectedPrice: bookPrice)
        assertPrice(for: [1,1], expectedPrice: bookPrice * 2)
        assertPrice(for: [Int].init(repeating: 6, count: 10), expectedPrice: 10 * bookPrice)
    }

    func test_selectDifferentBooks_getPriceWithDiscount() {
        assertPrice(
            for: [0,1],
            expectedPrice: bookPrice * 2 * 0.95
        )
        assertPrice(
            for: [1, 2, 2],
            expectedPrice: bookPrice * 2 * 0.95 + bookPrice
        )
        assertPrice(
            for: [1, 2, 2, 3, 3],
            expectedPrice: bookPrice * 3 * 0.9 + bookPrice * 2 * 0.95
        )
        assertPrice(
            for: [1, 2, 2, 3, 3, 4, 4],
            expectedPrice: bookPrice * 4 * 0.85 + bookPrice * 3 * 0.9
        )
    }

    /// In this case 1 each of books one through five make a set of 5 unique books eligible for 25% off, and one each of books two through
    /// six make a similar set, resulting in 10 books at 25% off of $8 (10 * $8 * .75) = $60. If the algorithm had "greedily" used all six unique
    ///  books to get a 30% discount, the remaining 4 books (Two, Three, Four, Five) would only have been eligible for a 15% discount.
    ///  The cost would thus have been (6 * $8 * .7) = $33.60 + (4 * $8 * .85) = $27.20 for a total of $60.80.
    func test_select1_2x2_3x2_4x2_5x2_6x1Books_getOptimalPriceWithDiscount(){
        let books = [1, 2, 2, 3, 3, 4, 4, 5, 5, 6]
        let result: Float =  8 * 5 * 0.75 + 8 * 5 * 0.75
        assertPrice(for: books, expectedPrice: result)
    }

    func assertPrice(
        for books: [Int],
        expectedPrice: Float,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(sut.calculateOptimalPrice(books), expectedPrice, file: file, line: line)
    }

}

