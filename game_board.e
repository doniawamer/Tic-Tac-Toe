note
	description: "Summary description for {GAME_BOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_BOARD

inherit
	ANY
		redefine
			out
		end

create {TIC_TAC}
	new_board


feature --creation
	new_board
		do
			create game_board.make_empty
			create state.make_from_string("")
			empty_board
		end

feature
	game_board	: ARRAY[STRING]
	state		: STRING

feature -- commands
	empty_board
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > 9
			loop
				game_board.force("_", i)
				i := i + 1
			end
		end

	player_move(a_player : PLAYER; a_button: INTEGER)
		do
			game_board.force (a_player.pawn, a_button)
		end
	reset_move(a_button: INTEGER)
		do
			game_board.force ("_", a_button)
		end

feature -- queries
	is_position_empty(a_position: INTEGER) : BOOLEAN
		do
			Result := false

			if game_board.at (a_position) ~ "_" then
				Result := true
			end
		end

	board_full : BOOLEAN
		local
			i : INTEGER
		do
			Result := true
			from
				i := 1
			until
				i > 9
			loop
				if game_board[i] ~ "_" then
					Result := false
				end
				i := i + 1
			end
		end

	winner_exists : BOOLEAN
		do
			Result := false

			if 	not (game_board[1] ~ "_") and (game_board[1] ~ game_board[2]) and (game_board[2] ~ game_board[3]) or
				not (game_board[4] ~ "_") and (game_board[4] ~ game_board[5]) and (game_board[5] ~ game_board[6]) or
				not (game_board[7] ~ "_") and (game_board[7] ~ game_board[8]) and (game_board[8] ~ game_board[9]) or
				not (game_board[1] ~ "_") and (game_board[1] ~ game_board[4]) and (game_board[4] ~ game_board[7]) or
				not (game_board[2] ~ "_") and (game_board[2] ~ game_board[5]) and (game_board[5] ~ game_board[8]) or
				not (game_board[3] ~ "_") and (game_board[3] ~ game_board[6]) and (game_board[6] ~ game_board[9]) or
				not (game_board[1] ~ "_") and (game_board[1] ~ game_board[5]) and (game_board[5] ~ game_board[9]) or
				not (game_board[3] ~ "_") and (game_board[3] ~ game_board[5]) and (game_board[5] ~ game_board[7]) then

					Result := true
			end
		end


feature -- output
	print_board : STRING
	local
			i : INTEGER
		do
			create Result.make_from_string ("  ")

			from
				i := 1
			until
				i > 9
			loop

				Result.append (game_board.at (i))
				if (i \\ 3) = 0 and not (i = 9) then
					Result.append("%N")
					Result.append("  ")
				end
				i := i + 1
			end
			Result.append("%N")
		end

	out: STRING
		do
			create Result.make_from_string ("")
			Result.append (print_board)
		end

end
