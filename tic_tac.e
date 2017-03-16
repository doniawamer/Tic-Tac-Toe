note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	TIC_TAC

inherit
	ANY
		redefine
			out
		end


create {TIC_TAC_ACCESS}
	make

feature {NONE} -- Initialization
	make
		do
			create player1.make_empty
			create player2.make_empty

			player1.set_pawn("X")
			player2.set_pawn("O")

			create state.make_from_string("")
			create game_board.new_board
			create history_list.make

			empty_game

			i := 0
		end

feature -- model attributes
	game_board		: GAME_BOARD
	history_list	: HISTORY
	player1			: PLAYER
	player2			: PLAYER
	state			: STRING
	winner			: BOOLEAN			-- tracks if a player won
	draw			: BOOLEAN
	turn			: BOOLEAN 			-- true = player 1 and false = player 2
	game_in_prog	: BOOLEAN
	round_count		: INTEGER
	i				: INTEGER

feature -- model commands

	empty_game
		do
			state.append ("  ok:  => start new game%N")
			game_board.empty_board
		end


	new_game(a_player1: STRING; a_player2: STRING)
		do
			player1.new_player (a_player1)
		 	player2.new_player (a_player2)

			player1.set_pawn("X")
			player2.set_pawn("O")

			turn := true
			winner := false
			round_count := 1

			state.make_empty
			state.append ("  ok: => ")
			state.append (player_turn(turn))
			state.append (" plays next%N")

			create game_board.new_board
			game_board.empty_board
			history_list.make
		end

	play(a_name: STRING; a_button: INTEGER)
		require
			position_empty: game_board.is_position_empty (a_button)
			player_exists: player_exists(a_name)
			correct_turn: a_name ~ player_turn(turn)
		do
			state.make_empty
			game_in_prog := false

			if	a_name ~ player1.name then
				game_board.player_move(player1, a_button)
				if game_board.winner_exists then
					player1.increment_score
				end
			end

			if	a_name ~ player2.name then
				game_board.player_move(player2, a_button)
				if game_board.winner_exists then
					player2.increment_score
				end
			end

			turn := not turn

			if game_board.winner_exists and not winner then
				state.append ("  there is a winner: => play again or start new game%N")
				winner := true
			elseif winner = true then
				state.append ("  game is finished: => play again or start new game%N")
			elseif game_board.board_full then
				draw := true
				state.append ("  game ended in a tie: => play again or start new game%N")
			else
				state.append ("  ok: => ")
				state.append (player_turn(turn))
				state.append (" plays next%N")

				history_list.place_item (a_button)
				game_in_prog := true
			end


		end

		play_again
			do
				state.make_empty
				if game_in_prog then
					state.append ("  finish this game first: => ")
				else
					winner := false
					round_count := round_count + 1

					if (round_count \\ 2) = 0 then
						turn := false
					else
						turn := true
					end

					create game_board.new_board
					state.append ("  ok: => ")

					history_list.make
				end

				state.append (player_turn(turn))
				state.append (" plays next%N")

			end

		undo
			do
				if (winner) or (game_board.board_full)  then
					-- nothing
				else
					state.make_empty
					game_board.reset_move(history_list.get_button)
					turn := not turn
					state.append ("  ok: => ")
					state.append (player_turn(turn))
					state.append (" plays next%N")

				end
			end

		redo
			do
				if (winner) or (game_board.board_full)  then
					-- nothing
				else
					game_board.player_move (player_from_turn(turn), history_list.get_button)
					state.make_empty
					state.append ("  ok: => ")
					turn := not turn
					state.append (player_turn(turn))
					state.append (" plays next%N")
				end
			end

		error_message(a_error: STRING)
			do
				state.make_empty
				state.append (a_error)
			end
feature -- queries
	player_turn(a_turn: BOOLEAN) : STRING
		do
			create Result.make_empty

			if a_turn then
				Result := player1.name
			end

			if not a_turn then
				Result := player2.name
			end
		end

	player_from_turn(a_turn: BOOLEAN) : PLAYER
		do
			create Result.make_empty

			if a_turn then
				Result := player1
			end

			if not a_turn then
				Result := player2
			end
		end

	player_exists(a_name: STRING) : BOOLEAN
		do
			Result := false

			if a_name ~ player1.name or a_name ~ player2.name then
				Result := true
			end
		end

	name_is_valid(a_name: STRING) : BOOLEAN
			do
				Result := false

				if 	a_name.count > 0 and
					(a_name.at (1).code >= 65 and  a_name.at (1).code <= 90) or
					(a_name.at (1).code >= 97 and a_name.at (1).code <= 122) then
						Result := true
				end
			end


feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- output queries

	print_board : STRING
		do

			create Result.make_from_string ("")
			Result.append (game_board.out)
		end
	print_score : STRING
		do
			create Result.make_from_string ("")
			Result.append (player1.out)
			Result.append ("%N")
			Result.append (player2.out)
		end

	out : STRING
		do
			create Result.make_from_string ("")
			Result.append (state)
			Result.append (print_board)
			Result.append (print_score)
		end

end




