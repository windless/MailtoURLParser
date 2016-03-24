//
//  MailtoURLParserSpec.swift
//  MailtoURLParser
//
//  Created by 钟建明 on 16/3/24.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import MailtoURLParser

class MailtoURLParserSpec: QuickSpec {
    override func spec() {
        describe("MailtoURLParser") {
            it("parses 'to recipients' with one recipient") {
                let parser = self.parserFromUrl("mailto:someone@email.com")!
                expect(parser.toRecipients) == ["someone@email.com"]
                expect(parser.ccRecipients) == []
                expect(parser.bccRecipients) == []
                expect(parser.subject).to(beNil())
                expect(parser.body).to(beNil())
            }
            
            it("parses 'to recipients' with many recipients") {
                let parser = self.parserFromUrl("mailto:someone@email.com,other@email.com")!
                expect(parser.toRecipients) == ["someone@email.com", "other@email.com"]
                expect(parser.ccRecipients) == []
                expect(parser.bccRecipients) == []
                expect(parser.subject).to(beNil())
                expect(parser.body).to(beNil())
            }
            
            it("parses 'cc recipients' with one recipient") {
                let parser = self.parserFromUrl("mailto:someone@email.com,other@email.com?cc=cc@email.com")!
                expect(parser.toRecipients) == ["someone@email.com", "other@email.com"]
                expect(parser.ccRecipients) == ["cc@email.com"]
                expect(parser.bccRecipients) == []
                expect(parser.subject).to(beNil())
                expect(parser.body).to(beNil())
                
            }
            
            it("parses 'cc recipients' with many recipients") {
                let parser = self.parserFromUrl("mailto:someone@email.com,other@email.com?cc=cc@email.com,ccother@email.com")!
                expect(parser.toRecipients) == ["someone@email.com", "other@email.com"]
                expect(parser.ccRecipients) == ["cc@email.com", "ccother@email.com"]
                expect(parser.bccRecipients) == []
                expect(parser.subject).to(beNil())
                expect(parser.body).to(beNil())
                
            }
            
            it("parses 'bcc recipients' with one recipient") {
                let parser = self.parserFromUrl("mailto:someone@email.com,other@email.com?cc=cc@email.com,ccother@email.com&bcc=bcc@email.com")!
                expect(parser.toRecipients) == ["someone@email.com", "other@email.com"]
                expect(parser.ccRecipients) == ["cc@email.com", "ccother@email.com"]
                expect(parser.bccRecipients) == ["bcc@email.com"]
                expect(parser.subject).to(beNil())
                expect(parser.body).to(beNil())
                
            }
            
            it("parses 'bcc recipients' with one recipient") {
                let parser = self.parserFromUrl("mailto:someone@email.com,other@email.com?cc=cc@email.com,ccother@email.com&bcc=bcc@email.com,bccother@email.com")!
                expect(parser.toRecipients) == ["someone@email.com", "other@email.com"]
                expect(parser.ccRecipients) == ["cc@email.com", "ccother@email.com"]
                expect(parser.bccRecipients) == ["bcc@email.com", "bccother@email.com"]
                expect(parser.subject).to(beNil())
                expect(parser.body).to(beNil())
            }
            
            it("parses subject") {
                let parser = self.parserFromUrl("mailto:someone@email.com,other@email.com?cc=cc@email.com,ccother@email.com&bcc=bcc@email.com,bccother@email.com&subject=hello")!
                expect(parser.toRecipients) == ["someone@email.com", "other@email.com"]
                expect(parser.ccRecipients) == ["cc@email.com", "ccother@email.com"]
                expect(parser.bccRecipients) == ["bcc@email.com", "bccother@email.com"]
                expect(parser.subject) == "hello"
                expect(parser.body).to(beNil())
            }
            
            it("parse body") {
                let parser = self.parserFromUrl("mailto:someone@email.com,other@email.com?cc=cc@email.com,ccother@email.com&bcc=bcc@email.com,bccother@email.com&subject=hello&body=world")!
                expect(parser.toRecipients) == ["someone@email.com", "other@email.com"]
                expect(parser.ccRecipients) == ["cc@email.com", "ccother@email.com"]
                expect(parser.bccRecipients) == ["bcc@email.com", "bccother@email.com"]
                expect(parser.subject) == "hello"
                expect(parser.body) == "world"
            }
            
            it("decode url") {
                let parser = self.parserFromUrl("mailto:someone@email.com?subject=%e4%bd%a0%e5%a5%bd&body=%e4%b8%96%e7%95%8c")!
                expect(parser.toRecipients) == ["someone@email.com"]
                expect(parser.ccRecipients) == []
                expect(parser.bccRecipients) == []
                expect(parser.subject) == "你好"
                expect(parser.body) == "世界"
            }
            
            it("is case-insensitive") {
                let parser = self.parserFromUrl("mailto:someone@email.com,other@email.com?CC=cc@email.com,ccother@email.com&Bcc=bcc@email.com,bccother@email.com&Subject=hello&Body=world")!
                expect(parser.toRecipients) == ["someone@email.com", "other@email.com"]
                expect(parser.ccRecipients) == ["cc@email.com", "ccother@email.com"]
                expect(parser.bccRecipients) == ["bcc@email.com", "bccother@email.com"]
                expect(parser.subject) == "hello"
                expect(parser.body) == "world"
            }
            
            it("returns nil when url is invalid") {
                expect(self.parserFromUrl("mmsefsef")).to(beNil())
                expect(self.parserFromUrl("http://hello.com")).to(beNil())
                expect(self.parserFromUrl("mailto:wwww:www")).to(beNil())
                expect(self.parserFromUrl("mailto:email@email.com?sefse")).to(beNil())
                expect(self.parserFromUrl("mailto:email@email.com?sefse=seffe&&sefbse")).to(beNil())
            }
        }
    }
    
    private func parserFromUrl(url: String) -> MailtoURLParser? {
        return MailtoURLParser(url: NSURL(string: url)!)
    }
}


















