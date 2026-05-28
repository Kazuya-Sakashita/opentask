Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :me, only: [ :show ], controller: :me
      resources :todos, param: :public_id, only: %i[index show create update destroy]
    end
  end
end
