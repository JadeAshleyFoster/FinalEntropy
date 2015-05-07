public class Molecule {
  private final float size = 5;
  private PVector position;
  
  Molecule(PVector position) {
    this.position = position;
  }
  
  public float getSize() {
    return size;
  }
  
  public PVector getPosition() {
    return position;
  }
  
}
