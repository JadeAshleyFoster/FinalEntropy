import java.util.ArrayList;

private final float maxPolymerLength = 11, decompositionRate = 5; //Rate out of 10, the larger the more chance of happening
private final float[] initialPolymerConcentrations = {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2};
private final float[] fluxes = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
private ArrayList<Boolean[]> reactionsAllowed;
private Achem achem;
private FlowField flowField;

public void setup() {
  size(1200, 800);
  this.flowField = new FlowField(50);
  
  //Reactions allowed: for now everything is alllowed:
  this.reactionsAllowed = new ArrayList<Boolean[]>();
  for (int i = 0; i < maxPolymerLength; i++) {
    Boolean[] polymerReactionsAllowed = new Boolean[(int) maxPolymerLength];
    for (int j = 0; j < maxPolymerLength; j++) {
      if (i+j < maxPolymerLength) {
        polymerReactionsAllowed[j] = true;
      } else {
        polymerReactionsAllowed[j] = false;
      }
    }
    reactionsAllowed.add(polymerReactionsAllowed);
  }      
  this.achem = new Achem(maxPolymerLength, decompositionRate, initialPolymerConcentrations, reactionsAllowed, fluxes);
}

public void draw() {
  background(255);
  flowField.display();
  achem.update(flowField);
}
