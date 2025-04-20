import SwiftUI

struct AdicionarAulaView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PlannerViewModel

    @State private var materia = ""
    @State private var numero = ""
    @State private var tema = ""
    @State private var data = Date()

    var body: some View {
        NavigationView {
            Form {
                TextField("Matéria", text: $materia)
                TextField("Número da Aula", text: $numero)
                    .keyboardType(.numberPad)
                TextField("Tema", text: $tema)
                DatePicker("Data da Aula", selection: $data, displayedComponents: .date)
            }
            .navigationTitle("Adicionar Aula")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        if let numeroInt = Int(numero) {
                            let novaAula = Aula(
                                materia: materia,
                                numero: numeroInt,
                                tema: tema,
                                data: data
                            )
                            viewModel.aulas.append(novaAula)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}
