//
//  Config.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct Config {
    
    struct Route {
        
        private static let Host: String = "http://192.168.1.187/api"
//        private static let Host: String = "http://superstoresite.com/api"
        
        public struct User {
            
            public static var UserRoute: String {
                Host + "/user"
            }
            
            
            public static var Location: String {
                return UserRoute + "/location"
            }
            
            public static var Register: String {
                return UserRoute + "/register"
            }
            
            public static var Login: String {
                return UserRoute + "/login"
            }
            
            public static var Update: String {
                return UserRoute + "/update"
            }
            
            public static var Logout: String {
                return UserRoute + "/logout"
            }
            
            public static var Delete: String {
                return UserRoute + "/delete"
            }
            
            struct ResetPassword {
                
                public static var SendEmail: String {
                    return UserRoute + "/reset/send-code"
                }
                
                public static var VerifyCode: String {
                    return UserRoute + "/reset/validate-code"
                }
                
                public static var NewPassword: String {
                    return UserRoute + "/reset/password"
                }
            }
            
        }
        
        public static var Home: String {
            return Host + "/home"
        }
        
        public struct Product {
            
            private static var ProductRoute: String {
                return Host + "/product"
            }
            
            
            public static var Show: String {
                return ProductRoute + "/"
            }
            
            public static var Favourite: String {
                return "/favourite"
            }
            
            public static var Monitor: String {
                return  "/monitor"
            }
            
        }
        
        public struct Review {
            
            public static var ReviewRoute: String {
                return Host + "/review"
            }
            
            
            public static var Show: String {
                return "/show"
            }
            
            public static var All: String {
                return "/"
            }
            
            public static var Create: String {
                return "/create"
            }
            
            public static var Update: String {
                return "/create"
            }
            
            public static var Delete: String {
                return "/delete"
            }
            
        }
        
        public struct Search {
            public static var SearchRoute: String {
                return Host + "/search"
            }
            
            
            public static var Suggestions: String {
                return SearchRoute + "/suggestions"
            }
            
            public struct Results {
                
                public static var SearchResultsRoute: String {
                    return SearchRoute + "/results"
                }
                
                
                public static var Product: String {
                    return SearchResultsRoute + "/product"
                }
                
                public static var Store: String {
                    return SearchResultsRoute + "/stores"
                }
            }

        }
        
        public struct Grocery {
            public static var GroceryRoute: String {
                return Host + "/grocery"
            }
            
            
            public static var GrandParentCategories: String {
                return GroceryRoute + "/categories"
            }
            
            public static var ChildCategories: String {
                return GroceryRoute + "/products"
            }
        }
        
        public struct List {
            public static var ListRoute: String {
                return Host + "/list"
            }
            
            
            
            public static var Create: String {
                return ListRoute + "/create"
            }
            
            public static var All: String {
                return ListRoute + "/stores"
            }
            
            public static var Show: String {
                return ListRoute + "/"
            }

            public static var Restart: String {
                return ListRoute + "/restart"
            }

            public static var Update: String {
                return ListRoute + "/update"
            }
            
            public static var Delete: String {
                return ListRoute + "/delete"
            }
            
            public struct Offline {
                private static var OfflineListRoute: String {
                    return Host + "/list/offline"
                }

                
                public static var Delete: String {
                    return OfflineListRoute + "/deleted"
                }
                
                public static var Edited: String {
                    return OfflineListRoute + "/edited"
                }
                
            }
            
            public struct Item {
                public static var ItemRoute: String {
                    return "/item"
                }
                
                
                public static var Create: String {
                    return ItemRoute + "/create"
                }
                
                public static var Update: String {
                    return ItemRoute + "/update"
                }
                
                public static var Delete: String {
                    return ItemRoute + "/delete"
                }
            }
        }
        
        public static var Store: String {
            return Host + "/store"
        }
        
        public static var Favourites: String {
            return Host + "/favourites"
        }
        
        public static var Promotion: String {
            return Host + "/promotion"
        }
        
    }
    
}
