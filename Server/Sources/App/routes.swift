import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    router.post("products") { req -> Future<Product> in
        
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
    
    router.get("products") { req in
        return Product.query(on: req).all()
    }
    
    router.get("products", Product.parameter) { req in
        return try req.parameters.next(Product.self)
    }
    
    router.delete("products", Product.parameter) { req in
        return try req.parameters.next(Product.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
}
