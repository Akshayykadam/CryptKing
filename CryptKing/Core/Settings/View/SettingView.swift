import SwiftUI

struct SettingView: View {
    let contactMeURL = URL(string: "https://www.linkedin.com/in/akshaykadam96/")!
    
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("Developer")) {
                    VStack(alignment: .leading, spacing: 20) {
                        Image("pp")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                        
                        Text("Akshay Kadam")
                            .font(.title2)
                        
                        Divider()
                        
                        Text("Self-taught software developer learning Swift and SwiftUI. Experienced in app and game development. Passionate about crafting intuitive digital experiences.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 10)
                        
                        Divider()

                        
                        HStack {
                            Image(systemName: "phone")
                                .foregroundColor(.blue)
                            Text("+91 7020840564")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.blue)
                            Text("akshayykadam96@gmail.com")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        
                        
                        
                    }
                    .padding()
                    
                }
                Button(action: { UIApplication.shared.open(contactMeURL)
                }) {
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                        Text("Contact Me")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())

                
            }
            
            .listStyle(GroupedListStyle())
            .navigationTitle("About")
        }
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
