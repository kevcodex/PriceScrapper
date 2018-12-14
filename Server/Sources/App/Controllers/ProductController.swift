import Vapor

struct ProductController: RouteCollection {
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api", "products")
        apiRouter.get(use: getAllHandler)
        apiRouter.post(use: createProductHandler)
        apiRouter.get(Product.parameter, use: getProductHandler)
        apiRouter.delete(Product.parameter, use: deleteHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Product]> {
        return Product.query(on: req).all()
    }
    
    func createProductHandler(_ req: Request) throws -> Future<Product> {
        
        return try req.content.decode(Product.self).flatMap(to: Product.self) { product in
            
            guard let id = product.id else {
                throw Abort(HTTPResponseStatus.badRequest)
            }
            
            return Product.find(id, on: req)
                .flatMap(to: Product.self, { (foundProduct) -> EventLoopFuture<Product> in
                    
                    if let foundProduct = foundProduct {
                        foundProduct.priceHistory.append(contentsOf: product.priceHistory)
                        
                        return foundProduct.create(orUpdate: true, on: req)
                    } else {
                        return product.create(orUpdate: true, on: req)
                    }
                })
        }
    }
    
    func getProductHandler(_ req: Request) throws -> Future<Product> {
        return try req.parameters.next(Product.self)
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Product.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
}
