import de.bezier.guido.*;
public final static int NUM_ROWS = 25;
public final static int NUM_COLS = 25;
public final static int NUM_MINES = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined
boolean gameover = false;
void setup ()
{
    size(500, 500);
    textAlign(CENTER,CENTER);
    Interactive.make(this);
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    setMines();
}
public void setMines()
{
    for(int i = 0; i < NUM_MINES; i++){
      int r = (int)(Math.random() * 25);
      int c = (int)(Math.random() * 25);
      if(!mines.contains(buttons[r][c])){
        mines.add(buttons[r][c]);
      }
    }
}
public void draw ()
{
    background( 0 );
    if(isWon()){
        displayWinningMessage();
    }
}
public boolean isWon()
{
    int count = 0;
    for(int i = 0; i < mines.size(); i++){
      if(mines.get(i).isFlagged() == true){
        count++;
      }
    }
    if(mines.size() == count){
      return true;
    }
    for(int i = 0; i < mines.size(); i++){
        if(mines.get(i).isClicked() == true){
            displayLosingMessage();
        }
    }
    return false;
}
public void displayLosingMessage()
{
   for(int i = 0; i < mines.size(); i++){
     mines.get(i).setclicked(true);
   }
   buttons[12][6].setLabel("Y");
   buttons[12][7].setLabel("O");
   buttons[12][8].setLabel("U");
   buttons[12][9].setLabel("H");
   buttons[12][10].setLabel("A");
   buttons[12][11].setLabel("V");
   buttons[12][12].setLabel("E");
   buttons[12][13].setLabel("L");
   buttons[12][14].setLabel("O");
   buttons[12][15].setLabel("S");
   buttons[12][16].setLabel("T");
   buttons[12][17].setLabel("!");
   gameover = true;
}
public void displayWinningMessage()
{
     buttons[12][3].setLabel("C");
     buttons[12][4].setLabel("O");
     buttons[12][5].setLabel("N");
     buttons[12][6].setLabel("G");
     buttons[12][7].setLabel("R");
     buttons[12][8].setLabel("A");
     buttons[12][9].setLabel("T");
     buttons[12][10].setLabel("S");
     buttons[12][11].setLabel("Y");
     buttons[12][12].setLabel("O");
     buttons[12][13].setLabel("U");
     buttons[12][14].setLabel("H");
     buttons[12][15].setLabel("A");
     buttons[12][16].setLabel("V");
     buttons[12][17].setLabel("E");
     buttons[12][18].setLabel("W");
     buttons[12][19].setLabel("O");
     buttons[12][20].setLabel("N");
     buttons[12][21].setLabel("!");
     gameover = true;
}

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton (int row, int col )
    {
        width = 500/NUM_COLS;
        height = 500/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add(this); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if(mouseButton ==  LEFT && gameover == false){
            if(clicked == false){
                clicked = true;
                if(keyPressed == true){
                    flagged =! flagged;
                }
                else if(mines.contains(this)){
                    displayLosingMessage();
                }
                else if(countMines(myRow, myCol) > 0){
                    setLabel(countMines(myRow, myCol));
                }
                else{
                    for(int i = -1; i < 2; i++){
                        for(int j = -1; j < 2; j++){
                            if(isValid(myRow+i, myCol+j)){
                                if(buttons[myRow+i][myCol+j].clicked == false){
                                    buttons[myRow+i][myCol+j].mousePressed();
                                }
                            }
                        }
                    }
                }
            }
        }
        if(mouseButton == RIGHT && gameover == false){
          flagged =!flagged;
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0, 175, 150);
        else if(clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 255 );
        else 
            fill( 150 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public void setclicked(boolean c){
        clicked = c;
    }
    public boolean isClicked(){
      return clicked;
    }
}
public boolean isValid(int r, int c)
{
    return (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS);
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = -1; i <= 1; i++){
      for(int j = -1; j <= 1;j++){
        if((i!=0 ||j!=0) && isValid(row + i, col + j) && mines.contains(buttons[row + i][col + j])){
          numMines++;
        }
      }
    }
    return numMines;
}
