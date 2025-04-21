import SwiftUI

struct AdicionarAulaVestibularView: View {
    @ObservedObject var viewModel: PlannerVestibularViewModel
    @Environment(\.dismiss) var dismiss

    @State private var materia = ""
    @State private var numero = 1
    @State private var tema = ""
    @State private var data = Date()

    var body: some View {
        NavigationView {
            Form {
                TextField("Matéria", text: $materia)
                TextField("Número", value: $numero, formatter: NumberFormatter())
                TextField("Tema", text: $tema)
                DatePicker("Data", selection: $data, displayedComponents: .date)
            }
            .navigationTitle("Adicionar Aula")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") {
                        let nova = Aula(materia: materia, numero: numero, tema: tema, data: data)
                        viewModel.aulas.append(nova)
                        dismiss()
                    }
                }
            }
        }
    }
}
