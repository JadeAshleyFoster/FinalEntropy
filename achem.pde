import java.util.ArrayList;
import java.util.Random;

public class Achem {
  private float n, kd;
  private ArrayList<Boolean[]> reactionsAllowed;
  private float[] fluxes;
  private ArrayList<Polymer> polymers;
  private ArrayList<Polymer> polymersToRemove, polymersToAdd;  //For ease of looping
  private Random random;
  
  Achem(float maxPolymerLength, float decompositionRate, float[] initialPolymerConcentations, ArrayList<Boolean[]> reactionsAllowed, float[] fluxes) {
    n = maxPolymerLength;
    kd = decompositionRate;
    random = new Random();
    this.reactionsAllowed = reactionsAllowed;
    this.fluxes = fluxes;
    polymersToRemove = new ArrayList<Polymer>();
    polymersToAdd = new ArrayList<Polymer>();
    createPolymers();
  } 
  
  private void createPolymers() {
    polymers = new ArrayList<Polymer>();
    for (int polymerLength = 0; polymerLength < n; polymerLength++) {
      for (int i = 0; i < initialPolymerConcentrations[polymerLength]; i++) {
        PVector randomPosition = new PVector(random.nextInt(width), random.nextInt(height));
        Boolean[] polymerReactionsAllowed = reactionsAllowed.get(polymerLength);
        polymers.add(new Polymer(randomPosition, polymerLength, polymerReactionsAllowed, fluxes[polymerLength]));
      }
    }
  }
  
  public void update(FlowField flowField) {
    for (Polymer i : polymers) {  
      //Move the Polymer:
      i.move(flowField);
      //Check if colliding with anything:
      boolean colliding = false;
      for (Polymer j : polymers) {
        if (colliding == false) {
          if (i != j && i.isCollidingWith(j) && i.canReactWith(j.getLength())) {
            colliding = true;
            combinePolymers(i, j);
          }
        }
      }
      //If not colliding, possibly decompose:
      if (!colliding && i.getLength() > 0) {
        if (i.isDecomposing(kd)) {
          splitPolymer(i);
        }
      }   
      //Draw Polymer:
      i.display(); 
    }    
    
    //Add polymers
    for (Polymer polymer : polymersToAdd) {
      polymers.add(polymer);
    }
    polymersToAdd.clear();
    
    //Remove polymers
    for (Polymer polymer : polymersToRemove) {
      polymers.remove(polymer);
    }
    polymersToRemove.clear();
  }
  
  private void splitPolymer(Polymer i) {
    float randomPolymerLength = random.nextInt((int)i.getLength());
    if (i.canReactWith(randomPolymerLength)) {
      float iNewPolymerLength = randomPolymerLength ;
      float jNewPolymerLength = i.getLength() - iNewPolymerLength;
      Boolean[] iPolymerReactionsAllowed = reactionsAllowed.get((int)iNewPolymerLength);
      Boolean[] jPolymerReactionsAllowed = reactionsAllowed.get((int)jNewPolymerLength);
      polymersToAdd.add(new Polymer(i.getPosition(), iNewPolymerLength, iPolymerReactionsAllowed, fluxes[(int)iNewPolymerLength]));  //may want to add repel behaviour to prevent combining
      polymersToAdd.add(new Polymer(i.getPosition(), jNewPolymerLength, jPolymerReactionsAllowed, fluxes[(int)jNewPolymerLength]));
    } else {
      splitPolymer(i);    
    }  
    polymersToRemove.add(i);
  }
  
  private void combinePolymers(Polymer i, Polymer j) {
    float newPolymerLength = i.getLength() + j.getLength();
    Boolean[] polymerReactionsAllowed = reactionsAllowed.get((int)newPolymerLength);
    Polymer newPolymer = new Polymer(i.getPosition(), newPolymerLength, polymerReactionsAllowed, fluxes[(int)newPolymerLength]);
    polymersToAdd.add(newPolymer);
    polymersToRemove.add(i);
    polymersToRemove.add(j);
  }
  
  public ArrayList<Polymer> getPolymers() {
    return polymers;
  }
  
  public float getMaxPolymerLength() {
    return n;
  }
  
  public float getDecompositionRate() {
    return kd;
  }
  
}
