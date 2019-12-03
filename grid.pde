class Grid {
    int puzzleNum;
    int[][] vals = new int[9][9];
    boolean[][] isSet = new boolean[9][9];
    boolean[][][] notes = new boolean[9][9][9];
    PVector hovered = new PVector(-1, -1);

    color[][] sqCols;

    Grid(String[] gridStr, boolean regen) {
        if (regen)
            regeneratePuzzle(gridStr);
        else
            generatePuzzle(gridStr);

        sqCols = new color[][] {
            { #cacbef, #000000 },
            { #dcdfda, #221cea },
            { #bbbbbe, #443311 },
            { #ffeefa, #000000 },
        };
    }

    public void drawSelf() {
        int state;
        strokeWeight(1);
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                if ((getValue(j, i) == numbar.getChosen() + 1 && getValue(j, i) != 0)
                        || (isNoteSet(j, i, numbar.getChosen()) && getValue(j, i) == 0))
                    state = 0;
                else if (isSet(j, i))
                    state = 1;
                else if (hovered.x == j && hovered.y == i)
                    state = 2;
                else
                    state = 3;

                fill(sqCols[state][0]);
                rect(j * (sqSize / 9), i * (sqSize / 9), sqSize / 9, sqSize / 9);

                fill(sqCols[state][1]);
                if (getValue(j, i) != 0) {
                    textSize(40);
                    text(getValueStr(j, i),
                            (j + .5) * (sqSize / 9), (i + .5) * (sqSize / 9));
                } else {
                    drawNotes(j, i);
                }
            }
        }

        strokeWeight(3);
        for (int i = 0; i < 4; i++) {
            line(0, i * (sqSize / 3), sqSize, i * (sqSize / 3));
            line(i * (sqSize / 3), 0, i * (sqSize / 3), sqSize);
        }
    }

    public void checkMouse(boolean clicked, boolean rightClick) {
        float mX = mouseX - (width - sqSize) / 2;
        float mY = mouseY - (height - sqSize) * .3;
        if (mX > 0 && mX < sqSize && mY > 0 && mY < sqSize) {
            int col = 9 * (int) mX / sqSize;
            int row = 9 * (int) mY / sqSize;
            if (clicked && !isSet(col, row)
                    && numbar.getChosen() >= 0 && numbar.getChosen() < 9)
                if (rightClick)
                    setValue(col, row, 0);
                else if (noteMode)
                    toggleNote(col, row, numbar.getChosen());
                else
                    setValue(col, row, numbar.getChosen() + 1);
            else
                hovered.set(col, row);
        } else {
            hovered.set(-1, -1);
        }
    }

    public void dump() {
        String[] gridStr = new String[10];
        for (int i = 0; i < 9; i++) {
            gridStr[i] = "";
            for (int j = 0; j < 9; j++) {
                gridStr[i] += isSet[i][j] ? "x" : "";
                gridStr[i] += str(vals[i][j]);
                for (int k = 0; k < 9; k++)
                    gridStr[i] += notes[i][j][k] ? str(k) : "";
                gridStr[i] += ";";
            }
        }
        gridStr[9] = str(puzzleNum);
        saveStrings("save.txt", gridStr);
        messenger.setMessage("Puzzle saved to save.txt.");
    }

    private void generatePuzzle(String[] gridStr) {
        puzzleNum = int(random(gridStr.length));
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                vals[i][j] = gridStr[puzzleNum].charAt(i * 9 + j) - '0';
                isSet[i][j] = (vals[i][j] != 0);
            }
        }
    }

    private void regeneratePuzzle(String[] gridStr) {
        char c;
        int n = 0;
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                if (gridStr[i].charAt(n) == 'x') {
                    isSet[i][j] = true;
                    ++n;
                }
                vals[i][j] = gridStr[i].charAt(n++) - '0';
                while ((c = gridStr[i].charAt(n++)) != ';')
                    notes[i][j][c - '0'] = true;
            }
            n = 0;
        }
        puzzleNum = Integer.parseInt(gridStr[9]);
    }

    private void drawNotes(int col, int row) {
        textSize(15);
        for (int i = 0; i < 9; i++) {
            if (isNoteSet(col, row, i)) {
                float noteX = (col + 0.33 * (i % 3 + .5)) * (sqSize / 9);
                float noteY = (row + 0.33 * (i / 3 + .5)) * (sqSize / 9);
                text(i + 1, noteX, noteY);
            }
        }
    }

    private void setValue(int col, int row, int newVal) {
        vals[row][col] = newVal;
    }

    private int getValue(int col, int row) {
        return vals[row][col];
    }

    private String getValueStr(int col, int row) {
        return (vals[row][col] != 0) ? str(vals[row][col]) : "";
    }

    private boolean isSet(int col, int row) {
        return isSet[row][col];
    }

    private void toggleNote(int col, int row, int val) {
        if (getValue(col, row) == 0)
            notes[row][col][val] = !notes[row][col][val];
    }

    private boolean isNoteSet(int col, int row, int val) {
        if (val < 0 || val > 8)
            return false;
        return notes[row][col][val];
    }

}
