import java.util.Random;

public class Polymer {
  private PVector position, velocity, acceleration;
  private float pLength, flux;
  private Boolean[] r;
  private Random random;
  private float maxSpeed, maxForce;
  private final float speedScale = 4, forceScale = 1;
 
  
  Polymer(PVector position, float pLength, Boolean[] canReactWith, float flux) {
    random = new Random();
    this.position = position;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    this.pLength = pLength;
    r = canReactWith;
    this.flux = flux;
    maxSpeed = speedScale/pLength;
    maxForce = forceScale/pLength;
  }
  
  public void move(FlowField flowField) {
    PVector desired = flowField.lookupFlow(position);
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    acceleration.add(steer);
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
    acceleration.mult(0);
  }
  
  public void display() {
    noStroke();
    fill(150);
    ellipse(position.x, position.y, 40, 40);
    fill(0);
    text("" + (pLength + 1), position.x-10, position.y+5);
  }
  
  public boolean isDecomposing(float decompositionRate) {
    int chooser = random.nextInt(10);
    if (decompositionRate > chooser) {
      return true;
    } else {
      return false;
    }
  }
  
  public boolean canReactWith(float polymerLength) {
    return r[(int)polymerLength];
  }
  
  public boolean isCollidingWith(Polymer otherPolymer) {
    if (position.dist(otherPolymer.getPosition()) < 5) {
      return true;
    } else {
      return false;
    }
  }
  
  public float getFlux() {
    return flux;
  }
  
  public Boolean[] getCanReactWith() {
    return r;
  }
  
  public float getLength() {
    return pLength;
  }
  
  public PVector getPosition() {
    return position;
  }
  
}
