require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'sinatra/reloader'

get('/') do
    slim(:start)
end

get('/workouts/new') do
    slim(:workouts/new)
end

get('/workouts') do
    slim(:workouts/index) 
end

get('/info') do
    slim(:info)
end

get('/log_in') do
    slim(:log_in)
end