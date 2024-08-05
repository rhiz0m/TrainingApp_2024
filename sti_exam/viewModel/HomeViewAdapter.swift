//
//  HomeViewAdapter.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-02.
//

import Foundation

class HomeViewAdapter: ObservableObject {

    @Published var bottomBarViewModel: BottomBarView.ViewModel?
    @Published var exerciseListViewModel: ExerciseListView.ViewModel?
    @Published var createProgramViewModel: CreateProgramView.ViewModel?
    @Published var mapViewModel: MapView.ViewModel?
    @Published var searchViewModel: SearchView.ViewModel?
    @Published var apiResponse: [ExerciseAPI] = []
    @Published var topBarViewModel: TopBarView.ViewModel?
    @Published var customBottomBarViewModel: CustomBottomBar.ViewModel?
    @Published var updateProgramViewModel: UpdateProgramView.ViewModel?
    @Published var setTitle = ""
    @Published var repsTitle = ""
    
    var authDbViewAdapter: AuthDbViewAdapter
    var exerciseViewModel: ExerciseFormCell.ViewModel
    var trainingRecordViewModel: TrainingRecordFormCell.ViewModel
    let customDateFormatter = CustomDateFormatter()
    
    init(authDbViewAdapter: AuthDbViewAdapter) {
        self.authDbViewAdapter = authDbViewAdapter
        
        self.exerciseViewModel = ExerciseFormCell.ViewModel(
            name: LocalizedStrings.name,
            type: LocalizedStrings.type,
            muscleGroups: LocalizedStrings.muscleGroups)
        
        self.trainingRecordViewModel = TrainingRecordFormCell.ViewModel(
            weight: LocalizedStrings.weight,
            setsTitle: LocalizedStrings.sets,
            repsTitle: LocalizedStrings.reps,
            reps: 0,
            sets: 0)
    }
    
    func generateTopBarViewModel() {
        let topBarViewModel = TopBarView.ViewModel(
            image: "logo",
            welcomeTitle: LocalizedStrings.welcome,
            icon: SelectedSystemImages.shared.power,
            logoutAction: {
                self.authDbViewAdapter.logout()
            }
            
        )
        self.topBarViewModel = topBarViewModel
    }
    
    func generateBottomBarViewModel() {
        let exerciseListViewModel = ExerciseListView.ViewModel(
            noExercisesTitle: LocalizedStrings.noExercises,
            typeTitle: LocalizedStrings.type,
            muscleGroupsTitle: LocalizedStrings.muscleGroups,
            weightTitle: LocalizedStrings.weight,
            setsTitle: LocalizedStrings.sets,
            repsTitle: LocalizedStrings.reps,
            totalRepsTitle: LocalizedStrings.totalReps,
            totalWeightTitle: LocalizedStrings.totalWeight,
            arrowIcon: SelectedSystemImages.shared.arrowRightCircle,
            trashIcon: SelectedSystemImages.shared.trash,
            deleteAction: { exercise in
                self.authDbViewAdapter.deleteProgram(exercise: exercise)
            }
        )
        let createProgramViewModel = CreateProgramView.ViewModel(
            saveTitle: LocalizedStrings.save,
            categoryTitle: LocalizedStrings.usersExercise,
            exerciceFormCell: self.exerciseViewModel,
            trainingRecordFormCell: self.trainingRecordViewModel,
            saveExerciseAction: { exercise in
                self.authDbViewAdapter.saveProgramToDb(userExercise: exercise)
            }
        )
        let searchViewModel = SearchView.ViewModel(
            nameTitle: LocalizedStrings.name,
            typeTitle: LocalizedStrings.type,
            muscleTitle: LocalizedStrings.muscle,
            equipmentTitle: LocalizedStrings.equipment,
            difficultyTitle: LocalizedStrings.difficulty,
            instructionsTitle: LocalizedStrings.instructions,
            title: "\(LocalizedStrings.muscleGroups)...",
            imageName: "gym_woman",
            icon: SelectedSystemImages.shared.magnifyingGlass,
            apiAction: { [weak self] muscle in
                self?.searchExercisesAPI(muscle: muscle)
            }
        )
        
        let mapViewModel = MapView.ViewModel(
            markerTitle: LocalizedStrings.markerTitle,
            icon: SelectedSystemImages.shared.paperPlane,
            textFeildLabel: LocalizedStrings.searchGym)
        
        self.bottomBarViewModel = BottomBarView.ViewModel(
            customBottomBarViewModel: CustomBottomBar.ViewModel(
                listTitle: LocalizedStrings.list,
                addTitle: LocalizedStrings.add,
                searchTitle: LocalizedStrings.search,
                mapTitle: LocalizedStrings.map,
                listIcon: SelectedSystemImages.shared.list,
                addIcon: SelectedSystemImages.shared.add,
                searchIcon: SelectedSystemImages.shared.search,
                mapIcon: SelectedSystemImages.shared.map,
                tabBarItems: [
                    (SelectedSystemImages.shared.list, LocalizedStrings.list),
                    (SelectedSystemImages.shared.add, LocalizedStrings.add),
                    (SelectedSystemImages.shared.search, LocalizedStrings.search),
                    (SelectedSystemImages.shared.map, LocalizedStrings.map)
                ]
            ),
            createProgramViewModel: createProgramViewModel,
            searchViewModel: searchViewModel,
            exerciseListViewModel: exerciseListViewModel,
            mapViewModel: mapViewModel
            
        )
    }
    
    func generateUpdateProgramViewModel() {
        
        let updateViewModel = UpdateProgramView.ViewModel(
            updateExercisesTitle: LocalizedStrings.updateExercises,
            updateTitle: LocalizedStrings.update,
            categoryTitle: LocalizedStrings.usersExercise,
            exerciceFormCell: self.exerciseViewModel,
            trainingRecordFormCell: self.trainingRecordViewModel,
            
            updateExerciseAction: { exercise in
                self.authDbViewAdapter.saveProgramToDb(userExercise: exercise)
            }
        )
        self.updateProgramViewModel = updateViewModel
    }
    
    func searchExercisesAPI(muscle: String) {
        guard let muscleEncoded = muscle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.api-ninjas.com/v1/exercises?muscle=\(muscleEncoded)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(auth().API_KEY, forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode([ExerciseAPI].self, from: data)
                
                let exerciseDetails = result.map { exercise in
                    return ExerciseAPI(
                        id: UUID(),
                        name: exercise.name,
                        type: exercise.type,
                        muscle: exercise.muscle,
                        equipment: exercise.equipment,
                        difficulty: exercise.difficulty,
                        instructions: exercise.instructions
                    )
                }
                
                DispatchQueue.main.async {
                    self.apiResponse = exerciseDetails
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
}
