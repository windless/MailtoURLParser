//
//  MailtoURLParser.swift
//  Pods
//
//  Created by 钟建明 on 16/3/24.
//
//

import Foundation

public class MailtoURLParser {
    public var toRecipients: [String]
    public var ccRecipients: [String]
    public var bccRecipients: [String]
    public var subject: String?
    public var body: String?
    
    public init?(url: NSURL) {
        ccRecipients = []
        bccRecipients = []
        
        if url.scheme != "mailto" {
            return nil
        }
        
        let urlString = url.absoluteString
        
        var tokens: [String]
        tokens = urlString.componentsSeparatedByString(":")
        
        if tokens.count != 2 {
            return nil
        }
        
        tokens = tokens[1].componentsSeparatedByString("?")
        toRecipients = tokens[0].componentsSeparatedByString(",")
        
        if tokens.count != 2 {
            return
        }
        
        tokens = tokens[1].componentsSeparatedByString("&")
        let params: [(String, String)] = tokens.map { params in
            let paramTokens = params.componentsSeparatedByString("=")
            if paramTokens.count != 2 {
                return ("", "")
            }
            return (paramTokens[0], paramTokens[1])
        }
        
        for (name, value) in params {
            switch name.lowercaseString {
            case "cc":
                ccRecipients = value.componentsSeparatedByString(",")
            case "bcc":
                bccRecipients = value.componentsSeparatedByString(",")
            case "subject":
                subject = decodeUrl(value)
            case "body":
                body = decodeUrl(value)
            default: break
            }
        }
    }
    
    private func decodeUrl(urlString: String) -> String {
        return urlString.stringByRemovingPercentEncoding!
    }
}


















