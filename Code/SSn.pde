Table t;
Snake s;
Brain b;
int scl = 20;

PVector food;

public void settings() {
	size(600, 600);
}
public void setup() {
	t = new Table();
	s = new Snake();
	b = new Brain();
    frameRate(10);
    t.pickLocation();
    t.show();
}
public void draw() {
	background(51);
	if (s.eat(food)) {
		t.pickLocation();
	}

	//t.show();
	b.act();
	s.act();

	fill(255, 0, 100);
	rect(food.x, food.y, scl, scl);
}
public void mousePressed() {
	s.total++;
}
public void keyPressed() {
	if (keyCode == UP) {
		s.dir(0, -1);
	} else if (keyCode == DOWN) {
		s.dir(0, 1);
	} else if (keyCode == RIGHT) {
	  	s.dir(1, 0);
	} else if (keyCode == LEFT) {
	  	s.dir(-1, 0);
	}
}
public class Brain {
	
	int fitness;
	float minDist = 1000;

	float[] distances = new float[6] ;
	
	float[] weights;

	public void gaze() {
		distances[0] = map(s.y,0,height,0,1);
		distances[1] = map(width-s.x,0,width,0,1);
		distances[2] = map(height-s.y,0,height,0,1);
		distances[3] = map(s.x,0,width,0,1);
		distances[4] = map(dist(s.x,s.y,food.x,food.y),0,dist(0,0,width,height),0,1);
	}
	public void printGaze() {
		System.out.println("Movement: ");
		System.out.println("\ttop:    " + distances[0]);
		System.out.println("\tright:  " + distances[1]);
		System.out.println("\tdown:   " + distances[2]);
		System.out.println("\tleft:   " + distances[3]);
		System.out.println("\tcube:   " + distances[4] + "\n");
	}
	public void dumbDecision(){
		
		if(dist(s.x,s.y,food.x,food.y) <= minDist) {
		}
		if (dist(s.x+scl,s.y,food.x,food.y) <= minDist) {
			minDist = dist(s.x+scl,s.y,food.x,food.y);
			s.dir(1,0);
		}
		if (dist(s.x+scl,s.y+scl,food.x,food.y) <= minDist) {
			minDist = dist(s.x+scl,s.y+scl,food.x,food.y);
			s.dir(1, 1);
		}
		if (dist(s.x,s.y+scl,food.x,food.y) <= minDist) {
			minDist = dist(s.x,s.y+scl,food.x,food.y);
			s.dir(0, 1);
		}
		if (dist(s.x-scl,s.y+scl,food.x,food.y) <= minDist) {
			minDist = dist(s.x-scl,s.y+scl,food.x,food.y);
			s.dir(-1, 1);
		}
		if (dist(s.x-scl,s.y,food.x,food.y) <= minDist) {
			minDist = dist(s.x-scl,s.y,food.x,food.y);
			s.dir(-1, 0);
		}
		if (dist(s.x-scl,s.y-scl,food.x,food.y) <= minDist) {
			minDist = dist(s.x-scl,s.y-scl,food.x,food.y);
			s.dir(-1, -1);
		}
		if (dist(s.x,s.y-scl,food.x,food.y) <= minDist) {
			minDist = dist(s.x,s.y-scl,food.x,food.y);
			s.dir(0, -1);
		}
		if (dist(s.x+scl,s.y-scl,food.x,food.y) <= minDist) {
			minDist = dist(s.x+scl,s.y-scl,food.x,food.y);
			s.dir(1, -1);
		}
	}
	public void act(){
		gaze();
		printGaze();
		dumbDecision();
	}
	public void reset() {
		minDist = width*height;
	}
}
public class Snake {
	float x = 0;
	float y = 0;
	float xspeed = 0;
	float yspeed = 0;
	int total = 10000;
	ArrayList<PVector> tail = new ArrayList<PVector>();

	Snake() {
	}
	boolean eat(PVector pos) {
		float d = dist(x, y, pos.x, pos.y);
	    if (d < 1) {
	    	total++;
	    	b.reset();
	    	return true;
	    } else {
	    	return false;
	    }
	}

	void dir(float x, float y) {
		xspeed = x;
	    yspeed = y;
	}

	void death() {
		for (int i = 0; i < tail.size(); i++) {
			PVector pos = tail.get(i);
			float d = dist(x, y, pos.x, pos.y);
			if (d < 1) {
				println("starting over");
				total = 0;
				tail.clear();
			}
	    }
	}
  	void update() {
    //println(total + " " + tail.size());
    	if (total > 0) {
      		if (total == tail.size() && !tail.isEmpty()) {
        	tail.remove(0);
      	}
      	tail.add(new PVector(x, y));
    	}

   	 	x = x + xspeed*scl;
   		y = y + yspeed*scl;

    	x = constrain(x, 0, width-scl);
    	y = constrain(y, 0, height-scl);
  	}
  	void show() {
    	fill(255);
    	for (PVector v : tail) {
      		rect(v.x, v.y, scl, scl);
    	}
    	rect(x, y, scl, scl);
  	}

  	void act(){
  		death();
  		update();
  		show();
  	}
}
public class Table {

	int rows;
	int cols;

	Table(){
	}

	public void pickLocation() {
		this.cols = width/scl;
		this.rows = height/scl;
		food = new PVector(floor(random(cols)), floor(random(rows)));
		food.mult(scl);
	}

	public void show(){
		for (int r = 0; r < rows; r++){
			for (int c = 0; c < cols; c++){
				fill(255, 255, 100);
				rect(r*scl,c*scl,(r+1)*scl,(c+1)*scl);
			}
		}
	}
}

