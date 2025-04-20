import SwiftUI

struct AulaCardView: View {
    var aula: Aula
    var onToggle: () -> Void
    var onQuestoesUpdate: (Int?, Int?) -> Void

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
                    set: { _ in onToggle() }
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
                        set: { onQuestoesUpdate($0, aula.acertos) }
                    ), formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)

                    Text("✔️ Acertos:")
                    TextField("Acertos", value: Binding(
                        get: { aula.acertos ?? 0 },
                        set: { onQuestoesUpdate(aula.questoesFeitas, $0) }
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

    private func formatarData(_ data: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: data)
    }
}
