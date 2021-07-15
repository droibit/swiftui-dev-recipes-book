import SwiftUI

struct Canvas: View {
    @State private var tmpDrawPoints = DrawPoints(points: [], color: .red)
    @Binding var endedDrawPoints: [DrawPoints]
    @Binding var selectedColor: DrawColor
    @Binding var canvasRect: CGRect

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .border(Color.black, width: 2)
                    .onAppear {
                        canvasRect = geometry.frame(in: .local)
                    }

                ForEach(endedDrawPoints) { data in
                    Path { path in
                        path.addLines(data.points)
                    }
                    .stroke(data.color, lineWidth: 10)
                }

                Path { path in
                    path.addLines(tmpDrawPoints.points)
                }
                .stroke(selectedColor(), lineWidth: 10)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        tmpDrawPoints.color = selectedColor()
                        guard !tmpDrawPoints.points.isEmpty else {
                            tmpDrawPoints.points.append(value.location)
                            return
                        }

                        if let lastPoint = tmpDrawPoints.points.last,
                           filterDistance(startPoint: lastPoint, endPoint: value.location)
                        {
                            tmpDrawPoints.points.append(value.location)
                        }
                    }.onEnded { _ in
                        endedDrawPoints.append(tmpDrawPoints)
                        tmpDrawPoints = DrawPoints(points: [], color: selectedColor())
                    }
            )
        }
    }

    private func filterDistance(startPoint: CGPoint, endPoint: CGPoint) -> Bool {
        let distance = sqrt(pow(Double(startPoint.x) - Double(endPoint.x), 2) + pow(Double(startPoint.y) - Double(endPoint.y), 2))
        return distance <= 50
    }
}

struct Canvas_Previews: PreviewProvider {
    struct CanvasContainer: View {
        @State private var endedDrawPoints: [DrawPoints] = []
        @State private var selectedColor: DrawColor = .red
        @State var canvasRect: CGRect = .zero

        var body: some View {
            Canvas(
                endedDrawPoints: $endedDrawPoints,
                selectedColor: $selectedColor,
                canvasRect: $canvasRect
            )
        }
    }

    static var previews: some View {
        CanvasContainer()
    }
}
