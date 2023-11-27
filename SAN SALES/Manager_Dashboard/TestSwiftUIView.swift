//
//  TestSwiftUIView.swift
//  SAN SALES
//
//  Created by San eforce on 21/11/23.
//

import SwiftUI

struct TestSwiftUIView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.blue)
        }
    }
}

struct TestSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TestSwiftUIView()
    }
}
