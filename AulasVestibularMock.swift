import Foundation

struct AulasVestibularMock {
    static let lista: [Aula] = [
        Aula(materia: "Biologia", numero: 1, tema: "Citologia: membranas, organelas e núcleo", data: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
        Aula(materia: "Química", numero: 1, tema: "Ligações químicas", data: Calendar.current.date(byAdding: .day, value: 2, to: Date())!),
        Aula(materia: "História", numero: 1, tema: "Brasil Colônia", data: Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
        Aula(materia: "Geografia", numero: 1, tema: "Climas do Brasil", data: Calendar.current.date(byAdding: .day, value: 4, to: Date())!),
        Aula(materia: "Física", numero: 1, tema: "Cinemática: MRU e MRUV", data: Calendar.current.date(byAdding: .day, value: 5, to: Date())!),
        Aula(materia: "Matemática", numero: 1, tema: "Funções do 1º grau", data: Calendar.current.date(byAdding: .day, value: 6, to: Date())!),
        Aula(materia: "Português", numero: 1, tema: "Funções da linguagem", data: Calendar.current.date(byAdding: .day, value: 7, to: Date())!)
    ]
}
