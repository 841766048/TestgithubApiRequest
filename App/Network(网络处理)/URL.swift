//
//  URL.swift
//  App
//
//  Created by 张海彬 on 2020/12/1.
//

import Foundation

//MARK:- ---------- (请求头所用的key值) ----------
let token_Key = "Authorization" // head添加token的key
let isAddToken = true // 请求头是否添加token



//MARK:- ---------- (URL) ----------
#if DEBUG
let BASEURL_RES  = "http://192.168.1.197:8075/rp-res/"
let BASEURL_JX  = "http://202.111.145.7:8075/opt/"
//let Token_URL  = "http://192.168.1.197:8075/uaa/"
let Token_URL     = "http://202.111.145.7:8075/uaa/"
let BASEURL_ASSistant   = "http://192.168.1.197:8075/assistant/"
//let BASEURL_GRID  = "http://192.168.1.197:8075/grid/"
let BASEURL_GRID  = "http://202.111.145.7:8075/grid/"
let BASEURL_REST  = "http://202.111.145.7:8033/maintainGrid/"
let BASEURL_SEARCH_RES  = "http://202.111.145.7:8075/srv-search/"
#else
let BASEURL_RES  = "http://202.111.145.7:8075/rp-res/"
let BASEURL_JX   = "http://202.111.145.7:8075/opt/"
let BASEURL_REST  = "http://202.111.145.7:8033/maintainGrid/"
let Token_URL     = "http://202.111.145.7:8075/uaa/"
let BASEURL_GRID  = "http://202.111.145.7:8075/grid/"
let BASEURL_ASSistant   = "http://202.111.145.7:8075/assistant/"
let BASEURL_SEARCH_RES  = "http://202.111.145.7:8075/srv-search/"
#endif

