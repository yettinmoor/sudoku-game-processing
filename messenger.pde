class Messenger {
    String message;
    int timer;

    Messenger() {
        timer = 0;
    }

    public void update() {
        if (timer > 0) {
            --timer;
            textAlign(CENTER, CENTER);
            textSize(20);
            text(message, width / 2, 20);
        }
    }

    public void setMessage(String newVal) {
        message = newVal;
        timer = 100;
    }
}
