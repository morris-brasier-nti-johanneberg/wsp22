require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'sinatra/reloader'

enable :sessions

get('/') do
    slim(:start)
end

get('/workouts') do
    id = session[:id].to_i
    db = SQLite3::Database.new("db/träning.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM workouts WHERE user_id = ?",id)
    p "Alla workouts från result #{result}"
    slim(:"workouts/index", locals:{workouts:result})
end

get("/workouts/:id") do
    id = params[:id].to_i
    db = SQLite3::Database.new("db/träning.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM workouts WHERE id = ?",id).first
    p "result1 är #{result}"
    result2 = db.execute("SELECT * FROM exercises WHERE id = (SELECT exercise_id FROM workout_exercise_rel WHERE workout_id = (SELECT id FROM workouts WHERE id = ?))",id)
    p "resultat2 är #{result2}"
    slim(:"workouts/show", locals:{result:result,result2:result2})
end

get('/workouts/new') do
    slim(:"workouts/new")
end

get('/info') do
    slim(:info)
end

get('/register') do
    slim(:register)
end

post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]

    if (password == password_confirm)
        password_digest = BCrypt::Password.create(password)
        db = SQLite3::Database.new('db/träning.db')
        db.execute("INSERT INTO users (username, password) VALUES (?,?)", username, password_digest)
        redirect('/register')
    else
        "Passwords does not match!"
    end
end

get('/show_login') do
    slim(:login)
end

post('/login') do
    username = params[:username]
    password = params[:password]
    db = SQLite3::Database.new('db/träning.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM users WHERE username = ?",username).first
    pwdigest = result["password"]
    id = result["id"]

    if BCrypt::Password.new(pwdigest) == password
        session[:id] = id
        redirect('/workouts') 
    else
        "Wrong password!"
    end
end