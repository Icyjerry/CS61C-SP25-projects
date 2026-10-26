#include "game.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "snake_utils.h"

/* Helper function definitions */
static void set_board_at(game_t *game, unsigned int row, unsigned int col, char ch);
static bool is_tail(char c);
static bool is_head(char c);
static bool is_snake(char c);
static char body_to_tail(char c);
static char head_to_body(char c);
static unsigned int get_next_row(unsigned int cur_row, char c);
static unsigned int get_next_col(unsigned int cur_col, char c);
static void find_head(game_t *game, unsigned int snum);
static char next_square(game_t *game, unsigned int snum);
static void update_tail(game_t *game, unsigned int snum);
static void update_head(game_t *game, unsigned int snum);

/* Task 1 */
game_t *create_default_game() {
  game_t *game = malloc(sizeof(game_t));
  game->board = malloc(18 * sizeof(char *));
  game->num_snakes = 1;
  game->num_rows = 18;
  game->snakes = malloc(game->num_snakes * sizeof(snake_t));
  game->snakes[0].tail_row = 2;
  game->snakes[0].tail_col = 2;
  game->snakes[0].head_row = 2;
  game->snakes[0].head_col = 4;
  game->snakes[0].live = true;
  char line1[] = "####################\n";
  char line2[] = "#                  #\n";
  char line3[] = "# d>D    *         #\n";
  for (int i = 0; i < 18; i ++){
    game->board[i] = malloc(22 * sizeof(char));
    if (i == 0 || i == 17){
      strcpy(game->board[i] ,line1);
    } else if (i == 2){
      strcpy(game->board[i] ,line3);
    } else {
      strcpy(game->board[i], line2);
    }
  }
  return game;
}

/* Task 2 */
void free_game(game_t *game) {
  // TODO: Implement this function.
  for (int i = 0; i < game->num_rows; i ++){
    free(game->board[i]);
  }
  free(game->board);
  free(game->snakes);
  free(game);
  return;
}

/* Task 3 */
void print_board(game_t *game, FILE *fp) {
  // TODO: Implement this function.
  for (int i = 0; i < game->num_rows; i++) {
    fprintf(fp, "%s", game->board[i]);
  }
  return;
}

/*
  Saves the current game into filename. Does not modify the game object.
  (already implemented for you).
*/
void save_board(game_t *game, char *filename) {
  FILE *f = fopen(filename, "w");
  print_board(game, f);
  fclose(f);
}

/* Task 4.1 */

/*
  Helper function to get a character from the board
  (already implemented for you).
*/
char get_board_at(game_t *game, unsigned int row, unsigned int col) { return game->board[row][col]; }

/*
  Helper function to set a character on the board
  (already implemented for you).
*/
static void set_board_at(game_t *game, unsigned int row, unsigned int col, char ch) {
  game->board[row][col] = ch;
}

/*
  Returns true if c is part of the snake's tail.
  The snake consists of these characters: "wasd"
  Returns false otherwise.
*/
static bool is_tail(char c) {
  // TODO: Implement this function.
  return (c == 'w') || (c == 'a') || (c == 's') || (c == 'd');
}

/*
  Returns true if c is part of the snake's head.
  The snake consists of these characters: "WASDx"
  Returns false otherwise.
*/
static bool is_head(char c) {
  // TODO: Implement this function.
  return (c == 'W') || (c == 'A') || (c == 'S') || (c == 'D') || (c == 'x');
}

/*
  Returns true if c is part of the snake.
  The snake consists of these characters: "wasd^<v>WASDx"
*/
static bool is_snake(char c) {
  // TODO: Implement this function.
  return is_head(c) || is_tail(c) || (c == '^') || (c == '<') || (c == 'v') || (c == '>');
}

/*
  Converts a character in the snake's body ("^<v>")
  to the matching character representing the snake's
  tail ("wasd").
*/
static char body_to_tail(char c) {
  // TODO: Implement this function.
  switch (c){
      case '^': return 'w';
      case '<': return 'a';
      case 'v': return 's';
      case '>': return 'd';
      default: return '?';
  }
}

/*
  Converts a character in the snake's head ("WASD")
  to the matching character representing the snake's
  body ("^<v>").
*/
static char head_to_body(char c) {
  // TODO: Implement this function.
  switch (c){
      case 'W': return '^';
      case 'A': return '<';
      case 'S': return 'v';
      case 'D': return '>';
      default: return '?';
  }
}

/*
  Returns cur_row + 1 if c is 'v' or 's' or 'S'.
  Returns cur_row - 1 if c is '^' or 'w' or 'W'.
  Returns cur_row otherwise.
*/
static unsigned int get_next_row(unsigned int cur_row, char c) {
  // TODO: Implement this function.
  if (c == 'v' || c == 's' || c == 'S') return cur_row + 1;
  if (c == '^' || c == 'w' || c == 'W') return cur_row - 1;
  return cur_row;
}

/*
  Returns cur_col + 1 if c is '>' or 'd' or 'D'.
  Returns cur_col - 1 if c is '<' or 'a' or 'A'.
  Returns cur_col otherwise.
*/
static unsigned int get_next_col(unsigned int cur_col, char c) {
  // TODO: Implement this function.
  if (c == '>' || c == 'd' || c == 'D') return cur_col + 1;
  if (c == '<' || c == 'a' || c == 'A') return cur_col - 1;
  return cur_col;
}

