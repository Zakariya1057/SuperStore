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
        
        private static let host: String = "http://192.168.1.187/api"
        
        public struct User {
            
            public static var Register: String {
                return host + "/user/register"
            }
            
            public static var Login: String {
                return host + "/user/login"
            }
            
            struct ResetPassword {
                
                public static var SendEmail: String {
                    return host + "/user/reset/send-code"
                }
                
                public static var VerifyCode: String {
                    return host + "/user/reset/validate-code"
                }
                
                public static var NewPassword: String {
                    return host + "/user/reset/password"
                }
            }
            
        }
        
        public static var Home: String {
            return host + "/home"
        }
        
        public struct Product {
            
            private static var ProductRoute: String {
                return host + "/product"
            }
            
            
            public static var Show: String {
                return ProductRoute + "/"
            }
            
            public static var Favourite: String {
                return ProductRoute + "/favourite"
            }
            
            public static var Monitor: String {
                return ProductRoute + "/monitor"
            }
            
            public struct Review {
                
                private static var ReviewRoute: String {
                    return ProductRoute + "/review"
                }
                
                private static var Show: String {
                    return ReviewRoute + "/"
                }
                
                private static var All: String {
                    return ReviewRoute + "/"
                }
                
                private static var Create: String {
                    return ReviewRoute + "/create"
                }
                
                public static var Delete: String {
                    return ReviewRoute + "/delete"
                }
                
            }
            
        }
    }
    
}
