import SwiftUI

struct PlannerVestibularView: View {
    @ObservedObject var viewModel = PlannerVestibularViewModel()
    @State private var mostrarAdicionar = false
    @State private var mostrarProximas = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // 🔁 Revisões de Hoje
                    if !viewModel.aulasParaRevisarHoje().isEmpty {
                        Text("🔁 Revisões de Hoje")
                            .font(.title2)
                            .bold()

                        ForEach(viewModel.aulasParaRevisarHoje()) { aula in
                            RevisaoVestibularCard(aula: aula) {
                                viewModel.marcarRevisao(aula)
                            }
                        }

                        Divider()
                    }

                    // 📌 Aulas Pendentes
                    Text("📌 Aulas Pendentes")
                        .font(.title2)
                        .bold()

                    ForEach(viewModel.aulasDoDia()) { aula in
                        AulaVestibularCard(
                            aula: aula,
                            marcarAssistida: { viewModel.marcarAssistidaPorID(aula.id) },
                            atualizarQuestoes: { feitas, acertos in
                                viewModel.atualizarQuestoes(aula, feitas: feitas, acertos: acertos)
                            },
                            remover: { viewModel.removerAula(aula.id) }
                        )

                    }

                    Divider()

                    // 📅 Ver Próximas Aulas
                    Button(action: {
                        mostrarProximas = true
                    }) {
                        HStack {
                            Spacer()
                            Text("📅 Ver Próximas Aulas")
                                .bold()
                                .padding()
                            Spacer()
                        }
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }

                    Divider()

                    // ✅ Aulas Estudadas
                    Text("✅ Aulas Estudadas")
                        .font(.title2)
                        .bold()

                    ForEach(viewModel.aulasAssistidas()) { aula in
                        AulaVestibularCard(
                            aula: aula,
                            marcarAssistida: { viewModel.marcarAssistidaPorID(aula.id) },
                            atualizarQuestoes: { feitas, acertos in
                                viewModel.atualizarQuestoes(aula, feitas: feitas, acertos: acertos)
                            }
                        )
                    }

                    NavigationLink(destination: ProximasAulasVestibularView(viewModel: viewModel), isActive: $mostrarProximas) {
                        EmptyView()
                    }
                    .hidden()
                }
                .padding()
            }
            .navigationTitle("Planner Vestibular")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        mostrarAdicionar = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $mostrarAdicionar) {
                AdicionarAulaVestibularView(viewModel: viewModel)
            }
        }
    }

    private func formatarData(_ data: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: data)
    }
}