/*
  Task 4.2

  Helper function for update_game. Return the character in the cell the snake is moving into.

  This function should not modify anything.
*/
static char next_square(game_t *game, unsigned int snum) {
  // TODO: Implement this function.
  snake_t *snake = &game->snakes[snum];
  unsigned int row = snake->head_row;
  unsigned int col = snake->head_col;
  char head = game->board[row][col];
  unsigned int next_row = get_next_row(row, head);
  unsigned int next_col = get_next_col(col, head);

  return game->board[next_row][next_col];
}

/*
  Task 4.3

  Helper function for update_game. Update the head...

  ...on the board: add a character where the snake is moving

  ...in the snake struct: update the row and col of the head

  Note that this function ignores food, walls, and snake bodies when moving the head.
*/
static void update_head(game_t *game, unsigned int snum) {
  // TODO: Implement this function.
  snake_t *snake = &game->snakes[snum];
  unsigned int row = snake->head_row;
  unsigned int col = snake->head_col;
  char head = game->board[row][col];
  unsigned int next_row = get_next_row(row, head);
  unsigned int next_col = get_next_col(col, head);

  snake->head_row = next_row;
  snake->head_col = next_col;

  game->board[next_row][next_col] = head;
  game->board[row][col] = head_to_body(head);

  return;
}

/*
  Task 4.4

  Helper function for update_game. Update the tail...

  ...on the board: blank out the current tail, and change the new
  tail from a body character (^<v>) into a tail character (wasd)

  ...in the snake struct: update the row and col of the tail
*/
static void update_tail(game_t *game, unsigned int snum) {
  // TODO: Implement this function.
  snake_t *snake = &game->snakes[snum];
  unsigned int row = snake->tail_row;
  unsigned int col = snake->tail_col;
  char tail = game->board[row][col];
  unsigned int next_row = get_next_row(row, tail);
  unsigned int next_col = get_next_col(col, tail);

  snake->tail_row = next_row;
  snake->tail_col = next_col;

  
  game->board[next_row][next_col] = body_to_tail(game->board[next_row][next_col]);
  game->board[row][col] = ' ';
  return;
}

/* Task 4.5 */
void update_game(game_t *game, int (*add_food)(game_t *game)) {
  // TODO: Implement this function.
  for (unsigned int i = 0; i < game->num_snakes; i++) {
    snake_t *snake = &game->snakes[i];
    unsigned int row = snake->head_row;
    unsigned int col = snake->head_col;

    if (!snake->live) continue;

    char next = next_square(game, i);

    if (is_snake(next) || next == '#'){
      snake->live = false;
      game->board[row][col] = 'x';
    } else if (next == '*') {
      update_head(game, i);
      add_food(game);
    } else {
      update_head(game, i);
      update_tail(game, i);
    }

  }
  
  return;
}

/* Task 5.1 */
char *read_line(FILE *fp) {
  // TODO: Implement this function.
  size_t capacity = 16;
  size_t len = 0;

  char *line = malloc(capacity);
  if (!line) return NULL;

  while (fgets(line + len, (int)(capacity - len), fp)) {
    len = strlen(line);

    if (len > 0 && line[len - 1] == '\n') return line;

    capacity *= 2;
    char *tmp = realloc(line, capacity);
    if (!tmp) {
      free(line);
      return NULL;
    }
    line = tmp;

  } 

  if (len == 0){
    free(line);
    return NULL;
  }
  
  return line;

}

/* Task 5.2 */
game_t *load_board(FILE *fp) {
  // TODO: Implement this function.
  game_t *game = malloc(sizeof(game_t));
  game->board = NULL;
  game->num_snakes = 0;
  game->num_rows = 0;
  game->snakes = NULL;

  char *line;
  while ((line = read_line(fp)) != NULL){
    char **new_board = realloc(game->board, (game->num_rows + 1) * sizeof(*game->board));
    if (new_board == NULL){
      free(line);
      return NULL;
    }

    game->board = new_board;
    game->board[game->num_rows ++] = line;

  }
  
  return game;
}

/*
  Task 6.1

  Helper function for initialize_snakes.
  Given a snake struct with the tail row and col filled in,
  trace through the board to find the head row and col, and
  fill in the head row and col in the struct.
*/
static void find_head(game_t *game, unsigned int snum) {
  // TODO: Implement this function.
  snake_t *snake = &game->snakes[snum];
  unsigned int row = snake->tail_row;
  unsigned int col = snake->tail_col;
  char cur = game->board[row][col];

  while (!is_head(cur)){
    row = get_next_row(row, cur);
    col = get_next_col(col, cur);
    cur = game->board[row][col];
  }

  snake->head_row = row;
  snake->head_col = col;

  return;
}

/* Task 6.2 */
game_t *initialize_snakes(game_t *game) {
  // TODO: Implement this function.
  for (unsigned int i = 0; i < game->num_rows; i ++){
    size_t len = strlen(game->board[i]);
    if (len > 0 && game->board[i][len - 1] == '\n') {
      len--;
    }

    for (unsigned int j = 0; j < len; j ++){
      if (is_tail(game->board[i][j])){
        snake_t *temp = (snake_t *)realloc(game->snakes, (game->num_snakes + 1) * sizeof(snake_t));
        if (!temp) {
          return NULL;
        }
        game->snakes = temp;
        game->snakes[game->num_snakes].head_row = i;
        game->snakes[game->num_snakes].head_col = j;
        game->snakes[game->num_snakes].tail_row = i;
        game->snakes[game->num_snakes].tail_col = j;
        game->snakes[game->num_snakes].live = true;
        find_head(game, game->num_snakes);
        game->num_snakes ++;
      }
    }
  }




  return game;
}
