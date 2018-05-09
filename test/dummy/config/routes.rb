Rails.application.routes.draw do
  mount Bunyan::Engine => "/bunyan"
end
