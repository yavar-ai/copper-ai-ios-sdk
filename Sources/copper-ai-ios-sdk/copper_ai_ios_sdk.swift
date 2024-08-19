import SwiftUI

@available(iOS 13.0, *)
public struct CopperAiBot<Label:View> : View{
    let url: String
    let content : ()->Label
    
    public init(url: String, content: @escaping () -> Label) {
        self.url = url
        self.content = content
    }

    public var body: some View{
        if #available(iOS 16.0, *) {
            NavigationStack{
                NavigationLink(destination: WebViewContainer(url: url),label: content)
            }
        } else {
            NavigationView{
                NavigationLink(destination: WebViewContainer(url: url),label: content)
            }
        }
    }
}
