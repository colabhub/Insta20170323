class Particle
{
  PVector location;
  PVector velocity;
  PVector acceleration;
    
  PVector[] history;
  
  float size;
  float max_force;
  float max_speed;
  color body_color;
  
  Particle(float x, float y, float z)
  {
    location = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0);
    acceleration = new PVector(0, 0, 0);
   
    history = new PVector[12];
    for(int i = 0; i < history.length; i++)
    {
      history[i] = location.copy();
    }
    
    size = 5;
    max_force = size * 2;
    max_speed = size * 20;
    body_color = color(random(255), 255, 255);
  }
  
  void applyForce(PVector force)
  {
    acceleration.add(force);
  }
  
  PVector seek(PVector target)
  {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(max_speed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(max_force);
    return steer;
  }
    
  PVector separate(ArrayList<Particle> particles)
  {
    float desiredseparation = size;
    PVector sum = new PVector();
    int count = 0;
    for(Particle p : particles)
    {
      float distance = PVector.dist(location, p.location);
      if((distance > 0) && (distance < desiredseparation))
      {
        PVector diff = PVector.sub(location, p.location);
        diff.normalize();
        diff.div(distance);
        sum.add(diff);
        count += 1;
      }
    }
    
    if(count > 0)
    {
      sum.div(count);
      sum.setMag(max_speed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(max_force);
      
      return steer;
    }
    
    return new PVector(0, 0, 0);
  }
  
  PVector align(ArrayList<Particle> particles)
  {
    float neighbordist = size * 10;
    PVector sum = new PVector();
    int count = 0;
    for(Particle p : particles)
    {
      float distance = PVector.dist(location, p.location);
      if((distance > 0) && (distance < neighbordist))
      {
        PVector diff = PVector.sub(location, p.location);
        diff.normalize();
        diff.div(distance);
        sum.add(diff);
        count += 1;
      }
    }
    
    if(count > 0)
    {
      sum.div(count);
      sum.setMag(max_speed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(max_force);
      
      return steer;
    }
    
    return new PVector(0, 0, 0);
  }
  
  PVector cohesion(ArrayList<Particle> particles)
  {
    float neighbordist = size * 10;
    PVector sum = new PVector();
    int count = 0;
    for(Particle p : particles)
    {
      float distance = PVector.dist(location, p.location);
      if((distance > 0) && (distance < neighbordist))
      {
        sum.add(p.location);
        count += 1;
      }
    }
    
    if(count > 0)
    {
      sum.div(count);
      return seek(sum);
    }
    
    return new PVector(0, 0, 0);
  }
  
  void update()
  {
    velocity.add(acceleration);
    velocity.limit(max_speed);
    location.add(velocity);
    velocity.mult(1);
    acceleration.mult(0);
    
    for(int i = history.length - 1; i > 0; i--)
    {
      history[i] = history[i - 1].copy();
    }
    history[0] = location.copy();
  }
  
  void flok(ArrayList<Particle> particles)
  {
    PVector sep = separate(particles);
    PVector ali = align(particles);
    PVector coh = cohesion(particles);
    
    sep.mult(1);
    coh.mult(1.1);
        
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
  void display()
  {            
    stroke(body_color);
    strokeWeight(1);
    for(int i = history.length - 1; i > 0; i--)
    {
      line(history[i].x, history[i].y, history[i].z, history[i-1].x, history[i-1].y, history[i-1].z);
    }
    
    pushMatrix();
    translate(history[0].x, history[0].y, history[0].z);
    noStroke();
    fill(body_color);
    sphere(1);
    popMatrix();
  }
  
  void borders()
  {
    PVector distance = PVector.sub(location, new PVector(0, 0, 0));
    if(distance.mag() > 300)
    {
      distance.normalize();
      distance.mult(-max_force);     
      applyForce(distance);
    }
  }
}