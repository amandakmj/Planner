import SwiftUI

struct AdicionarView: View {
    @State private var nome = ""
    @State private var iniciar = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Criar novo Planner")
                    .font(.title2)
                    .bold()

                TextField("Nome do novo planner", text: $nome)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    iniciar = true
                }) {
                    Text("✨ Criar Planner")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("Adicionar")
            .background(
                NavigationLink(destination: PlannerCustomView(), isActive: $iniciar) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }
}
