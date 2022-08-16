import Foundation

class PotterBookStore {

    enum Const {
        static let bookPrice: Float = 8
        static let librarySize: Int = 7
    }

    var prices: [Float] = .init(
        repeating: 0,
        count: Const.librarySize * 2.pow(Const.librarySize))

    let discount: [Float] = [0, 0, 0.05, 0.10, 0.15, 0.25, 0.30, 0.35]

    init() {
        fillBasePrices()
    }

    func calculateOptimalPrice(_ books: [Int]) -> Float {
        let library = createLibrary(books: books).sorted()
        return getMinPrice(library)
    }

    private func getMinPrice(_ library: [Int]) -> Float {
        let key = getPriceKey(library: library)
        var minPrice: Float = prices[key]

        guard minPrice == 0 else { return minPrice }
        minPrice = .infinity

        var (libraries1, libraries2) = splitLibrary(library)

        for column in 0..<libraries1.count {
            libraries1[column] = libraries1[column].sorted()
            libraries2[column] = libraries2[column].sorted()

            let p1 = getMinPrice(libraries1[column])
            let p2 = getMinPrice(libraries2[column])

            if minPrice > p1+p2 {
                minPrice = p1 + p2
            }
        }

        if isPurchase(library) {
            let discountPrice = getDiscountPrice(library)

            if discountPrice < minPrice {
                minPrice = discountPrice
            }
        }

        prices[key] = minPrice
        return minPrice
    }

    func createLibrary(books: [Int]) -> [Int] {
        var library = createEmptyLibrary()
        books.forEach { book in
            library[book] += 1
        }
        return library
    }

    // Returns the ability to sell at a time
    private func isPurchase(_ library: [Int]) -> Bool {
        !library.contains { $0 > 1 }
    }

    // Return price with discount
    private func getDiscountPrice(_ library: [Int]) -> Float {
        var count: Int = 0
        library.forEach { book in
            if book == 1 { count += 1 }
        }

        let discount = discount[safe: count] ?? 0
        let result = (1.0 - discount) * Float(count) * Const.bookPrice
        return result
    }

    // Split library into all possible double subsets
    // example: [1 1] = [0 1] + [1 0]
    // example: [2 1] = [1 1] + [1 0] && [2 0] + [0 1]
    private func splitLibrary(_ library: [Int]) -> ([[Int]], [[Int]]) {
        var libraries1: [[Int]] = []
        var libraries2: [[Int]] = []

        library.enumerated().forEach { row, bookCount in
            guard bookCount != 0 else { return }
                var library1 = createEmptyLibrary()
                var library2 = library

                library1[row] += 1
                library2[row] -= 1

                libraries1.append(library1)
                libraries2.append(library2)


                for column in 0..<libraries1.count - 1 {
                    guard libraries2[safe: column]?[row] != nil, libraries2[safe: column]?[row] != 0 else { return }

                    library1 = libraries1[column]
                    library2 = libraries2[column]

                    library1[row] += 1
                    library2[row] -= 1

                    if getPriceKey(library: library2) != 0 {
                        libraries1.append(library1)
                        libraries2.append(library2)
                    }
                }
        }
        return (libraries1, libraries2)

    }

    private func fillBasePrices() {
        for index in 0..<Const.librarySize {
            var library: [Int] = createEmptyLibrary()
            library[index] = 1
            let key = getPriceKey(library: library)
            prices[key] = Const.bookPrice
        }
    }

    private func getPriceKey(library: [Int]) -> Int {
        var key = 0

        library.enumerated().forEach { index, book in
            key += book * 2.pow(index)
        }

        return key
    }

    private func createEmptyLibrary() -> [Int] {
        [Int](repeating: 0, count: Const.librarySize)
    }
}

private extension Int {
    func pow(_ exponent: Int) -> Int {
        NSDecimalNumber(decimal: Foundation.pow(Decimal(self), exponent)).intValue
    }
}

private extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
