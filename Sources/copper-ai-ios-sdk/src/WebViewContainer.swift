import SwiftUI
import WebKit

@available(iOS 13.0, *)
struct WebViewContainer: View {
    let url: String
    
    @State private var isLoading: Bool = false
    @State private var progress: Double = 0.0

    var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                if #available(iOS 14.0, *) {
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                }
            }
            if #available(iOS 14.0, *) {
                            WebView(url: url, isLoading: $isLoading, progress: $progress)
                                .ignoresSafeArea()
                        } else {
                            WebView(url: url, isLoading: $isLoading, progress: $progress)
                                .edgesIgnoringSafeArea(.all)
                        }
        }
    }
}

@available(iOS 13.0, *)
struct WebView: UIViewRepresentable {
 
    let webView: WKWebView
    let botUrl : String
    @Binding public var isLoading: Bool
    @Binding public var progress: Double
    
    init(url:String,isLoading: Binding<Bool>, progress: Binding<Double>) {
        webView = WKWebView(frame: .zero)
        botUrl = url
        self._isLoading = isLoading
        self._progress = progress
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url:URL(string: botUrl)!)
        webView.load(request)
        return webView
     }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, isLoading: $isLoading)
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        @Binding var isLoading: Bool
        
        public init(_ parent: WebView, isLoading: Binding<Bool>) {
            self._isLoading = isLoading
            self.parent = parent
        }
        
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            isLoading = true
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLoading = false
            }
            parent.progress = 1.0
        }
        
        public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.progress = Double(webView.estimatedProgress)
        }
    }
    
    
}
