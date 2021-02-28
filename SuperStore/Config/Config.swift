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
        
        public struct User {
            
            public static var Register: String {
                return Host + "/user/register"
            }
            
            public static var Login: String {
                return Host + "/user/login"
            }
            
            struct ResetPassword {
                
                public static var SendEmail: String {
                    return Host + "/user/reset/send-code"
                }
                
                public static var VerifyCode: String {
                    return Host + "/user/reset/validate-code"
                }
                
                public static var NewPassword: String {
                    return Host + "/user/reset/password"
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
                return ProductRoute + "/favourite"
            }
            
            public static var Monitor: String {
                return ProductRoute + "/monitor"
            }
            
            public struct Review {
                
                public static var ReviewRoute: String {
                    return ProductRoute + "/review"
                }
                
                public static var Show: String {
                    return "/review"
                }
                
                public static var All: String {
                    return "/reviews"
                }
                
                public static var Create: String {
                    return "/create"
                }
                
                public static var Delete: String {
                    return "/delete"
                }
                
            }
            
        }
        
        public static var Promotion: String {
            return Host + "/promotion"
        }
        
    }
    
}
