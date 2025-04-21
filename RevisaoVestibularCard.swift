import SwiftUI

struct RevisaoVestibularCard: View {
    let aula: Aula
    let marcarRevisado: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("📚 \(aula.materia) - Aula \(aula.numero)")
                .bold()
            Text("📖 \(aula.tema)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("📅 Estudada em: \(formatarData(aula.dataEstudo ?? Date()))")
                .font(.caption)
            Text("🔁 Revisão \(aula.revisoesFeitas) de 6")
                .font(.caption)
                .bold()
                .foregroundColor(.orange)

            Button("✅ Marcar Revisado") {
                marcarRevisado()
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

    private func formatarData(_ data: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: data)
    }
}
