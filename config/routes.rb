HacketyHackCom::Application.routes.draw do
  #match '/auth/:provider/callback' => 'authentications#create'
  # the statement on the next line was moved below to line 40.
  #devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  
  resources :lessons, :only => [:index, :show]

  resources :questions do
    resources :answers
  end

  resources :blog, :controller => "blog" do
    match "admin", :on => :collection, :controller => "blog", :action => "admin"
  end

  get "/downloads/latest/:platform", :to => "static#download", :as => 'downloads'
  get "/downloads/latest", :to => "static#download", :as => 'download'
  match "/download" => redirect("/downloads/latest")

  scope '/support', :as => 'support' do
    resources :questions, :controller => 'questions' do
      resources :answers
    end
  end

  constraints(ApiConstraint) do
    match '/' => 'static#api_root'
    match '/versions/newest' => 'static#newest_version', :as => "newest_version"
    scope :module => "Api" do
      resources :rels, :only => [:index, :show]
        resources :programs
    end
  end

  resources :programs, :only => [:index, :show]

  # TODO: Find out what happens in devise/sessions#new and devise/sessions#destroy
  # match'users/auth/:provider' to: 'omniauth_callbacks'
  
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  devise_for :users
  devise_scope :user do
  get "login" => "devise/sessions#new", :as => "login"
  get "logout" => "devise/sessions#destroy", :as => "logout"
  end

  resources :users, :constraints => { :id => /.*/ }, :only => :show do
    get "following" => "users#following", :as => :following
    get "followers" => "users#followers", :as => :followers
    post "follow" => "users#follow", :as => :follow
    post "unfollow" => "users#unfollow", :as => :unfollow

    resources :programs
  end

  match '/auth/:provider/callback', :to => 'sessions#create'
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  devise_scope :user do
    get "login" => "devise/sessions#new", :as => "login"
    get "logout" => "devise/sessions#destroy", :as => "logout"
  end
  # match ':user_id/:slug', :to => "programs#show", :as => :program

  match 'faq' => 'static#faq'
  root :to => "static#root"

end
