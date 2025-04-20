import Foundation

struct Aula: Identifiable, Equatable, Codable {
    let id: UUID
    var materia: String
    var numero: Int
    var tema: String
    var data: Date
    var dataEstudo: Date? = nil
    var assistida: Bool = false
    var questoesFeitas: Int? = nil
    var acertos: Int? = nil
    var ultimaRevisao: Date? = nil
    var revisoesFeitas: Int = 0

    init(
        id: UUID = UUID(),
        materia: String,
        numero: Int,
        tema: String,
        data: Date,
        dataEstudo: Date? = nil,
        assistida: Bool = false,
        questoesFeitas: Int? = nil,
        acertos: Int? = nil,
        ultimaRevisao: Date? = nil,
        revisoesFeitas: Int = 0
    ) {
        self.id = id
        self.materia = materia
        self.numero = numero
        self.tema = tema
        self.data = data
        self.dataEstudo = dataEstudo
        self.assistida = assistida
        self.questoesFeitas = questoesFeitas
        self.acertos = acertos
        self.ultimaRevisao = ultimaRevisao
        self.revisoesFeitas = revisoesFeitas
    }
}
