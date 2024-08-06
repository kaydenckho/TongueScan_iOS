import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url:  URL(string: url)!)
        webView.load(request)
    }
}
