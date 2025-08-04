import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MemoryGameViewModel()

    let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 4)

    var body: some View {
        VStack {
            Text("Memory Card Game")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            Spacer(minLength: 40) 

            GeometryReader { geometry in
                let spacing: CGFloat = 20
                let totalSpacing = spacing
                let cardSize = (geometry.size.width - totalSpacing - 32) / 4

                VStack {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(viewModel.cards.indices, id: \.self) { index in
                            let card = viewModel.cards[index]

                            ZStack {
                                if card.isFaceUP || card.isMatched {
                                    Text(card.imageName)
                                        .font(.system(size: 60))
                                        .scaleEffect(card.isFaceUP ? 1.0 : 0.3)
                                        .opacity(card.isFaceUP ? 1 : 0)
                                        .animation(.easeInOut(duration: 0.3), value: card.isFaceUP)
                                        .frame(width: cardSize, height: cardSize)
                                        .background(Color.orange.opacity(0.3))
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.orange, lineWidth: 3)
                                        )
                                    
                                } else {
                                    Rectangle()
                                        .fill(Color.orange)
                                        .frame(width: cardSize, height: cardSize)
                                        .cornerRadius(8)
                                }
                            }
                            .scaleEffect(card.isFaceUP ? 1.1 : 1.0)
                            .opacity(1)
                            .animation(.easeInOut(duration: 0.3), value: card.isMatched)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: card.isFaceUP)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.flipCard(at: index)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(width: geometry.size.width)
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {
                withAnimation {
                    viewModel.resetGame()
                }
            }) {
                Text("Restart Game")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .bold()
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

