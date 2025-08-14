import UIKit
import Foundation

struct List {
    var title: String
    var text: String
}

enum ListNotifications {
    
    static let listMorning: [List] = [
        List(title: "💥 Bora fazer acontecer!", text: "Comece agora e transforme seu dia em um Big Day!"),
        List(title: "🔥 Você é o dono do seu dia!", text: "Defina suas metas e vá atrás delas sem desculpas."),
        List(title: "🎯 Meta no foco, foco na meta!", text: "Planeje e execute para conquistar ainda mais hoje.")
    ]
    
    static let listAfternoon: [List] = [
        List(title: "💪 Respira fundo e vai pra mais uma!", text: "Ainda dá tempo de conquistar mais uma vitória."),
        List(title: "☀️ Transforme sua tarde em um Big Day!", text: "Pegue sua lista e marque mais um ✔️ agora mesmo."),
        List(title: "🏆 Pequenas vitórias, grandes conquistas!", text: "Faça mais uma tarefa agora e finalize o dia com orgulho.")
    ]
    
    static let listNight: [List] = [
        List(title: "📊 E aí, qual foi sua maior vitória hoje?", text: "Revise sua lista e veja o quanto você avançou."),
        List(title: "🔑 Feche o dia com chave de ouro!", text: "Finalize aquela última tarefa e celebre o seu progresso."),
        List(title: "🚀 Seu eu do futuro vai agradecer!", text: "O que você fizer agora vai te deixar mais perto dos seus objetivos.")
    ]
}
