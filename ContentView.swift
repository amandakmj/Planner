import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PlannerPFView()
                .tabItem {
                    Label("PF", systemImage: "shield.lefthalf.fill")
                }

            PlannerVestibularView()
                .tabItem {
                    Label("Vestibular", systemImage: "graduationcap.fill")
                }

            AdicionarView()
                .tabItem {
                    Label("Adicionar", systemImage: "plus.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
