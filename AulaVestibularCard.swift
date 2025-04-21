import SwiftUI

struct AulaVestibularCard: View {
    var aula: Aula
    var marcarAssistida: () -> Void
    var atualizarQuestoes: (Int?, Int?) -> Void = { _, _ in }
    var forcarParaHoje: (() -> Void)? = nil

    var body: some View {
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
                    get: { aula.assistida },
                    set: { _ in marcarAssistida() }
                ))
                .labelsHidden()
            }

            if let forcar = forcarParaHoje {
                Button(action: forcar) {
                    Text("📌 Trazer para Hoje")
                        .font(.caption)
                        .padding(6)
                        .background(Color.blue.opacity(0.15))
                        .cornerRadius(8)
                }
            }

            if aula.assistida {
                VStack(alignment: .leading, spacing: 4) {
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
                            set: { atualizarQuestoes($0, aula.acertos) }
                        ), formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 50)

                        Text("✔️ Acertos:")
                        TextField("Acertos", value: Binding(
                            get: { aula.acertos ?? 0 },
                            set: { atualizarQuestoes(aula.questoesFeitas, $0) }
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
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private func formatarData(_ data: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: data)
    }
}
