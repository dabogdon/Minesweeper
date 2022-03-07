import de.bezier.guido.*;
int NUM_ROWS = 20;
int NUM_COLS = 20;
int NUM_MINES = 40;
int NUM_FLAGS = NUM_MINES;
int safeMines = NUM_MINES;
int unCheckedSpots=(NUM_ROWS*NUM_COLS)-NUM_MINES;
boolean dead=false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup () {
  size(400, 400);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );
  //your code to initialize buttons goes here

  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r=0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      buttons[r][c]=new MSButton(r, c);
    }
  }

  setMines();
}

public void setMines() {
  int count=NUM_MINES;
  while (count>0) {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    }
    count--;
  }
}

public void draw () {
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
  if(dead==true)
    displayLosingMessage();
}

public boolean isWon() {
  if (unCheckedSpots==0&&dead==false) {
    return true;
  }
  return false;
}

public void displayLosingMessage() {
  /*for(MSButton mine:mines){
    mine.setClicked(true);
  }
  for (int r=0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      buttons[r][c].setLabel("");
    }
  }*/
  buttons[9][8].setLabel("L");
  buttons[9][9].setLabel("O");
  buttons[9][10].setLabel("S");
  buttons[9][11].setLabel("E");
  noLoop();
}
public void displayWinningMessage() {
  for (int r=0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      buttons[r][c].setFlagged(false);
    }
  }
  buttons[9][7].setLabel("W");
  buttons[9][8].setLabel("I");
  buttons[9][9].setLabel("N");
  buttons[9][10].setLabel("N");
  buttons[9][11].setLabel("E");
  buttons[9][12].setLabel("R");
  noLoop();
}
public boolean isValid(int r, int c) {
  return r>=0&&c>=0&&r<NUM_ROWS&&c<NUM_COLS;
}
public int countMines(int row, int col) {
  int numMines = 0;
  for (int r = row-1; r<=row+1; r++)
    for (int c = col-1; c<=col+1; c++)
      if (isValid(r, c) && mines.contains(buttons[r][c]))
        numMines++;
  return numMines;
}

public class MSButton {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col ) {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    if (mouseButton==LEFT && flagged==false) {
      if (!mines.contains(this)&&clicked==false) {unCheckedSpots--;}
      clicked = true;
    }
    if (mouseButton==RIGHT&&clicked==false&&NUM_FLAGS>0) {
      flagged=!flagged;
      if (isFlagged()) {clicked=false;}
      if (isFlagged()==true) {NUM_FLAGS--;}
      if (isFlagged()==false) {NUM_FLAGS++;}
    } else if (mines.contains(this)) {
      dead=true;
    } else if (countMines(myRow, myCol)>0) {setLabel(countMines(myRow, myCol));}
      else {
        if (!mines.contains(buttons[myRow][myCol])){
          if (isValid(myRow, myCol+1)&&buttons[myRow][myCol+1].clicked==false) {buttons[myRow][myCol+1].mousePressed();}
          if (isValid(myRow-1, myCol+1)&&buttons[myRow-1][myCol+1].clicked==false) {buttons[myRow-1][myCol+1].mousePressed();}
          if (isValid(myRow-1, myCol)&&buttons[myRow-1][myCol].clicked==false) {buttons[myRow-1][myCol].mousePressed();}
          if (isValid(myRow-1, myCol-1)&&buttons[myRow-1][myCol-1].clicked==false) {buttons[myRow-1][myCol-1].mousePressed();}
          if (isValid(myRow, myCol-1)&&buttons[myRow][myCol-1].clicked==false) {buttons[myRow][myCol-1].mousePressed();}
          if (isValid(myRow+1, myCol-1)&&buttons[myRow+1][myCol-1].clicked==false) {buttons[myRow+1][myCol-1].mousePressed();}
          if (isValid(myRow+1, myCol)&&buttons[myRow+1][myCol].clicked==false) {buttons[myRow+1][myCol].mousePressed();}
          if (isValid(myRow+1, myCol+1)&&buttons[myRow+1][myCol+1].clicked==false) {buttons[myRow+1][myCol+1].mousePressed();}
      }
    }
  }
  public void draw () {    
    if (flagged){fill(0);}
    else if (clicked && mines.contains(this))
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
      fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel) {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged() {
    return flagged;
  }
  public void setClicked(boolean c) {
    clicked=c;
  }
  public void setFlagged(boolean f){
    flagged=f;
  }
}
