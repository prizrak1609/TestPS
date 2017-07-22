//
//  Database.swift
//  TestPS
//
//  Created by Dima Gubatenko on 22.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
// need for Result
import Alamofire

final class Database {
    fileprivate let dbPath: String
    fileprivate var database: OpaquePointer?

    init() {
        if var documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            documents.appendPathComponent("testps.db")
            dbPath = documents.absoluteString
        } else {
            dbPath = ""
        }
    }

    func openOrCreate() -> Result<Void> {
        if sqlite3_open(dbPath, &database) != SQLITE_OK {
            return .failure(NSError(domain: String(cString: sqlite3_errmsg(database)), code: 0, userInfo: nil))
        } else {
            var createTable: OpaquePointer?
            let createReceipesString = "create table if not exists recipes ( title text NOT NULL, href text NOT NULL, ingredients text NOT NULL, thumbnail text NOT NULL );"
            if sqlite3_prepare_v2(database, createReceipesString, -1, &createTable, nil) == SQLITE_OK {
                if sqlite3_step(createTable) != SQLITE_DONE {
                    return .failure(NSError(domain: String(cString: sqlite3_errmsg(database)), code: 0, userInfo: nil))
                }
            } else {
                return .failure(NSError(domain: String(cString: sqlite3_errmsg(database)), code: 0, userInfo: nil))
            }
            sqlite3_finalize(createTable)
            return .success()
        }
    }

    func close() {
        sqlite3_close(database)
    }

    deinit {
        close()
    }

    func create(recipes: [RecipeModel]) -> Result<Void> {
        for recipe in recipes {
            var createItem: OpaquePointer?
            let createRecipeString = "insert into recipes (title, href, ingredients, thumbnail) values (?, ?, ?, ?);"
            if sqlite3_prepare_v2(database, createRecipeString, -1, &createItem, nil) == SQLITE_OK {
                sqlite3_bind_text(createItem, 1, (recipe.title as NSString).utf8String, -1, nil)
                sqlite3_bind_text(createItem, 2, (recipe.siteURLPath as NSString).utf8String, -1, nil)
                sqlite3_bind_text(createItem, 3, (recipe.ingredients as NSString).utf8String, -1, nil)
                sqlite3_bind_text(createItem, 4, (recipe.thumbnail as NSString).utf8String, -1, nil)
                if sqlite3_step(createItem) != SQLITE_DONE {
                    return .failure(NSError(domain: String(cString: sqlite3_errmsg(database)), code: 0, userInfo: nil))
                }
            } else {
                return .failure(NSError(domain: String(cString: sqlite3_errmsg(database)), code: 0, userInfo: nil))
            }
            sqlite3_finalize(createItem)
        }
        return .success()
    }

    func deleteReceipes() -> Result<Void> {
        var removeItem: OpaquePointer?
        let removeReceipesString = "drop table if exists recipes;"
        if sqlite3_prepare_v2(database, removeReceipesString, -1, &removeItem, nil) == SQLITE_OK {
            if sqlite3_step(removeItem) != SQLITE_DONE {
                return .failure(NSError(domain: String(cString: sqlite3_errmsg(database)), code: 0, userInfo: nil))
            }
        } else {
            return .failure(NSError(domain: String(cString: sqlite3_errmsg(database)), code: 0, userInfo: nil))
        }
        sqlite3_finalize(removeItem)
        return openOrCreate()
    }

    func getAllReceipes() -> Result<[RecipeModel]> {
        var searchItem: OpaquePointer?
        let searchCarsString = "select * from recipes;"
        var result = [RecipeModel]()
        if sqlite3_prepare_v2(database, searchCarsString, -1, &searchItem, nil) == SQLITE_OK {
            while sqlite3_step(searchItem) == SQLITE_ROW {
                var recipe = RecipeModel()
                recipe.title = String(cString: sqlite3_column_text(searchItem, 0))
                recipe.siteURLPath = String(cString: sqlite3_column_text(searchItem, 1))
                recipe.ingredients = String(cString: sqlite3_column_text(searchItem, 2))
                recipe.thumbnail = String(cString: sqlite3_column_text(searchItem, 3))
                result.append(recipe)
            }
        } else {
            return .failure(NSError(domain: String(cString: sqlite3_errmsg(database)), code: 0, userInfo: nil))
        }
        sqlite3_finalize(searchItem)
        return .success(result)
    }
}
