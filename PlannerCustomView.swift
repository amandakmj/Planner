import SwiftUI

struct PlannerCustomView: View {
    @ObservedObject var viewModel = PlannerCustomViewModel()
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
                            }
                        )
                    }

                    Divider()

                    // 📅 Ver Próximas Aulas
                    Button {
                        mostrarProximas = true
                    } label: {
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

                    // 🔁 Link para Próximas Aulas
                    NavigationLink(destination: ProximasAulasCustomView(viewModel: viewModel), isActive: $mostrarProximas) {
                        EmptyView()
                    }
                    .hidden()
                }
                .padding()
            }
            .navigationTitle("Planner Novo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        mostrarAdicionar = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $mostrarAdicionar) {
                AdicionarAulaCustomView(viewModel: viewModel)
            }
        }
    }
}
