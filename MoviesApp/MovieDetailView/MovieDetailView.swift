//
//  MovieDetailView.swift
//  MoviesApp
//
//  Created by Damodar Namala on 09/05/22.
//

import SwiftUI
import Combine
import Kingfisher

struct MovieDetailPage {
    static func build(with movie: Movie ) -> MovieDetailView {
        MovieDetailView(movieDetailViewModel: MovieDetailViewModel(movie: movie))
    }
}

struct MovieDetailView: View {
    @ObservedObject var movieDetailViewModel: MovieDetailViewModel
    var passthrough = PassthroughSubject<Int, Never>()

    init(movieDetailViewModel: MovieDetailViewModel) {
        self.movieDetailViewModel = movieDetailViewModel
    }
    
    var body: some View {
        LoadingView(isShowing: .constant(movieDetailViewModel.isLoading)) {
            VStack {
                KFImage(movieDetailViewModel.url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(2)
                    .frame( height: 280, alignment: .center)
                    .shadow(color: .white, radius: 8, x: 2, y: 2)
                
                Group {
                    Text(movieDetailViewModel.movieTitle)
                        .font(.headline)
                        .padding(.top, 16)
                    Text(movieDetailViewModel.releaseDate)
                        .font(.body)
                        .foregroundColor(.secondary)
                    Divider()
                        .padding(8)
                }
                Spacer()
                Button {
                    let vm = ViewModel()
                    vm.fetch()
                } label: {
                    Text("Fetch")
                }
                .frame(maxWidth: .infinity,alignment: .center)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movieDetailViewModel: MovieDetailViewModel(movie: Movie.testVar))
    }
}

class ViewModel {
    private var cancellable: AnyCancellable?
    
    func fetch() {
        let url = URL(string: "https://reqres.in/api/users?page=2")!
            URLSession
            .shared
            .dataTask(with: url, completionHandler: { data, reponse, error in
                guard let data = data else {
                    print(error?.localizedDescription)
                    return
                }
                
                let response = String(data: data, encoding: .utf8)
                print(response)
            }).resume()
        
    }
}
struct Post: Decodable {
    var userId: String
    var title: String
    
}

