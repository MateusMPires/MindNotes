//
//  NewPage.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 16/07/25.
//

import SwiftUI

struct NewPage: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            
            Text("Mateus, estou muito feliz que você voltou. Depois de 4 meses você continua sendo um ótimo programador. Eu sei que você se perdeu, em meio a erros e pecados, mas você voltou. Saiba que você sempre foi capaz, e que você ama criar soluções, principalmente em dispositivos Apple. Eu sei que você sentiu rejeição, mas hoje você acabou de dar um enorme passo. O mundo é seu, e só você pode viver a sua vida.")
                .multilineTextAlignment(.center)
            
            Button {
                //
            } label: {
                Text("Clique aqui e seja feliz")
            }
        }
        .padding()
    }
}

#Preview {
    NewPage()
}
