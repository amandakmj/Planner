import SwiftUI

struct PlannerPFView: View {
    @ObservedObject var viewModel = PlannerViewModel()
    @State private var mostrarProximas = false
    @State private var mostrarAdicionar = false

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
                            let cicloAtual = max(aula.revisoesFeitas, 0)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("📚 \(aula.materia) - Aula \(aula.numero)")
                                    .bold()
                                Text("📖 \(aula.tema)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("📅 Estudada em: \(formatarData(aula.dataEstudo ?? Date()))")
                                    .font(.caption)
                                Text("🔁 Revisão \(cicloAtual) de 6")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.orange)

                                Button("✅ Marcar Revisado") {
                                    viewModel.marcarRevisao(aula)
                                }
                                .font(.caption)
                                .padding(6)
                                .background(Color.green.opacity(0.15))
                                .cornerRadius(8)
                            }
                            .padding()
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(12)
                        }

                        Divider()
                    }

                    // 📌 Aulas Pendentes
                    Text("📌 Aulas Pendentes")
                        .font(.title2)
                        .bold()

                    ForEach(viewModel.aulasDoDia()) { aula in
                        aulaCard(aula)
                    }

                    Divider()

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
                        aulaCard(aula)
                    }

                    NavigationLink(destination: ProximasAulasView(viewModel: viewModel), isActive: $mostrarProximas) {
                        EmptyView()
                    }
                    .hidden()
                }
                .padding()
            }
            .navigationTitle("Planner PF")
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
                AdicionarAulaView(viewModel: viewModel)
            }
        }
    }

    @ViewBuilder
    private func aulaCard(_ aula: Aula) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading) {
                    Text("📚 \(aula.materia) - Aula \(aula.numero)")
                        .bold()
                    Text("📖 Tema: \(aula.tema)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("📆 Data da Aula: \(formatarData(aula.data))")
                        .font(.caption)
                        .foregroundColor(!aula.assistida && aula.data < Calendar.current.startOfDay(for: Date()) ? .red : .secondary)
                }

                Spacer()

                Toggle("", isOn: Binding<Bool>(
                    get: {
                        viewModel.aulas.first(where: { $0.id == aula.id })?.assistida ?? false
                    },
                    set: { novoValor in
                        if let index = viewModel.aulas.firstIndex(where: { $0.id == aula.id }) {
                            viewModel.aulas[index].assistida = novoValor
                            viewModel.aulas[index].dataEstudo = novoValor ? Date() : nil
                        }
                    }
                ))
                .labelsHidden()
            }

            if aula.assistida {
                HStack {
                    Text("📅 Estudada em:")
                    Text(aula.dataEstudo.map { formatarData($0) } ?? "-")
                        .bold()
                }
                .font(.caption)

                HStack {
                    Text("📝 Questões:")
                    TextField("Feitas", value: Binding(
                        get: { aula.questoesFeitas ?? 0 },
                        set: { viewModel.atualizarQuestoes(aula, feitas: $0, acertos: aula.acertos) }
                    ), formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)

                    Text("✔️ Acertos:")
                    TextField("Acertos", value: Binding(
                        get: { aula.acertos ?? 0 },
                        set: { viewModel.atualizarQuestoes(aula, feitas: aula.questoesFeitas, acertos: $0) }
                    ), formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)

                    if let feitas = aula.questoesFeitas, let acertos = aula.acertos, feitas > 0 {
                        let porcentagem = (Double(acertos) / Double(feitas)) * 100
                        Text("🎯 \(String(format: "%.0f", porcentagem))%")
                            .bold()
                            .foregroundColor(.green)
                    }
                }
                .font(.caption)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    func formatarData(_ data: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: data)
    }
}
