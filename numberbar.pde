class NumberBar {
    int chosen;
    int hovered;
    color[][] sqCols;

    NumberBar() {
        chosen = hovered = -1;
        sqCols = new color[][] {
            { #ffeeff, #003311 },
            { #33ffaa, #003311 },
            { #aa44bb, #003311 },
        };
    }

    public int getChosen() {
        return chosen;
    }

    public void setChosen(int newVal) {
        chosen = newVal;
    }

    public void drawSelf() {
        int state;
        for (int i = 0; i < 9; i++) {
            if (i == chosen)
                state = 1;
            else if (i == hovered)
                state = 2;
            else
                state = 0;

            fill(sqCols[state][0]);
            rect(i * (sqSize / 9), sqSize * 1.1, sqSize / 9, sqSize / 9);
            fill(sqCols[state][1]);
            textSize(40);
            text(i + 1, (i + .5) * (sqSize / 9), sqSize * (1.1 + .05));
        }
    }

    public void checkMouse(boolean clicked) {
        float mX = mouseX - (width - sqSize) / 2;
        float mY = mouseY - (height - sqSize) * .3;
        if (mX > 0 && mX < sqSize && mY > sqSize * 1.1 && mY < sqSize * (1.1 + .5)) {
            if (clicked)
                chosen = 9 * (mouseX - (width - sqSize) / 2) / sqSize;
            else
                hovered = 9 * (mouseX - (width - sqSize) / 2) / sqSize;
        } else {
            hovered = -1;
        }
    }
}
