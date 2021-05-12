require 'pry'
require 'json'

class Application

  def call(env)
    response = Rack::Response.new
    request = Rack::Request.new env

    
    if request.path == '/board_games' && request.get?
      return [
        200,
        { 'Content-Type' => 'application/json' },
        [BoardGame.all.to_json]
      ]
    elsif request.path.match(/board_games/) && request.get?
      id = request.path.split('/')[2]
      board_game = BoardGame.find(id)
      return [
        200,
        { 'Content-Type' => 'application/json' },
        [board_game.to_json]
      ]
    elsif request.path == '/board_games' && request.post?
      data = JSON.parse request.body.read
      new_board_game = BoardGame.create data
      return [
        201,
        { 'Content-Type' => 'application/json' },
        [new_board_game.to_json]
      ]
    elsif request.path.match(/board_games/) && request.patch?
      id = request.path.split('/')[2]
      board_game = BoardGame.find(id)

      data = JSON.parse request.body.read
      board_game.update(data)

      return [
        200,
        { 'Content-Type' => 'application/json' },
        [board_game.to_json]
      ]
    elsif request.path.match(/board_games/) && request.delete?
      id = request.path.split('/')[2]
      board_game = BoardGame.find(id)
      board_game.destroy
      return [204, {}, ['']]
    else
      return [404, {}, ['']]
    end
    
  end

end
