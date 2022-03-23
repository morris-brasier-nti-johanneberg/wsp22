require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'sinatra/reloader'

enable :sessions

get('/') do
    slim(:start)
end

get('/workouts/new') do
    slim(:"workouts/new")
end

get('/workouts') do
    db = SQLite3::Database.new("db/träning.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM workouts") 
    p result
    slim(:"workouts/index", locals:{workouts: result})
end

get('/workouts/:id') do
    slim(:"workouts/show")
end

get('/info') do
    slim(:info)
end

get('/log_in') do
    slim(:log_in)
end

get('/register') do
    slim(:register)
end

post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]

    if password == password_confirm
        password_digest = BCrypt::Password.create(password)
        db = SQLite3::Database.new('db/träning.db')
        db.execute("INSERT INTO users (username,password) VALUES (?,?)", username, password)
        redirect('/register')
    else
        "Passwords does not match!"
    end
end