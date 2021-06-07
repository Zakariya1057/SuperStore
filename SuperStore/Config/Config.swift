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
//        private static let Host: String = "http://2.27.142.255/api"
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
        
        public struct Monitor {
            
            public static var Products: String {
                return Host + "/monitor/products"
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
        
        public struct Groceries {
            public static var GroceriesRoute: String {
                return Host + "/groceries"
            }
            
            
            public static var GrandParentCategories: String {
                return GroceriesRoute + "/grand_parent_categories"
            }
            
            public static var ChildCategories: String {
                return GroceriesRoute + "/child_categories"
            }
            
            public static var CategoryProducts: String {
                return GroceriesRoute + "/category_products"
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
        
        public struct Feedback {
            private static var FeedbackRoute: String {
                return Host + "/feedback"
            }
            
            public static var Create: String {
                return FeedbackRoute + "/create"
            }
        }
        
        public struct Report {
            private static var ReportRoute: String {
                return Host + "/report"
            }
            
            public static var Issue: String {
                return ReportRoute + "/issue"
            }
        }
        
        public static var Store: String {
            return Host + "/store"
        }
        
        public static var Favourites: String {
            return Host + "/favourites"
        }
        
//        public static var Promotion: String {
//            return Host + "/promotion"
//        }
        
        public struct Promotion {
            private static var PromotionRoute: String {
                return Host + "/promotion"
            }
            
            public static var Show: String {
                return PromotionRoute
            }
            
            public static var All: String {
                return PromotionRoute + "/all"
            }
        }
        
        public static var Flyers: String {
            return Host + "/flyers/store/"
        }
    }
    
}
