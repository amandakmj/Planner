import Foundation

class PlannerVestibularViewModel: ObservableObject {
    @Published var aulas: [Aula] = [] {
        didSet { salvarAulas() }
    }

    @Published var aulasForcadasParaHoje: Set<UUID> = [] {
        didSet { salvarForcadas() }
    }

    init() {
        carregarAulas()
    }

    func atualizarQuestoes(_ aula: Aula, feitas: Int?, acertos: Int?) {
        if let index = aulas.firstIndex(of: aula) {
            aulas[index].questoesFeitas = feitas
            aulas[index].acertos = acertos
        }
    }

    func aulasDoDia() -> [Aula] {
        let hoje = Calendar.current.startOfDay(for: Date())
        return aulas.filter {
            !$0.assistida && (
                Calendar.current.isDate($0.data, inSameDayAs: hoje) ||
                $0.data < hoje ||
                aulasForcadasParaHoje.contains($0.id)
            )
        }
    }

    func aulasFuturas() -> [Aula] {
        let hoje = Calendar.current.startOfDay(for: Date())
        return aulas.filter {
            !$0.assistida &&
            !Calendar.current.isDate($0.data, inSameDayAs: hoje) &&
            $0.data > hoje &&
            !aulasForcadasParaHoje.contains($0.id)
        }
    }

    func aulasAssistidas() -> [Aula] {
        aulas.filter { $0.assistida }
             .sorted { ($0.dataEstudo ?? Date.distantPast) > ($1.dataEstudo ?? Date.distantPast) }
    }

    func aulasParaRevisarHoje() -> [Aula] {
        let hoje = Calendar.current.startOfDay(for: Date())
        let ciclos: [Int] = [1, 7, 21, 30, 60, 90, 120]

        return aulas.filter { aula in
            guard let estudo = aula.dataEstudo else { return false }

            if aula.revisoesFeitas == 0 {
                return Calendar.current.isDate(estudo, inSameDayAs: hoje)
            }

            let revisoesPendentes = ciclos.prefix(while: { $0 > aula.revisoesFeitas })

            for dias in revisoesPendentes {
                let dataEsperada = Calendar.current.date(byAdding: .day, value: dias, to: estudo)!
                let jaRevisou = aula.ultimaRevisao != nil && Calendar.current.isDate(aula.ultimaRevisao!, inSameDayAs: dataEsperada)
                let hojeEhRevisao = Calendar.current.isDate(dataEsperada, inSameDayAs: hoje)

                if hojeEhRevisao && !jaRevisou {
                    return true
                }
            }

            return false
        }
    }

    func marcarRevisao(_ aula: Aula) {
        if let index = aulas.firstIndex(of: aula) {
            aulas[index].ultimaRevisao = Date()
            aulas[index].revisoesFeitas += 1
        }
    }

    func marcarAssistidaPorID(_ id: UUID) {
        if let index = aulas.firstIndex(where: { $0.id == id }) {
            aulas[index].assistida.toggle()
            if aulas[index].assistida {
                aulas[index].dataEstudo = Date()
            } else {
                aulas[index].dataEstudo = nil
                aulas[index].revisoesFeitas = 0
                aulas[index].ultimaRevisao = nil
            }
        }
    }

    func forcarParaHoje(_ aula: Aula) {
        aulasForcadasParaHoje.insert(aula.id)
    }

    func forcarParaHojePorID(_ id: UUID) {
        aulasForcadasParaHoje.insert(id)
    }

    func desfazerForcarParaHoje(_ aula: Aula) {
        aulasForcadasParaHoje.remove(aula.id)
    }
    func removerAula(_ id: UUID) {
        if let index = aulas.firstIndex(where: { $0.id == id }) {
            aulas.remove(at: index)
        }
    }


    // MARK: - Persistência

    private let aulasKey = "aulas_vestibular_salvas"
    private let forcadasKey = "aulas_vestibular_forcadas"

    private func salvarAulas() {
        if let data = try? JSONEncoder().encode(aulas) {
            UserDefaults.standard.set(data, forKey: aulasKey)
        }
    }

    private func carregarAulas() {
        if let data = UserDefaults.standard.data(forKey: aulasKey),
           let decoded = try? JSONDecoder().decode([Aula].self, from: data) {
            self.aulas = decoded
        } else {
            self.aulas = AulasVestibularMock.lista
        }

        if let savedForcadas = UserDefaults.standard.array(forKey: forcadasKey) as? [String] {
            self.aulasForcadasParaHoje = Set(savedForcadas.compactMap { UUID(uuidString: $0) })
        }
    }

    private func salvarForcadas() {
        let ids = aulasForcadasParaHoje.map { $0.uuidString }
        UserDefaults.standard.set(ids, forKey: forcadasKey)
    }
}
