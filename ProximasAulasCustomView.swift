import SwiftUI

struct ProximasAulasCustomView: View {
    @ObservedObject var viewModel: PlannerCustomViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("📅 Próximas Aulas")
                    .font(.title2)
                    .bold()

                let futuras = viewModel.aulasFuturas()

                ForEach(futuras) { aula in
                    AulaVestibularCard(
                        aula: aula,
                        marcarAssistida: { viewModel.marcarAssistidaPorID(aula.id) },
                        atualizarQuestoes: { feitas, acertos in
                            viewModel.atualizarQuestoes(aula, feitas: feitas, acertos: acertos)
                        },
                        forcarParaHoje: { viewModel.forcarParaHojePorID(aula.id) }
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

