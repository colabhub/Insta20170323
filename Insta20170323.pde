ArrayList<Particle> particles;

void setup()
{
  size(512, 512, P3D);
  frameRate(30);
  hint(DISABLE_DEPTH_TEST);
  colorMode(HSB);
  blendMode(ADD);
  
  particles = new ArrayList<Particle>();
  for(int i = 0; i < 256; i++)
  {
    particles.add(new Particle(random(-250, 250), random(-250, 250), random(-250, 250)));
  }
}

void draw()
{
  background(0);
  translate(width / 2, height / 2, 0);
  
  float angle = frameCount % 360;
  float camera_x = 500 * cos(radians(angle));
  float camera_z = 500 * sin(radians(angle));   
  camera(camera_x, 0, camera_z, 
         0, 0, 0, 
         0, 1, 0);
  
  for(Particle particle : particles)
  {
    particle.flok(particles);
    particle.update();
    particle.borders();
    particle.display();
  }

  /*
  println(frameCount);
  saveFrame("screen-#####.png");
  if(frameCount > 900)
  {
     exit();
  }
  */
}