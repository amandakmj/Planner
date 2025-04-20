import SwiftUI

struct ProximasAulasView: View {
    @ObservedObject var viewModel: PlannerViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("📅 Próximas Aulas")
                    .font(.title2)
                    .bold()

                let futuras = viewModel.aulasFuturas()

                ForEach(futuras) { aula in
                    AulaFuturaView(
                        aula: aula,
                        marcarAssistida: {
                            viewModel.marcarAssistidaPorID(aula.id)
                        },
                        forcarParaHoje: {
                            viewModel.forcarParaHojePorID(aula.id)
                        }
                    )
                }

                if futuras.isEmpty {
                    Text("Nenhuma aula futura encontrada.")
                        .foregroundColor(.gray)
                        .italic()
                }
            }
            .padding()
        }
        .navigationTitle("Próximas Aulas")
    }
}
