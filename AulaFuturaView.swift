import SwiftUI

struct AulaFuturaView: View {
    let aula: Aula
    let marcarAssistida: () -> Void
    let forcarParaHoje: () -> Void

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
                        .foregroundColor(aula.data < Date() ? .red : .secondary)
                }

                Spacer()

                Button(action: marcarAssistida) {
                    Text(aula.assistida ? "✅" : "⬜️")
                        .font(.title2)
                }
            }

            Button(action: forcarParaHoje) {
                Text("📌 Trazer para Hoje")
                    .font(.caption)
                    .padding(6)
                    .background(Color.blue.opacity(0.15))
                    .cornerRadius(8)
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
