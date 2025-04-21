import SwiftUI

struct AdicionarAulaCustomView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PlannerCustomViewModel

    @State private var materia = ""
    @State private var numero = ""
    @State private var tema = ""
    @State private var data = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nova Aula")) {
                    TextField("Matéria", text: $materia)
                    TextField("Número da Aula", text: $numero)
                        .keyboardType(.numberPad)
                    TextField("Tema", text: $tema)
                    DatePicker("Data da Aula", selection: $data, displayedComponents: .date)
                }
            }
            .navigationTitle("Adicionar Aula")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        if let numeroInt = Int(numero) {
                            let nova = Aula(
                                materia: materia,
                                numero: numeroInt,
                                tema: tema,
                                data: data
                            )
                            viewModel.aulas.append(nova)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
