//
//  ContentView.swift
//  todo
//
//  Created by 彭熙 on 2021/7/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            Button(action: {
                
            }){
                Text("button")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                
            }
            .cornerRadius(10)
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 8")
        }
    }
}
