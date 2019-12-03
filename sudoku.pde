Grid grid;
NumberBar numbar;
Messenger messenger;

int sqSize;
boolean noteMode;

void setup() {
	size(800, 800);

    File f = new File(sketchPath("save.txt"));
    String[] gridStr = loadStrings(f.exists() ? "save.txt" : "puzzles.txt");
    grid = new Grid(gridStr, f.exists());

    numbar = new NumberBar();
    sqSize = (int) (height * .7);

    messenger = new Messenger();
}

void draw() {
	background(#66aacc);

	textAlign(LEFT, TOP);
    textSize(20);
    text("Note mode " + ((noteMode) ? "on" : "off"), 10, 10);
    text("Puzzle #" + grid.puzzleNum, 10, 30);

    messenger.update();

	textAlign(CENTER, CENTER);
	translate((width - sqSize) / 2, (height - sqSize) * .3);

    grid.drawSelf();
    numbar.drawSelf();

    grid.checkMouse(false, false);
    numbar.checkMouse(false);
}

void mousePressed() {
    grid.checkMouse(true, mouseButton == RIGHT);
    numbar.checkMouse(true);
}

void keyPressed() {
    if (Character.isDigit(key))
        numbar.setChosen(new Integer(key - '1'));
    else if (key == ' ')
        noteMode = !noteMode;
    else if (key == 's')
        grid.dump();
}
