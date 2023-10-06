import SwiftUI

struct ApiKeyInputView: View {
    @EnvironmentObject var appData: AppData
    @State private var inputApiKey: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter your OpenAI API Key")
                .font(.headline)

            TextField("API Key", text: $inputApiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                saveApiKey()
            }) {
                Text("Save API Key")
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    private func saveApiKey() {
        appData.openAIApiKey = inputApiKey
    }
}

struct ApiKeyInputView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ApiKeyInputView().environmentObject(AppData())
                .previewDisplayName("Light Mode")
            ApiKeyInputView().environmentObject(AppData()).colorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
