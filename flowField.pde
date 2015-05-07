public class FlowField {
  private PVector[][] field;
  private int columns, rows, resolution;
  
  FlowField(int resolution) {
    this.resolution = resolution;
    columns = width/resolution;
    rows = height/resolution;
    createField();
  }
  
  private void createField() {
    field = new PVector[columns][rows];
    float xoff = 0;
    for (int i = 0; i < columns; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        float theta = map(noise(xoff, yoff), 0, 1, 0, TWO_PI);
        field[i][j] = new PVector(cos(theta), sin(theta));
        yoff += 0.2;
      }
      xoff += 0.2;
    }
  }
  
  public PVector lookupFlow(PVector lookup) {
    int c = int(constrain(lookup.x/resolution, 0, columns-1));
    int r = int(constrain(lookup.y/resolution, 0, rows-1));
    return field[c][r].get();
  }
  
  public void display() {
    float arrowSize = 4;
    float scale = 40;
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        PVector flow = field[i][j].get();
        pushMatrix();
        translate((i+1)*resolution, (j*1)*resolution);
        strokeWeight(2);
        stroke(230);
        rotate(flow.heading2D());
        float len = flow.mag()*scale;
        line(0, 0, len, 0);
        line(len,0,len-arrowSize,+arrowSize/2);
        line(len,0,len-arrowSize,-arrowSize/2);
        popMatrix();
      }
    }
  }
  
}
