typealias bookTitle = Int


struct PotterBookDiscountCalculation {
    let bookPrice: Double = 8

    func calculateDiscount(books: [bookTitle]) -> Double {
        let differentTitles = Set(books)
        var discount: Double
        switch differentTitles.count {
        case 2: discount = 0.05
        case ..<2: discount = 0
        default: discount = 1
        }
        return Double(differentTitles.count) * bookPrice * discount
    }
}


/*


 */
