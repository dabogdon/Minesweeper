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
      displayLosingMessage();
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
